#!/usr/local/bin/zsh

CODE=/usr/local/bin/code

[[ ! -x $CODE ]] && exit 1

_install() {
    $CODE --install-extension $1
}

## Common
_install christian-kohler.npm-intellisense
_install CoenraadS.bracket-pair-colorizer
_install EditorConfig.EditorConfig
_install formulahendry.auto-close-tag
_install redhat.vscode-yaml
_install ritwickdey.LiveServer
_install VisualStudioExptTeam.vscodeintellicode
_install wayou.vscode-todo-highlight
_install davidanson.vscode-markdownlint

## Theme + icons
_install vscode-icons-team.vscode-icons
_install zhuangtongfa.Material-theme

## Database
_install bajdzis.vscode-database

## Webdev
_install ecmel.vscode-html-css
_install Zignd.html-css-class-completion
_install formulahendry.auto-rename-tag

## JavaScript
_install dbaeumer.vscode-eslint
_install eg2.vscode-npm-script
_install esbenp.prettier-vscode
_install msjsdiag.debugger-for-chrome

## git
_install donjayamanne.githistory
_install eamodio.gitlens

## Docker
_install ms-azuretools.vscode-docker

## Python
_install ms-python.python

## C / C++
_install ms-vscode.cpptools
_install austin.code-gnu-global

## Java
_install redhat.java
_install vscjava.vscode-java-debug
_install vscjava.vscode-java-dependency
_install vscjava.vscode-java-pack
_install vscjava.vscode-java-test
_install vscjava.vscode-maven

## Haskell
_install justusadam.language-haskell

## Ruby
_install rebornix.ruby
