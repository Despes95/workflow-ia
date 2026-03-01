#!/usr/bin/env python3
"""
vault_sync.py — Version Python de obsidian-sync.sh
Synchronise memory.md vers le vault Obsidian.
Usage : python scripts/vault_sync.py (depuis workflow-ia/)
"""

import os
import re
import subprocess
import sys
from datetime import datetime
from pathlib import Path

SCRIPT_DIR = Path(__file__).parent
CONFIG_FILE = SCRIPT_DIR / "config.env"
MEMORY_FILE = Path("memory.md")


def load_config():
    config = {}
    if CONFIG_FILE.exists():
        with open(CONFIG_FILE, encoding="utf-8") as f:
            for line in f:
                line = line.strip()
                if line and not line.startswith("#") and "=" in line:
                    key, value = line.split("=", 1)
                    key = key.replace("_WIN", "")
                    config[key] = value.strip('"\'').replace("/", "\\")
    return config


def get_project_name():
    return Path.cwd().name


def extract_section(content, pattern):
    section = []
    in_section = False
    for line in content.splitlines():
        if re.match(rf"^##\s+{pattern}", line):
            in_section = True
        elif in_section and line.startswith("##"):
            in_section = False
        elif in_section:
            section.append(line)
    return "\n".join(section)


def clean_section(text):
    if not text:
        return ""
    lines = [l for l in text.splitlines() if l.strip()]
    return "\n".join(lines)


def check_icloud(forge_dir):
    try:
        result = subprocess.run(
            ["timeout", "10", "ls", str(forge_dir)],
            capture_output=True,
            text=True,
            timeout=15
        )
        return result.returncode == 0
    except Exception:
        return False


def init_file(filepath, template_content):
    if not filepath.exists():
        filepath.parent.mkdir(parents=True, exist_ok=True)
        with open(filepath, "w", encoding="utf-8") as f:
            f.write(template_content)
        print(f"  Created: {filepath.name}")


def rotate_sessions(filepath, max_sessions=10):
    if not filepath.exists():
        return
    with open(filepath, encoding="utf-8") as f:
        content = f.read()
    
    sessions = re.findall(r"(## Session \d{8}-\d{6})", content)
    if len(sessions) <= max_sessions:
        return
    
    to_skip = len(sessions) - max_sessions
    session_pattern = r"(## Session \d{8}-\d{6})"
    matches = list(re.finditer(session_pattern, content))
    
    if to_skip >= len(matches):
        return
    
    first_session_pos = matches[0].start()
    header = content[:first_session_pos]
    
    keep_from = matches[to_skip].start()
    remaining = content[keep_from:]
    
    with open(filepath, "w", encoding="utf-8") as f:
        f.write(header + remaining)
    print(f"  Rotation sessions.md ({len(sessions)} -> {max_sessions})")


def append_to_file(filepath, title, content):
    timestamp = datetime.now().strftime("%Y-%m-%d")
    with open(filepath, "a", encoding="utf-8") as f:
        f.write(f"\n---\n\n### {title} du {timestamp}\n\n{content}\n")


def update_index_stats(index_file, session_count, lesson_count, bug_count):
    if not index_file.exists():
        return
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    with open(index_file, encoding="utf-8") as f:
        content = f.read()
    
    content = re.sub(
        r"> Dernière sync : .*",
        f"> Dernière sync : {timestamp}",
        content
    )
    content = re.sub(
        r"- \*\*Sessions\*\*: \d+",
        f"- **Sessions**: {session_count}",
        content
    )
    content = re.sub(
        r"- \*\*Leçons\*\*: \d+",
        f"- **Leçons**: {lesson_count}",
        content
    )
    content = re.sub(
        r"- \*\*Bugs résolus\*\*: \d+",
        f"- **Bugs résolus**: {bug_count}",
        content
    )
    if "- **Sessions**:" not in content:
        content = re.sub(
            r"(> Dernière sync : .*)",
            f"\\1\n- **Sessions**: {session_count}\n- **Leçons**: {lesson_count}\n- **Bugs résolus**: {bug_count}",
            content
        )
    
    with open(index_file, "w", encoding="utf-8") as f:
        f.write(content)


