#!/usr/bin/env python3
"""
test_generate_commands.py — Tests unitaires pour scripts/generate_commands.py
Usage : python tests/test_generate_commands.py (depuis workflow-ia/)
"""

import os
import sys
import tempfile
import shutil
from pathlib import Path
import subprocess

SCRIPT_DIR = Path(__file__).parent.parent / "scripts"
GENERATE_SCRIPT = SCRIPT_DIR / "generate_commands.py"

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


def assert_file_exists(desc, filepath):
    if filepath.exists():
        ok(desc)
    else:
        fail(f"{desc} — fichier {filepath} absent")


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
    assert_file_exists("generate_commands.py existe", GENERATE_SCRIPT)


def test_T2_execution():
    print("\nT2 — Exécution du script")
    output_dir = Path(__file__).parent.parent / ".opencode" / "commands"
    result = subprocess.run(
        [sys.executable, str(GENERATE_SCRIPT)],
        capture_output=True,
        text=True,
        cwd=Path(__file__).parent.parent
    )
    assert_exit("exit 0", 0, result.returncode)
    
    if "34 commands generated" in result.stdout:
        ok("34 commands générées")
    else:
        fail(f"Nombre de commands non détecté: {result.stdout}")


def test_T3_output_dir():
    print("\nT3 — Répertoire output")
    output_dir = Path(__file__).parent.parent / ".opencode" / "commands"
    
    if output_dir.exists() and output_dir.is_dir():
        ok("Répertoire .opencode/commands existe")
    else:
        fail("Répertoire .opencode/commands absent")


def test_T4_command_files():
    print("\nT4 — Fichiers de commandes générés")
    output_dir = Path(__file__).parent.parent / ".opencode" / "commands"
    cmd_files = list(output_dir.glob("*.md"))
    
    if len(cmd_files) >= 30:
        ok(f"{len(cmd_files)} fichiers de commandes générés")
    else:
        fail(f"Nombre insuffisant de commandes: {len(cmd_files)} (attendu >= 30)")


def test_T5_context_content():
    print("\nT5 — Contenu d'une commande (context.md)")
    output_dir = Path(__file__).parent.parent / ".opencode" / "commands"
    context_file = output_dir / "context.md"
    
    assert_file_exists("context.md généré", context_file)
    assert_file_contains("Contient description", context_file, "Charge le contexte du projet actif")
    assert_file_contains("Contient memory.md", context_file, "@memory.md")


def test_T6_multiple_commands():
    print("\nT6 — Commandes multiples (start, audit, improve)")
    output_dir = Path(__file__).parent.parent / ".opencode" / "commands"
    
    for name in ["start.md", "audit.md", "improve.md"]:
        f = output_dir / name
        assert_file_exists(f"{name} généré", f)


def test_T7_template_format():
    print("\nT7 — Format template (--- header)")
    output_dir = Path(__file__).parent.parent / ".opencode" / "commands"
    close_file = output_dir / "close.md"
    
    if close_file.exists():
        content = close_file.read_text(encoding="utf-8")
        if content.startswith("---"):
            ok("Format --- header présent")
        else:
            fail("Format --- header absent")
    else:
        fail("close.md absent")


def test_T8_date_injection():
    print("\nT8 — Injection de la date")
    output_dir = Path(__file__).parent.parent / ".opencode" / "commands"
    audit_file = output_dir / "audit.md"
    
    import re
    if audit_file.exists():
        content = audit_file.read_text(encoding="utf-8")
        if re.search(r"\d{4}-\d{2}-\d{2}", content):
            ok("Date injectée (format YYYY-MM-DD)")
        else:
            fail("Date absente du template")
    else:
        fail("audit.md absent")


def test_T9_unique_commands():
    print("\nT9 — Commandes uniques (pas de doublons)")
    output_dir = Path(__file__).parent.parent / ".opencode" / "commands"
    
    names = [f.stem for f in output_dir.glob("*.md")]
    unique_names = set(names)
    
    if len(names) == len(unique_names):
        ok(f"Pas de doublons ({len(names)} fichiers)")
    else:
        fail(f"Doublons détectés: {len(names)} total, {len(unique_names)} unique")


def test_T10_required_commands():
    print("\nT10 — Commandes requises (SSoT)")
    output_dir = Path(__file__).parent.parent / ".opencode" / "commands"
    
    required = ["context", "start", "close", "audit", "improve", "my-world"]
    missing = []
    
    for name in required:
        if not (output_dir / f"{name}.md").exists():
            missing.append(name)
    
    if not missing:
        ok(f"Commandes requises présentes")
    else:
        fail(f"Commandes manquantes: {missing}")


def summary():
    global PASS, FAIL
    print(f"\n=== Resultat : {PASS} OK  {FAIL} FAIL ===")
    return FAIL == 0


if __name__ == "__main__":
    print("=== test_generate_commands.py ===")
    
    test_T1_script_exists()
    test_T2_execution()
    test_T3_output_dir()
    test_T4_command_files()
    test_T5_context_content()
    test_T6_multiple_commands()
    test_T7_template_format()
    test_T8_date_injection()
    test_T9_unique_commands()
    test_T10_required_commands()
    
    success = summary()
    sys.exit(0 if success else 1)
