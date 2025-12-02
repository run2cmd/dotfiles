# run2cmd dotfiles

This is my personal configuration that I use to work day to day. My setup is Windows OS + WSL2(Debian). My setup mostly resides in WSL but there is some Windows integration is use, however it is WSL2 based and only few tools are on Windows so this solution in 100% compatible with any Linux setup.

## Workflow 2.0

I'm doing devops(ich) work so my environment is setup to support multiple tools. Use your favorite terminal but multiplexing is mostly done in [tmux](https://github.com/tmux/tmux). Entire work flow is created around [NeoVim](https://github.com/neovim/neovim) and its plugins and features. In most cases I only leave it when I SSH to remote servers.

Previously I used VIM for Windows with WSL2 support but it appeared that VIM on WSL2 has much better performance.

## Installation

Clone this project into WSL2 instance and Run `install.sh all` to install all tools.

After 1st install new `dotfiles-update` link is created to which will be available on PATH. Run `dotfiles-update help` to list available options.

Bare in mind that a lot of tools have Git based installation. Running `dotfiles-update` often might cause timeout from `github.com` page due to connection limit.

## Technology stack

Entire workflow is build around languages, tools and filetypes I work with day to day. Configurations is set to focus on them.

- Puppet
- Ansible
- Python
- Ruby
- Json
- Yaml
- Bash
- Docker
- Helm
- Lua
- Vim Script
- Xml
- Markdown
- Groovy
- Jenkins Pipeline
- Go
- Terraform
- Terragrunt
- Lazygit
- gh (GitHub)
- copilot (GitHub Copilot)

## Tools

The basic idea is to first try to install tools using system packaging (apt) then for specific language using ruby, python etc, and then use [install-release](https://github.com/Rishang/install-release) for everything else.

Most of the configuration for installation is in [config.yaml](config.yaml) file. For now only ruby and nodejs has separate package configuration.

Check list of packages:

- [config.yaml](config.yaml)
- [Ruby gems](Gemfile)
- [Nodejs packages](package.json)

I use language version managers:

- [rvm](https://rvm.io/)
- [nvm](https://github.com/nvm-sh/nvm)
- [sdkman](https://sdkman.io/)
- [pyenv](https://github.com/pyenv/pyenv)
- [tfenv](https://github.com/tfutils/tfenv)

## Neovim

I use my own VIM workflow. I like it to be easy and as much automated as possible. Here are some core features:

- LSP support enabled by default. Support for languages and filetypes I work with.
- Automcompletion enabled by default. Utilize LSP, buffers and snippets.
- Mapleader is set to `space`. It's just so much easier.
- Windows clipboard integration. Keys `<leader>y` will copy to `+` register and clip.exe allowing both Windows and Tmux read it.
- Do not create any backup or swap files, only undo changes history.
- No GUI or Mouse support. Keyboard-crazy mode enabled :).
- No sounds enabled.
- Auto save enabled on all files when leaving insert mode.
- Disable arrow keys. We go pure Vim hardcode mode.
- Custom keybindings:
    - `<c-l>` - Clear search and update diff.
    - `<leader>tn`, `<leader>tp` - move to next or previous tab.
    - `<leader>to` - open new tab with Alpha.
    - `<leader>c` - open tmux floating window in current working directory.
    - `<leader>f` - Copy open file file path.
    - `<leader>y` - In visual mode copy text to windows clipboard.
    - `<leader>qo` - Open quickfix window.
    - `<leader>qc` - Close quickfix window.
    - `]q`, `[q` - Got to previous/next item on quickfix list.
    - `]l`, `[l` - Got to previous/next item on loclist list.
    - `<leader>ll` - Delete all open buffers (not files) and restart LSP servers.
    - `<leader>p` - Register list.
    - `<C-n>` - Open notes file TODO.
    - Work with projects:
      - `<leader>rk` - Run r10k in terminal (support for Puppet)
      - `<leader>sw` - Search for word under cursor in current project.
      - `<leader>sl` - Live search in current project.
      - `<leader>sb` - Live search in current buffer.
      - LSP key bindings:
        - `K` - LSP hover.
        - `<leader>bf` - LSP format.
        - `<leader>br` - LSP rename.
        - `]d` - LSP next diagnostic message.
        - `[d` - LSP previous diagnostic message.
    - Git support:
      - `<leader>gg` - Open lazygit.
      - `<leader>gdo` - Open DiffView in new tab for current project.
      - `<leader>gdc` - Close DiffView.
      - `<leader>gdr` - Refreash DiffView.
    - GitHub support:
      - `<leader>sp` - List GitHub pull requests.
      - `<leader>sr` - List GitHub Actions runs.
    - Move around filesystem:
      - `<C-p>` - List files in current project and go to it after `<CR>` is hit.
      - `<C-h>` - Same as `<c-p>` but for open buffers.
      - `<C-k>` - List of projects in '/code' path. Assuming they are git projects will list projects following pattern: `/code/<project-group>/<repository-name>`.
      - `<C-s>` - List all files in project (with no ignore and hidden enabled).

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
