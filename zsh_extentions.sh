#!/bin/bash

source ./.customshell.sh

trap "_sig_cleanup" INT QUIT TERM
trap "_cleanup" EXIT

zshHelp(){
    _info "install oh-my-zsh with follow: "
    _info "/bin/bash <(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    _info "after installing oh-my-zsh, you can set default theme like: xiong-chiamiov-plus"
    _info 'sed -i "/^ZSH_THEME/s/\".*\"/\"xiong-chiamiov-plus\"/g" $HOME/.zshrc'
    _info 'finally, source $HOME/.zshrc'
}

installHighLighting() {
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ];then
        _info "install zsh-syntax-highlighting"
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        echo "source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ${HOME}/.zshrc
        source ${HOME}/.zshrc
        _succeed "highlighting config succeed"
    else
        info "zsh-syntax-highlighting.zsh has beed existed"
    fi
}

installautosuggestions(){
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ];then
        _info "install autosuggestions"
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
        # if [ "$(_os)" = "darwin" ];then
        #     _exec_detect '
        #     sed -ir /^plugins=(git)/a\
        #     plugins=(zsh-autosuggestions)
        #     " $HOME/.zshrc
        #     '
        # else
        #     _exec_detect "sed -ir "/^plugins=\(git\)/a plugins=\(zsh-autosuggestions\)" $HOME/.zshrc"
        # fi
        echo "source ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ${HOME}/.zshrc
        source $HOME/.zshrc
        _succeed "autosuggestions config succeed"
    else
        _info "autosuggestions dir has beed existed"
    fi
}

main() {
    if ! _existsCMD "zsh" ;then
        zshHelp
    else
        installHighLighting
        installautosuggestions
    fi
}

main
