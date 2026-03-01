#!/usr/bin/env python3
"""
test_vault_sync.py — Tests unitaires pour scripts/vault_sync.py
Usage : python tests/test_vault_sync.py (depuis workflow-ia/)
"""

import os
import sys
import tempfile
from pathlib import Path
from datetime import datetime

SCRIPT_DIR = Path(__file__).parent.parent / "scripts"
VAULT_SCRIPT = SCRIPT_DIR / "vault_sync.py"

sys.path.insert(0, str(SCRIPT_DIR))

PASS = 0
FAIL = 0


def ok(msg):
    global PASS
    print(f"  [OK] {msg}")
    PASS += 1


def fail(msg):
    global FAIL
    print(f"  [FAIL] {msg}")
    FAIL += 1


def assert_exit(desc, expected, actual):
    if actual == expected:
        ok(f"{desc} (exit {actual})")
    else:
        fail(f"{desc} — attendu exit {expected}, obtenu {actual}")


def assert_contains(desc, pattern, output):
    if pattern in output:
        ok(desc)
    else:
        fail(f"{desc} — pattern '{pattern}' absent")


def assert_file_contains(desc, filepath, pattern):
    if filepath.exists():
        content = filepath.read_text(encoding="utf-8")
        if pattern in content:
            ok(desc)
        else:
            fail(f"{desc} — pattern '{pattern}' absent dans {filepath.name}")
    else:
        fail(f"{desc} — fichier {filepath} absent")


def test_T1_script_exists():
    print("\nT1 — Script existe")
    if VAULT_SCRIPT.exists():
        ok("vault_sync.py existe")
    else:
        fail("vault_sync.py absent")


def test_T2_extract_section():
    print("\nT2 — Extraction de section")
    with tempfile.TemporaryDirectory() as tmpdir:
        sys.path.insert(0, str(SCRIPT_DIR))
        import importlib.util
        spec = importlib.util.spec_from_file_location("vault_sync", VAULT_SCRIPT)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        
        content = """## 🎯 Focus
focus content line 1
focus content line 2

## 🧠 Momentum
momentum content

## 📝 Leçons
lesson 1
lesson 2
"""
        result = module.extract_section(content, "🎯")
        if "focus content line 1" in result:
            ok("Section FOCUS extraite")
        else:
            fail(f"Section FOCUS non extraite: {result}")


def test_T3_clean_section():
    print("\nT3 — Nettoyage section (supprime lignes vides)")
    with tempfile.TemporaryDirectory() as tmpdir:
        sys.path.insert(0, str(SCRIPT_DIR))
        import importlib.util
        spec = importlib.util.spec_from_file_location("vault_sync", VAULT_SCRIPT)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        
        text = "line1\n\n\nline2\n\n"
        result = module.clean_section(text)
        
        if result == "line1\nline2":
            ok("Lignes vides supprimées")
        else:
            fail(f"Nettoyage échoué: '{result}'")


def test_T4_rotate_sessions():
    print("\nT4 — Rotation sessions (max 10)")
    with tempfile.TemporaryDirectory() as tmpdir:
        sys.path.insert(0, str(SCRIPT_DIR))
        import importlib.util
        spec = importlib.util.spec_from_file_location("vault_sync", VAULT_SCRIPT)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        
        sessions_file = Path(tmpdir) / "sessions.md"
        content = ""
        for i in range(15):
            content += f"## Session 20260{100+i:02d}-120000\ncontenu session {i}\n\n"
        sessions_file.write_text(content, encoding="utf-8")
        
        module.rotate_sessions(sessions_file, 10)
        
        remaining = sessions_file.read_text(encoding="utf-8")
        session_count = remaining.count("## Session")
        
        if session_count == 10:
            ok(f"Rotation ok ({session_count} sessions restantes)")
        else:
            fail(f"Rotation échouée: {session_count} sessions (attendu 10)")


def test_T5_rotate_no_change():
    print("\nT5 — Rotation sessions (pas de changement si < max)")
    with tempfile.TemporaryDirectory() as tmpdir:
        sys.path.insert(0, str(SCRIPT_DIR))
        import importlib.util
        spec = importlib.util.spec_from_file_location("vault_sync", VAULT_SCRIPT)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        
        sessions_file = Path(tmpdir) / "sessions.md"
        sessions_file.write_text(
            "## Session 20260101-120000\ncontenu\n\n## Session 20260102-120000\ncontenu\n",
            encoding="utf-8"
        )
        orig_mtime = sessions_file.stat().st_mtime
        
        import time
        time.sleep(0.1)
        module.rotate_sessions(sessions_file, 10)
        
        if sessions_file.stat().st_mtime == orig_mtime:
            ok("Fichier inchangé (pas de rotation needed)")
        else:
            fail("Fichier modifié alors que pas needed")


