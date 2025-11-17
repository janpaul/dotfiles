# Dotfiles 

This is my personal unix/shell/command line configuration.

You can look but you can't touch ;-)

## Installation

### Clone this repository:

```sh
git clone git@github.com:janpaul/dotfiles.git
```

### Install Homebrew

From the official homebrew documentation:

```sh
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

### Prepare configuation:

```sh
./bootstrap.macos.sh
```

This will make symlinks to all required configuration files, i.e. ~/.zshrc -> zshrc.sh.

### Install all homebrew packages:

On macOS:
```sh
./homebrew.macos.sh
```

On Linux:
```sh
./homebrew.linux.sh
```

### Update:

Once in a while, run:

```sh
,update
```

This will update, well, everything.

## Rejoice
