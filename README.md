# run2cmd dotfiles

This is my personal configuration that I use to work day to day. It primary focuses on Windows since that is my workspace but should work on Linux to (mostly).

## Tools

I'm doing devops(ich) work so my environment is setup to support multiple solutions.

I use [Scoop](https://scoop.sh/) to download software.

- [7zip](https://www.7-zip.org/)
- [Vim Nightly](https://github.com/vim/vim-win32-installer/releases/) 8.x
- [Clink](https://chrisant996.github.io/clink/)
- [Curl](https://curl.haxx.se/)
- [Docker](https://www.docker.com/)
- [Git](https://gitforwindows.org)
- [Gradle](https://gradle.org)
- [Groovy](https://www.groovy-lang.org)
- [Gsudo](https://github.com/gerardog/gsudo)
- [Less](http://www.greenwoodsoftware.com/less/)
- [Lua](http://www.lua.org)
- [Maven](https://maven.apache.org/)
- [Msys2](http://msys2.github.io)
- [Nodejs](https://spdx.org/licenses/MIT.html)
- [Pandoc](https://pandoc.org)
- [Plantuml](http://plantuml.com/)
- [Python](https://www.python.org/)
- [Ruby](https://rubyinstaller.org)
- [Ripgrep](https://github.com/BurntSushi/ripgrep)
- [Shellcheck](https://shellcheck.net/)
- [Sysinternals](https://docs.microsoft.com/en-us/sysinternals/)
- [Tortoisesvn](https://tortoisesvn.net)
- [Universal-ctags](https://ctags.io)
- [Vieb](https://vieb.dev/)
- [Wget](https://eternallybored.org/misc/wget/)
- [Win32-openssh](https://github.com/PowerShell/Win32-OpenSSH)
- [Xming](http://www.straightrunning.com/XmingNotes/)
- [Xmllint](http://xmlsoft.org/)
- [Yarn](https://yarnpkg.com/)

Ruby gems installed:

- ast
- httparty
- mdl
- puppet
- puppet-lint
- puppet-lint-absolute_classname-check
- puppet-lint-empty_string-check
- puppet-lint-leading_zero-check
- puppet-lint-resource_reference_syntax
- puppet-lint-top_scope_facts-check
- puppet-lint-trailing_comma-check
- puppet-lint-unquoted_string-check
- puppet-lint-version_comparison-check
- rubocop

Python packages installed:

- PyYAML
- yamllint

NPM packages

- Ajv

Tools in WSL

- augeas
- ansible
- rpm, cpio, rpm2cpio
- docker-io (to ingegrate with Windows docker)

## Usage

Vim is my IDE where I do most of the stuff. It integrates most of the tool fo syntax check, tests etc. It also integrates with Windows WSL (Ubuntu 18-04) to support stuff that does not run on Windows (like Augeas). I plan to try out docker instead of WSL but performance might be worse there.

I use my own Vim-Terminal. It's just plain Vim with configuration to open terminal instead of files. It's just that I'm very used to use Vim keybindings. Configuration is in [.vim-terminal](.vim-terminal) file. To run in a way it dow not interfere with your Vim use below command:

In past I used vim-dispatch but I turned out that enchanced vim terminal works for me better. I reuse `b:dispatch` variable as it's already there.

Vim terminal with Clink:

```batch
vim.exe --clean -u %HOMEPATH%\.vimterm -c "term cmd /k clink inject" -c %bdelete1
```

For browsing I use Vieb. Again because I'm sick about using Vim keybindings which proven me to be the fastest way to operate.

I also use wrapper for OpenSSH to pass proper `TERM` variable:

```batch
@echo off

setlocal

set TERM=xterm-256color
ssh %*

endlocal
@echo on
```

Acceptance test for Puppet and Jenkins Pipeline run in Docker.

Markdown is tested using pandoc which converts to `.md` files to HTML and automatically open in browser

There is [.vimlocal](.vimlocal) file to keep additional local configuration that I do not wan't to keep in this repository.