def sync_to_vault(config):
    project_name = get_project_name()
    forge_dir = Path(config.get("FORGE_DIR", ""))
    global_dir = Path(config.get("GLOBAL_DIR", ""))
    
    if not forge_dir:
        print("ERROR: FORGE_DIR not defined in config.env")
        sys.exit(1)
    
    if not MEMORY_FILE.exists():
        print(f"ERROR: {MEMORY_FILE} not found. Run from workflow-ia/")
        sys.exit(1)
    
    print("Checking iCloud...")
    if not forge_dir.exists():
        print(f"WARNING: iCloud Drive folder not found: {forge_dir}")
        sys.exit(1)
    
    project_dir = forge_dir / project_name
    project_dir.mkdir(parents=True, exist_ok=True)
    print(f"Forge: {project_dir}")
    
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M")
    date_str = datetime.now().strftime("%Y-%m-%d")
    session_id = datetime.now().strftime("%Y%m%d-%H%M%S")
    
    with open(MEMORY_FILE, encoding="utf-8") as f:
        memory_content = f.read()
    
    init_file(
        project_dir / "index.md",
        f"""# {project_name} — Index

> Dernière sync : {timestamp}

## 📊 Statistiques
- **Sessions** : 0
- **Leçons** : 0
- **Bugs résolus** : 0

## 📂 Fichiers du vault

| Fichier | Rôle |
|---|---|
| [[sessions]] | Snapshots de memory.md par session |
| [[decisions]] | Décisions d'architecture |
| [[bugs]] | Bugs connus et résolus |
| [[features]] | Fonctionnalités en cours et planifiées |
| [[lessons]] | Leçons apprises |
| [[architecture]] | Vue d'ensemble technique |
| [[ideas]] | Idées et pistes à explorer |
"""
    )
    
    for filename, title in [
        ("sessions.md", f"{project_name} — Sessions\n\n> Snapshots automatiques de memory.md"),
        ("decisions.md", f"{project_name} — Décisions\n\n> Décisions d'architecture importantes"),
        ("bugs.md", f"{project_name} — Bugs\n\n> Bugs connus, en cours et résolus"),
        ("features.md", f"{project_name} — Features\n\n> Fonctionnalités en cours et planifiées"),
        ("lessons.md", f"{project_name} — Leçons apprises\n\n> Extraites automatiquement depuis memory.md"),
        ("architecture.md", f"{project_name} — Architecture\n\n> Vue d'ensemble technique"),
        ("ideas.md", f"{project_name} — Idées\n\n> Pistes et idées à explorer"),
    ]:
        init_file(project_dir / filename, f"# {title}\n")
    
    bugs_cleaned = clean_section(extract_section(memory_content, "🐛"))
    lessons_cleaned = clean_section(extract_section(memory_content, "📝"))
    decisions_cleaned = clean_section(extract_section(memory_content, "📚"))
    
    focus_snap = extract_section(memory_content, "🎯")
    momentum_snap = extract_section(memory_content, "🧠")
    arch_snap = extract_section(memory_content, "🏗️")
    
    session_entry = f"""
---

## Session {session_id}

> Sync automatique — {timestamp}

"""
    if focus_snap:
        session_entry += "### 🎯 Focus Actuel\n\n" + focus_snap + "\n\n"
    if momentum_snap:
        session_entry += "### 🧠 Momentum\n\n" + momentum_snap + "\n\n"
    if arch_snap:
        session_entry += "### 🏗️ Architecture\n\n" + arch_snap + "\n\n"
    
    if lessons_cleaned:
        session_entry += "> [!insight]\n"
        for line in lessons_cleaned.splitlines():
            session_entry += f"> {line}\n"
        session_entry += "\n"
    
    if bugs_cleaned:
        session_entry += "> [!warning]\n"
        for line in bugs_cleaned.splitlines():
            session_entry += f"> {line}\n"
        session_entry += "\n"
    
    if decisions_cleaned:
        session_entry += "> [!decision]\n"
        for line in decisions_cleaned.splitlines():
            session_entry += f"> {line}\n"
        session_entry += "\n"
    
    if lessons_cleaned:
        session_entry += "→ [[lessons]]\n"
    if bugs_cleaned:
        session_entry += "→ [[bugs]]\n"
    if decisions_cleaned:
        session_entry += "→ [[decisions]]\n"
    
    sessions_file = project_dir / "sessions.md"
    with open(sessions_file, "a", encoding="utf-8") as f:
        f.write(session_entry)
    print("  Snapshot added: sessions.md")
    
    if bugs_cleaned:
        append_to_file(project_dir / "bugs.md", "Extrait", bugs_cleaned)
        print("  Bugs extracted -> bugs.md")
    
    if lessons_cleaned:
        append_to_file(project_dir / "lessons.md", "Leçons", lessons_cleaned)
        print("  Lessons extracted -> lessons.md")
    
    if decisions_cleaned:
        append_to_file(project_dir / "decisions.md", "Décisions", decisions_cleaned)
        print("  Decisions extracted -> decisions.md")
    
    s_count = len(re.findall(r"## Session", sessions_file.read_text(encoding="utf-8")))
    l_count = len(re.findall(r"### Leçons du", (project_dir / "lessons.md").read_text(encoding="utf-8")))
    b_count = len(re.findall(r"### Extrait du", (project_dir / "bugs.md").read_text(encoding="utf-8")))
    
    update_index_stats(project_dir / "index.md", s_count, l_count, b_count)
    print("  Stats index.md updated")
    
    rotate_sessions(sessions_file, 10)
    
    if global_dir.exists() and lessons_cleaned:
        global_lessons_lines = [l for l in lessons_cleaned.splitlines() if "GLOBAL" in l or "🌐" in l]
        if global_lessons_lines:
            global_lessons = "\n".join(global_lessons_lines)
            append_to_file(
                global_dir / "lessons.md",
                f"Lecons globales ({project_name})",
                global_lessons
            )
            print("  Global lessons added")
    
    if (global_dir / "index.md").exists():
        with open(global_dir / "index.md", encoding="utf-8") as f:
            global_index = f.read()
        global_index = re.sub(
            r"\*\*Derniere mise a jour:\*\*.*",
            f"**Derniere mise a jour:** {date_str}",
            global_index
        )
        global_index = re.sub(
            r"- Dernier projet actif:.*",
            f"- Dernier projet actif: {project_name} ({date_str})",
            global_index
        )
        with open(global_dir / "index.md", "w", encoding="utf-8") as f:
            f.write(global_index)
        print("  _global/index.md updated")
    
    print(f"\nSync done -- {timestamp}")
    print(f"   Vault: {project_dir}")
    print(f"   Files: {len(list(project_dir.glob('*')))} present")


def main():
    config = load_config()
    sync_to_vault(config)


if __name__ == "__main__":
    main()
