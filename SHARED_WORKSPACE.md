# IE 335 — Shared Session Workspace

This project is set up as a **shared session workspace** for IE 335. Multiple people and devices can work on it via Git and (optionally) Cursor Live Share.

---

## Quick start (new collaborator or new device)

```bash
# 1. Clone the repo (replace URL with your actual remote)
git clone https://github.com/YOUR_ORG/ie335-workspace.git
cd ie335-workspace

# 2. Before every work session — get latest changes
git pull origin main

# 3. Make your edits, then share them
git add .
git commit -m "Brief description of your changes"
git push origin main
```

---

## Setting up the remote (one-time)

If you created this repo locally and need to add a remote:

```bash
# GitHub example
git remote add origin https://github.com/YOUR_USERNAME/ie335-workspace.git

# Or SSH
git remote add origin git@github.com:YOUR_USERNAME/ie335-workspace.git
```

Create the `ie335-workspace` repository on GitHub/GitLab first, then run the command above.

---

## Shared workflow

| Step | Action |
|------|--------|
| **Before you start** | `git pull origin main` |
| **While working** | Edit files as usual |
| **When you’re done** | `git add .` → `git commit -m "message"` → `git push origin main` |

Coordinate with teammates to avoid editing the same files at the same time when possible (reduces merge conflicts).

---

## Cursor Live Share (real-time pair programming)

To work in the **same Cursor session** with someone in real time:

1. **Install the Live Share extension** (if you don’t see the command):
   - Press `Ctrl+Shift+X` to open Extensions.
   - Search for **Live Share** and install the one by **Microsoft** (ms-vsliveshare).
   - Reload Cursor if prompted.

2. **Start a session:**
   - Press `Ctrl+Shift+P` to open the Command Palette.
   - Type **live share** or **start collaboration**.
   - Run **"Live Share: Start Collaboration Session"** (or **"Live Share: Share"**).
   - Or use the **Live Share** button in the bottom status bar (after installing).

3. **Share the link** with your partner. They open it in a browser or Cursor and join.

Live Share is for **live pairing**. Git is for **async collaboration** and **history** — use both as needed.

---

## Project structure

- `HW0/` — Homework 0 (fern, `verify_installation`, etc.)
- `Gauss*.m`, `VerifyGauss*.m` — Gaussian elimination / verification
- `fern1.m`, `untitled.m` — Scratch / experiments

---

## Branching (optional)

For bigger changes or separate features:

```bash
git checkout -b feature/my-feature
# ... edit ...
git add . && git commit -m "Add my feature"
git push -u origin feature/my-feature
```

Then open a Pull Request on GitHub/GitLab to merge into `main`.

---

## Authentication

- **HTTPS:** Use a **Personal Access Token** instead of your password when pushing.
- **SSH:** Add your SSH key to your GitHub/GitLab account and use the SSH clone URL.

---

*IE 335 Shared Workspace — pull before you start, push when you’re done.*
