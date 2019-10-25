#!/usr/local/bin/zsh

CODE=/usr/local/bin/code

[[ ! -x $CODE ]] && exit 1

_install() {
    $CODE --install-extension $1
}

_install bajdzis.vscode-database
_install christian-kohler.npm-intellisense
_install CoenraadS.bracket-pair-colorizer
_install dbaeumer.vscode-eslint
_install donjayamanne.githistory
_install eamodio.gitlens
_install ecmel.vscode-html-css
_install EditorConfig.EditorConfig
_install eg2.vscode-npm-script
_install esbenp.prettier-vscode
_install formulahendry.auto-close-tag
_install ms-azuretools.vscode-docker
_install ms-python.python
_install ms-vscode.cpptools
_install msjsdiag.debugger-for-chrome
_install redhat.java
_install redhat.vscode-yaml
_install ritwickdey.LiveServer
_install VisualStudioExptTeam.vscodeintellicode
_install vscjava.vscode-java-debug
_install vscjava.vscode-java-dependency
_install vscjava.vscode-java-pack
_install vscjava.vscode-java-test
_install vscjava.vscode-maven
_install vscode-icons-team.vscode-icons
_install zhuangtongfa.Material-theme
_install Zignd.html-css-class-completion
_install gamunu.vscode-yarn
