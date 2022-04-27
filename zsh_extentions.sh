#!/bin/bash

source ./.customshell.sh

trap _clean INT QUIT TERM EXIT

_clean() {
    _info "cleanning .oh-my-zsh dir"
    _exec_detect "rm -rf ~/.oh-my-zsh"
    _info "will not uninstall expect and curl"
    _info "cleanning ~/.zshrc"
    _exec_detect "rm ~/.zshrc"
}

zshHelp(){
    _info "install oh-my-zsh with follow: "
    _info "/bin/bash <(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    _info "after installing oh-my-zsh, you can set default theme like: xiong-chiamiov-plus"
    _info 'sed -i "/^ZSH_THEME/s/\".*\"/\"xiong-chiamiov-plus\"/g" $HOME/.zshrc'
    _info 'finally, source $HOME/.zshrc'
}

installHighLighting() {
    if [ ! -f "${HOME}/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ];then
        _info "install zsh-syntax-highlighting, create zsh-plugins dir in ~ dir"
        _exec_detect "mkdir -p ${HOME}/zsh-plugins"
        _exec_detect "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${HOME}/zsh-plugins/zsh-syntax-highlighting"
        _exec_detect "echo "source ${HOME}/zsh-plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${HOME}/.zshrc"
        _exec_detect "source ${HOME}/.zshrc"
        _succeed "highlighting config succeed"
    else
        info "zsh-syntax-highlighting.zsh has beed existed"
    fi
}

installautosuggestions(){
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ];then
        _info "install autosuggestions"
        _exec_detect "git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
        if [ "$(_os)" = "darwin" ];then
            _exec_detect '
            sed -ir /^plugins=(git)/a\
            plugins=(zsh-autosuggestions)
            " $HOME/.zshrc
            '
        else
            _exec_detect "sed -ir "/^plugins=\(git\)/a plugins=\(zsh-autosuggestions\)" $HOME/.zshrc"
        fi
        _exec_detect "source $HOME/.zshrc"
        _succeed "autosuggesstions config succeed"
    else
        _info "autosuggestions dir has beed existed"
    fi
}

main() {
    if ! _isInstalled "zsh" ;then
        zshHelp
    else
        installHighLighting
        installautosuggestions
    fi
}

main
