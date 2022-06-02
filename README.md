# run2cmd dotfiles

This is my personal configuration that I use to work day to day. My setup is Windows OS + WSL2(Debian). My setup mostly resides in WSL but there is some Windows integration is use, however it is WSL2 based and only few tools are on Windows so this solution in 100% compatible with any Linux setup.

## Workflow 2.0

I'm doing devops(ich) work so my environment is setup to support multiple tools. I choose [WezTerm](https://wezfurlong.org/wezterm/index.html) as default terminal on Windows however multiplexing is mostly done in [tmux](https://github.com/tmux/tmux). Entire work flow is created around [Vim](https://github.com/vim/vim) and its plugins and features. In most cases I only leave it when I SSH to remote servers.

Previously I used VIM for Windows with WSL2 support but it appeared that VIM on WSL2 has much better performance.

## Installation

Clone this project into WSL2 instance and Run `install.sh` to install/update all tools.

## Tools

I use [Scoop](https://scoop.sh/) to download software in Windows and APT for Ubuntu. Some tools are installed based on language they are written in. Check list of packages.

- [Scoop packages](Scoopfile)
- [Ubuntu packages](Rpmfile)
- [Ruby gems](Gemfile)
- [Python packages](Pythonfile)
- [Nodejs packages](package.json)

I use language version managers:

- [rvm](https://rvm.io/)
- [nvm](https://github.com/nvm-sh/nvm)
- [sdkman](https://sdkman.io/)
- [pyenv](https://github.com/pyenv/pyenv) 

For browsing I use [Vieb](https://vieb.dev/) because I love speed and easy of using Vim keybindings.
[WezTerm](https://wezfurlong.org/wezterm/index.html) as terminal on Windows however [tmux](https://github.com/tmux/tmux) as multiplexer.

## Docker Desktop

To have Systemd work in Docker images you need to create `systemd` cgroup in Docker WSL.

```bash
mkdir -p /sys/fs/cgroup/systemd
mount -t cgroup -o none,name=systemd cgroup /sys/fs/cgroup/systemd
```

## VIM

I use my own VIM workflow. I like it to be easy and as much automated as possible. Here are some core features:

- Mapleader is set to `space`. It's just so much easier.
- Mostly oriented around Ruby, Python, Bash, Groovy and Puppet.
- Use my own color scheme. It was based on `default` but evolved a lot into different direction.
- Do not create any backup or swap files, only changes history.
- No GUI or Mouse support. Keyboard-crazy mode enabled :).
- No sounds enabled.
- Auto save enabled on all files.
- Additional `~/.vimlocal` configuration support in case you need configuration that is not ment to be in this project.
- Some nice keybinding:
  + Arrow keys re-size window
  + <leader>c(normal) - open terminal.
  + <leader>c(visual) - copy text to windows clipboard.
  + vaf - select function/definition based on filetype.
  + :Bash <cmd> - Run command in terminal.
  + <c-p> - FZF file list in project.
  + <c-k> - FZF project list in `projectDirectoryPath`. See .vimrc for details.
  + :Doc - Call [cht.sh](https://cht.sh/) API.
  + <leader>bd - close all buffers.
  + <c-l> - clear all searches.
  + <leader>o - open new tab.
  + <leader>w, <leader>b - move to next or previous tab.
  + <leader>gc - search for Git conflicts after rebase or merge across entire project.
  + <leader>s - search word under cursor in entire project.
  + Tests based on project type (Gradle, Maven, Puppet, etc.)
    + \`t - Run project test.
    + \`a - Run alternate project test if set.
    + \`f - Run filetype test.
    + \`l - Rerun last test.
    + <leader>e - In test window search for errors and failures.
