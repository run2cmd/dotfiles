# run2cmd dotfiles

This is my personal configuration that I use to work day to day. My setup is Windows OS + WSL2(Debian). My setup mostly resides in WSL but there is some Windows integration is use, however it is WSL2 based and only few tools are on Windows so this solution in 100% compatible with any Linux setup.

## Workflow 3.0

I'm doing devops(ich) work so my environment is setup to support multiple tools. Use your favorite terminal but multiplexing is mostly done in [tmux](https://github.com/tmux/tmux) with [NeoVim](https://github.com/neovim/neovim) as main editor.

## Installation

Clone this project into WSL2 instance and Run `install.sh all` to install all tools.

After 1st install new `dotfiles-update` link is created to which will be available on PATH. Run `dotfiles-update help` to list available options.

Bare in mind that a lot of tools have Git based installation. Running `dotfiles-update` often might cause timeout from `github.com` page due to connection limit.

## Optimize WSL disk space

This is useful if any of WSL instances reserves a lot of space that was used in the past. Run in PowerShell:

```pwershell
# vhdx-path:
# - Docker = C:\Users\[user_name]\AppData\Local\Docker\wsl\data\ext4.vhdx
# - Debian/Ubuntu = C:\Users\[user_name]\AppData\Local\Packages\[look something with debian or ubuntu]\LocalState\ext4.vhdx
optimize-vhd -Path [vhdx-path] -Mode full
```

## MTU fix for VPN

Useful in case of VPN restrictions. Add following to `~/.bashrc`:

```bash
# Fix for VPN
if ip addr | grep eth0 | grep -q 1500 ;then ~/bin/vpnfix ; fi
```

## Remap caps lock as ctrl on windows

You need to edit/add `Scancode Map` Binary key in registry (regedit) path `Computer\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Keyboard Layout` and set it to following value:

```
00 00 00 00 00 00 00 00
03 00 00 00 1D 00 3A 00
3A 00 00 00 00 00 00 00
```
