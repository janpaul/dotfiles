# Dotfiles 

This is my personal unix/shell/command line configuration.

You can look, but you can't touch ;-)

## Installation

### Clone this repository:

```sh
git clone git@github.com:janpaul/dotfiles.git
```

### Prepare configuration:

```sh
./bootstrap.sh
```

This will make symlinks to all required configuration files, i.e. `~/.zshrc` -> `dotfiles/zshrc.sh`. This will also 
install [Homebrew](https://brew.sh/) and [Rust](https://rust-lang.org) when they are not already installed.

### Install all homebrew packages:

```sh
./install-packages.sh
```

([install-packages](install-packages.sh) will autodetect your OS and install the required packages for it, as defined 
in the [Brewfile](Brewfile))

## Update:

Once in a while, run:

```sh
,update.sh (in the dotfiles/bin directory)
```

This will update, well, everything.

## Rejoice
