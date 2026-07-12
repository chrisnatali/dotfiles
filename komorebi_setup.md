# Komorebi Setup for an xmonad-like Windows Laptop

This is the Windows setup for a Komorebi/WHKD environment that approximates my Linux xmonad workflow.

The actual configuration lives in this repo under `windows/`. This document is intentionally concise and does **not** duplicate the config file contents.

## Overview

Linux/xmonad behavior being approximated:

- **Mod key:** `Super`, with Caps Lock remapped to Super
- **Window manager:** xmonad-style keyboard-driven tiling
- **Layouts:** roughly `Tall`, `Mirror Tall`, `Full`, and multi-column variants
- **Launcher:** `Mod+d`
- **Screenshots:** `Mod+Ctrl+s`
- **Suspend:** `Mod+z`
- **Development model:** Windows apps on Windows, development in WSL through Windows terminal tooling

Windows implementation:

- **Komorebi**: tiling window manager
- **WHKD**: hotkey daemon
- **AutoHotkey**: Caps Lock → Left Windows key
- **PowerToys Run**: launcher
- **Windows Snipping Tool / ShareX**: screenshots

## Files in this repo

Current Windows-related files:

```text
windows/
  caps-to-win.ahk
  komorebi.json
  setup_dotfiles.sh
  whkdrc
```

What they do:

- `windows/caps-to-win.ahk`
  - AutoHotkey v2 script mapping Caps Lock to Left Windows key.
- `windows/komorebi.json`
  - Komorebi configuration.
- `windows/whkdrc`
  - WHKD hotkeys for launcher, screenshots, movement, resizing, layouts, workspaces, and Komorebi restart/stop.
- `windows/setup_dotfiles.sh`
  - WSL-side deployment script that copies the Windows config files into Windows config directories on `C:`.

## Important WSL/Windows model

The canonical dotfiles checkout is in WSL:

```text
/home/cjn/src/dotfiles
```

Windows-native programs should read files from normal Windows paths on `C:`, not directly from WSL paths such as `\\wsl$\...`.

So the flow is:

1. Edit config files in WSL under `windows/`.
2. Run the deployment script from WSL.
3. Windows tools read the copied files from `C:\Users\...\.config\...`.

This avoids:

- a second Windows-side dotfiles checkout;
- a Windows SSH key just for dotfiles;
- fragile startup-time dependencies on WSL paths.

## Install prerequisites

Run in **Administrator PowerShell**:

```powershell
winget install LGUG2Z.komorebi
winget install LGUG2Z.whkd
winget install wez.wezterm
winget install DEVCOM.JetBrainsMonoNerdFont
winget install Microsoft.PowerToys
winget install AutoHotkey.AutoHotkey
winget install ShareX.ShareX
```

Optional:

```powershell
winget install VideoLAN.VLC
```

## Initialize Komorebi once

Run in normal Windows PowerShell:

```powershell
komorebic quickstart
komorebic check
komorebic start --whkd
```

This creates initial Komorebi/WHKD config paths. After that, the repo files deployed by `windows/setup_dotfiles.sh` are the source of truth.

## Deploy config files from WSL

From the WSL dotfiles checkout:

```bash
cd /home/cjn/src/dotfiles
./windows/setup_dotfiles.sh
```

The script currently deploys to the Windows user configured inside `windows/setup_dotfiles.sh`.

It copies:

```text
windows/caps-to-win.ahk -> C:\Users\...\.config\autohotkey\caps-to-win.ahk
windows/komorebi.json  -> C:\Users\...\.config\komorebi\komorebi.json
windows/whkdrc         -> C:\Users\...\.config\whkdrc
```

If setting up a different Windows user, update `WIN_HOME` in:

```text
windows/setup_dotfiles.sh
```

## Configure Caps Lock → Left Windows key

After deployment, the AutoHotkey script should exist at:

```text
C:\Users\<windows-user>\.config\autohotkey\caps-to-win.ahk
```

Double-click it once from Windows File Explorer to test it.

To start it automatically on login:

1. Press **Win+r**.
2. Type:

   ```text
   shell:startup
   ```

3. Press **Enter**.
4. In the Startup folder, create a shortcut to:

   ```text
   C:\Users\<windows-user>\.config\autohotkey\caps-to-win.ahk
   ```

5. Name it something like `caps-to-win`.

## Start Komorebi and WHKD

After deploying config:

```powershell
komorebic stop
komorebic start --whkd
```

To enable startup:

```powershell
komorebic enable-autostart --whkd
```

## WHKD notes

The active WHKD config is deployed to:

```text
C:\Users\<windows-user>\.config\whkdrc
```

If WHKD says it cannot load `whkdrc`, check from Windows PowerShell:

```powershell
Test-Path "$env:USERPROFILE\.config\whkdrc"
Get-Content "$env:USERPROFILE\.config\whkdrc" -TotalCount 20
whkd
```

If needed, inspect WHKD's supported config path/options:

```powershell
whkd --help
```

## Validate config

After changing `windows/komorebi.json`:

```bash
./windows/setup_dotfiles.sh
```

Then in Windows PowerShell:

```powershell
komorebic check
komorebic stop
komorebic start --whkd
```

After changing `windows/whkdrc`:

```bash
./windows/setup_dotfiles.sh
```

Then restart WHKD by restarting Komorebi with `--whkd`, or manually stop/start `whkd`.

## Useful reminders

- `Win+d` is a native Windows shortcut for “show desktop”, so it may conflict with WHKD.
- Other `Win+...` combinations may also be intercepted by Windows.
- If `lwin` bindings become unreliable, consider moving more bindings into AutoHotkey using Caps Lock as a custom modifier.
- The current working setup uses the files under `windows/`; prefer changing those files rather than editing deployed copies directly.
