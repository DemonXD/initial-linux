#!/bin/bash

#trap _clean INT QUIT TERM

FMT_RED=$(printf '\033[31m')
FMT_GREEN=$(printf '\033[32m')
FMT_YELLOW=$(printf '\033[33m')
FMT_BLUE=$(printf '\033[34m')
FMT_BOLD=$(printf '\033[1m')
FMT_RESET=$(printf '\033[0m')


_info() {
    printf "%s$(date '+%Y-%m-%d %H:%M:%S') ::  LOGGING: %s%s" "$FMT_BOLD" "$1" "$FMT_RESET"
    printf '\n'
}

_succeed() {
    printf "%s$(date '+%Y-%m-%d %H:%M:%S') ::  SUCCEED: %s%s" "$FMT_GREEN" "$1" "$FMT_RESET"
    printf '\n'
}

_warning() {
    printf "%s$(date '+%Y-%m-%d %H:%M:%S') ::  WARNING: %s%s" "$FMT_YELLOW" "$1" "$FMT_RESET"
    printf '\n'

}

_error() {
    printf "%s$(date '+%Y-%m-%d %H:%M:%S') ::  ERROR: %s%s" "$FMT_RED" "$1" "$FMT_RESET"
    printf '\n'
}

_error_detect() {
    local cmd="$1"
    _info "${cmd}"
    eval ${cmd} 1> /dev/null
    if [ $? -ne 0 ]; then
        _error "Execution command (${cmd}) failed, please check it and try again."
	exit
    fi
}

_existsCMD() {
    local cmd="$1"
    if eval type type > /dev/null 2>&1; then
        eval type "$cmd" > /dev/null 2>&1
    elif command > /dev/null 2>&1; then
        command -v "$cmd" > /dev/null 2>&1
    else
        which "$cmd" > /dev/null 2>&1
    fi
    local rt=$?
    return ${rt}
}

_os() {
    local os=""
    [ -f "/etc/debian_version" ] && source /etc/os-release && os="${ID}" && printf -- "%s" "${os}" && return
    [ -f "/etc/fedora-release" ] && os="fedora" && printf -- "%s" "${os}" && return
    [ -f "/etc/redhat-release" ] && os="centos" && printf -- "%s" "${os}" && return
}

_isInstalled() {
    [ -z "$(_os)" ] && _error "Not supported OS"
    case "$(_os)" in
        ubuntu|debian|raspbian)
            dpkg -s "$1" >/dev/null 2>&1
	        if [ "$?" -ne 0 ];then
		        _error "$1 not installed"
                return 1
            else
                return
            fi
	    ;;
        fedora|centos)
            rpm -qa | grep "$1" >/dev/null 2>&1
	        if [ "$?" -ne 0 ];then
		        _error "$1 not installed"
                return 1
            else
                return
            fi
            ;;
        *)
            _error "Not supported OS"
            ;;
    esac
}

execSQL()
{
    connectioninfo="$1"
    SQL="$2"
    res=`sqlplus -S "$connectioninfo" << EOF
SET pagesize 0 linesize 1000 feedback off heading off echo off serveroutput on
${SQL}
QUIT;
EOF
`
echo "${res}"
}



custom_help() {
    _info "custom define below commands"
    grep -E '^[[:space:]]*([[:alnum:]_]+[[:space:]]*\(\)|function[[:space:]]+[[:alnum:]_]+)' /home/miles/.customshell.sh
}

rsyncto () {
    local loc_dir="$4"
    local tg_dir="$5"
    local usr="$1"
    local pwd="$2"
    local domain="$3"

    sshpass -p '$pwd' -- rsync -avzP --progress "$loc_dir" "$usr@$domain:$tg_dir"
}

alias cssh="sshpass -p 'pass@dba' -- ssh"
alias csftp="sshpass -p 'pass@dba' -- sftp"
