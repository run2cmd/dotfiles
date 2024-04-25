# run2cmd dotfiles

This is my personal configuration that I use to work day to day. My setup is
Windows OS + WSL2(Debian). My setup mostly resides in WSL but there is some
Windows integration is use, however it is WSL2 based and only few tools are on
Windows so this solution in 100% compatible with any Linux setup.

## Workflow 2.0

I'm doing devops(ich) work so my environment is setup to support multiple
tools. I choose [WezTerm](https://wezfurlong.org/wezterm/index.html) as default
terminal on Windows however multiplexing is mostly done in
[tmux](https://github.com/tmux/tmux). Entire work flow is created around
[NeoVim](https://github.com/neovim/neovim) and its plugins and features. In most cases I
only leave it when I SSH to remote servers.

Previously I used VIM for Windows with WSL2 support but it appeared that VIM on
WSL2 has much better performance.

## Installation

Clone this project into WSL2 instance and Run `install.sh all` to install
all tools.

After 1st install new `dotfiles-update` link is created to which will be available on PATH.
Run `dotfiles-update help` to list available options.

## Technology stack

Entire workflow is build around languages, tools and filetypes I work with day to day.
Configurations is set to focus on them.

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

## Tools

I use [Winget](https://github.com/microsoft/winget-cli) to download software in Windows and APT for
Ubuntu. Some tools are installed based on language they are written in. Check
list of packages.

- [Windows packages](Winfile)
- [Ubuntu packages](Pkgfile)
- [Ruby gems](Gemfile)
- [Python packages](Pythonfile)
- [Nodejs packages](package.json)

I use language version managers:

- [rvm](https://rvm.io/)
- [nvm](https://github.com/nvm-sh/nvm)
- [sdkman](https://sdkman.io/)
- [pyenv](https://github.com/pyenv/pyenv)

## Neovim

I use my own VIM workflow. I like it to be easy and as much automated as
possible. Here are some core features:

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
    - ``f` - Run test including currently open buffer (like specific spec) or execute buffer (like ruby or python code) (See [tests](#tests) section).
    - `<leader>tn`, `<leader>tp` - move to next or previous tab.
    - `<leader>to` - open new tab with Alpha.
    - `<leader>c` - open tmux pane in bottom of the screen and enter buffer root directory(based on autochdir). If pane is already open will only change directory to root directory for buffer.
    - `<leader>f` - Copy open file file path.
    - `<leader>y` - In visual mode copy text to windows clipboard.
    - `<C-w>t` - Easy leave terminal insert mode.
    - `<leader>qo` - Open quickfix window.
    - `<leader>qc` - Close quickfix window.
    - `]q`, `[q` - Got to previous/next item on quickfix list.
    - `]l`, `[l` - Got to previous/next item on loclist list.
    - `<leader>ll` - Delete all open buffers (not files) and restart LSP servers.
    - `<leader>p` - Register list.
    - `<C-n>` - Open notes file TODO.
    Work with projects:
    - ``t` - Run tests for entire project like gradle, maven rake (See [tests](#tests) section).
    - ``l` - Repeat last run tests regardless of open buffer (See [tests](#tests) section).
    - `<leader>rk` - Run r10k in terminal (support for Puppet)
    - `<leader>sw` - Search for word under cursor in current project.
    - `<leader>sl` - Live search in current project.
    - `<leader>sb` - Live search in current buffer.
    - `<leader>t` - Jump to test file for current open file. This supports ruby, groovy and puppet.
    - LSP key bindings:
        - `K` - LSP hover.
        - `<leader>bf` - LSP format.
        - `<leader>br` - LSP rename.
        - `]d` - LSP next diagnostic message.
        - `[d` - LSP previous diagnostic message.
    Git support:
    - `<leader>gg` - Enter git status window.
    - `<leader>ge` - Search for Git conflicts project wide.
    - `<leader>gf` - Git pull.
    - `<leader>gp` - Git push.
    - `<leader>gw` - Git blame.
    - `<leader>gc` - Git checkout (choose branch/tag/commit with autocompletion).
    - `<leader>g-` - Checkout to previous branch/tag/commit.
    - `<leader>gm` - Git merge (choose branch/tag/commit with autocompletion).
    - `<leader>gss` - Git stash.
    - `<leader>gsp` - Git stash pop.
    - `<leader>gv` - Diff split on current buffer.
    - `<leader>gdo` - Open DiffView in new tab for current project.
    - `<leader>gdc` - Close DiffView.
    - `<leader>gdr` - Refreash DiffView.
    - `<leader>gll` - List git commits in simple view.
    - `<leader>glp` - List git commits in detail view (with commit author, date and changes). Use `[[` and `]]` to jump between commits.
    - `<leader>glf` - List git commits in detail view for specific file.
    - `<leader>gb` - List git branches. Use `<CR>` to change branch or `<c-t>` to checkout branch if not checkout before.
    Move around filesystem:
    - `<C-p>` - List files in current project and go to it after `<CR>` is hit.
    - `<C-h>` - Same as `<c-p>` but for open buffers.
    - `<C-k>` - List of projects in '/code' path. Assuming they are git projects will list projects following pattern: `/code/<project-group>/<repository-name>`.
    - `<C-s>` - List all files in project (with no ignore and hidden enabled).

### Tests

I use my own easy test implementation to run in new tmux pane placed in bottom of the screen. Following are goals for this:

- Support for both projects and files tests.
- Be able to run test for project, file, or setup to prepare environment.
- Tests needs to run per project based on autochdir and root markers like `.git`, `.svn`.
- Single test window per project. Running new test against project will close previous test window and open new one.
- Be able to run test for different projects/files in separate windows.
- Ruse same tmux pane.

## Docker Desktop

To have Systemd work in Docker images you need to create `systemd` cgroup in
Docker WSL. This might work out of the box with Docker on WSL2.

```bash
mkdir -p /sys/fs/cgroup/systemd
mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
```

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

```# Fix for VPN
if ip addr | grep eth0 | grep -q 1500 ;then ~/bin/vpnfix ; fi
```