def test_T6_append_to_file():
    print("\nT6 — Ajout à un fichier")
    with tempfile.TemporaryDirectory() as tmpdir:
        sys.path.insert(0, str(SCRIPT_DIR))
        import importlib.util
        spec = importlib.util.spec_from_file_location("vault_sync", VAULT_SCRIPT)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        
        target_file = Path(tmpdir) / "test.md"
        target_file.write_text("# Test\n", encoding="utf-8")
        
        module.append_to_file(target_file, "TestSection", "contenu ajouté")
        
        content = target_file.read_text(encoding="utf-8")
        if "contenu ajouté" in content and "TestSection" in content:
            ok("Contenu append")
        else:
            fail(f"Append échoué: {content}")


def test_T7_load_config():
    print("\nT7 — Chargement config (test système)")
    sys.path.insert(0, str(SCRIPT_DIR))
    import importlib.util
    spec = importlib.util.spec_from_file_location("vault_sync", VAULT_SCRIPT)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    
    config = module.load_config()
    
    if config.get("FORGE_DIR"):
        ok("Config FORGE_DIR chargee")
    else:
        fail(f"FORGE_DIR absent: {config}")


def test_T8_load_config_missing():
    print("\nT8 — Module chargeable")
    sys.path.insert(0, str(SCRIPT_DIR))
    import importlib.util
    spec = importlib.util.spec_from_file_location("vault_sync_check", VAULT_SCRIPT)
    module = importlib.util.module_from_spec(spec)
    try:
        spec.loader.exec_module(module)
        ok("Module chargeable")
    except Exception as e:
        fail(f"Module non chargeable: {e}")


def test_T9_get_project_name():
    print("\nT9 — Nom du projet (cwd)")
    with tempfile.TemporaryDirectory() as tmpdir:
        sys.path.insert(0, str(SCRIPT_DIR))
        import importlib.util
        spec = importlib.util.spec_from_file_location("vault_sync", VAULT_SCRIPT)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        
        original_cwd = Path.cwd()
        try:
            os.chdir(tmpdir)
            name = module.get_project_name()
            
            if name == Path(tmpdir).name:
                ok(f"Project name: {name}")
            else:
                fail(f"Project name incorrect: {name}")
        finally:
            os.chdir(original_cwd)


def test_T10_init_file():
    print("\nT10 — Init fichier (création si absent)")
    with tempfile.TemporaryDirectory() as tmpdir:
        sys.path.insert(0, str(SCRIPT_DIR))
        import importlib.util
        spec = importlib.util.spec_from_file_location("vault_sync", VAULT_SCRIPT)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        
        target = Path(tmpdir) / "subdir" / "newfile.md"
        
        module.init_file(target, "# Titre\ncontenu")
        
        if target.exists():
            ok("Fichier créé")
            assert_file_contains("Contenu correct", target, "# Titre")
        else:
            fail("Fichier non créé")


def test_T11_init_file_exists():
    print("\nT11 — Init fichier (pas de modification si existant)")
    with tempfile.TemporaryDirectory() as tmpdir:
        sys.path.insert(0, str(SCRIPT_DIR))
        import importlib.util
        spec = importlib.util.spec_from_file_location("vault_sync", VAULT_SCRIPT)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        
        target = Path(tmpdir) / "existing.md"
        target.write_text("# Existant\n", encoding="utf-8")
        
        import time
        time.sleep(0.1)
        module.init_file(target, "# Nouveau\n")
        
        content = target.read_text(encoding="utf-8")
        if "# Existant" in content:
            ok("Fichier existant non modifié")
        else:
            fail("Fichier existant écrasé")


def test_T12_update_index_stats():
    print("\nT12 — Mise a jour des stats index")
    with tempfile.TemporaryDirectory() as tmpdir:
        sys.path.insert(0, str(SCRIPT_DIR))
        import importlib.util
        spec = importlib.util.spec_from_file_location("vault_sync", VAULT_SCRIPT)
        module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(module)
        
        index_file = Path(tmpdir) / "index.md"
        index_file.write_text(
            "> Derni\u00e8re sync : 2026-01-01 00:00\n-**Sessions**: 5\n-**Le\u00e7ons**: 3\n-**Bugs r\u00e9solus**: 2\n",
            encoding="utf-8"
        )
        
        try:
            module.update_index_stats(index_file, 12, 8, 4)
            content = index_file.read_text(encoding="utf-8")
            if "12" in content and "8" in content:
                ok("Stats mises a jour")
            else:
                fail(f"Stats non mises a jour: {content}")
        except Exception as e:
            fail(f"Exception: {e}")


def summary():
    global PASS, FAIL
    print(f"\n=== Resultat : {PASS} OK  {FAIL} FAIL ===")
    return FAIL == 0


if __name__ == "__main__":
    print("=== test_vault_sync.py ===")
    
    test_T1_script_exists()
    test_T2_extract_section()
    test_T3_clean_section()
    test_T4_rotate_sessions()
    test_T5_rotate_no_change()
    test_T6_append_to_file()
    test_T7_load_config()
    test_T8_load_config_missing()
    test_T9_get_project_name()
    test_T10_init_file()
    test_T11_init_file_exists()
    test_T12_update_index_stats()
    
    success = summary()
    sys.exit(0 if success else 1)
