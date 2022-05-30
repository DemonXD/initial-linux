#!/bin/bash

source ./.customshell.sh

################ tmux
if ! _existsCMD "tmux" ;then
    _info "installing tmux"
    _install "tmux"
else
    _succeed "tmux has been installed"
fi
############### expect
if ! _existsCMD "expect"  ;then
    _info "installing expect"
    _install "expect"
else
    _succeed "expect has been installed"
fi
############### sshpass
if ! _existsCMD "sshpass"  ;then
    _info "installing sshpass"
    _install "sshpass"
else
    _succeed "sshpass has been installed"
fi
############### curl
if ! _existsCMD "curl"  ;then
    _info "installing curl"
    _install "curl"
else
    _succeed "curl has been installed"
fi
############### wget
if ! _existsCMD "wget"  ;then
    _info "installing wget"
    _install "wget"
else
    _succeed "wget has been installed"
fi
############### git
if ! _existsCMD "git"  ;then
    _info "installing git"
    _install "git"
else
    _succeed "git has been installed"
fi
############### zsh
if ! _existsCMD "zsh"  ;then
    _info "installing zsh"
    _install "zsh"
else
    _succeed "zsh has been installed"
fi
############### rsync
if ! _existsCMD "rsync"  ;then
    _info "installing rsync"
    _install "rsync"
else
    _succeed "rsync has been installed"
fi
