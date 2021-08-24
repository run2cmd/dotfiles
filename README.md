# run2cmd dotfiles

This is my personal configuration that I use to work day to day. It primary focuses on Windows since that is my workspace but should work on Linux to (mostly).

## Tools

I'm doing devops(ich) work so my environment is setup to support multiple solutions.

I use [Scoop](https://scoop.sh/) to download software, also npm, ruby and python for some tools. Run `update.bat` to install/update all tools.

Additionally on WSL you need to install following tool managers:

- [RVM](https://rvm.io/)
- [NVM](https://github.com/nvm-sh/nvm)
- [SDKMAN](https://sdkman.io/)
- [pyenv](https://github.com/pyenv/pyenv)

And install required versions ruby, python, nodejs, java, gradle, groovy and maven. Those versions will be used for testing. Linting is done from Windows.

## Usage

Mapleader is set to space. It's just so much easier.

Vim is my IDE where I do most of the stuff. It integrates most of the tool fo syntax check, tests etc. It also integrates with Windows WSL (Ubuntu 18-04) to support stuff that does not run on Windows (like Augeas). I plan to try out docker instead of WSL but performance might be worse there.

I use my own Vim-Terminal. It's just plain Vim with configuration to open terminal instead of files. It's just that I'm very used to use Vim keybindings. I run it inside vim instance in separate tabs (try `<C-W>c`)

In past I used vim-dispatch but I turned out that enchanced vim terminal works for me better. I reuse `b:dispatch` variable as it's already there. There are 3 tests you can run:

- Project default test.
- Project alternative test which runs additional tests that are not part of traditional workflow like Puppet acceptance tests.
- File tests. Just run specific file depends on file type.

For keybindings you need to see `.vimrc` file since there is to much of them to just list here.

For browsing I use Vieb. Again because I'm sick about using Vim keybindings which proven me to be the fastest way to operate.

On Windows use `set TERM=xterm-256color` for proper OpenSSH output.

Acceptance test for Puppet and Jenkins Pipeline run in Docker.

There is [.vimlocal](.vimlocal) file to keep additional local configuration that I do not wan't to keep in this repository.
