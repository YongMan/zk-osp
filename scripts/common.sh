#!/bin/bash

[[ -s "/home/work/.jumbo/etc/bashrc" ]] && source "/home/work/.jumbo/etc/bashrc"

process_name="zookeeper"

build_dir=$OSP_PROGRAM_HOME/build

# set JAVA_HOME env
export JAVA_HOME=$OSP_UNIT_HOME/jre
# disable JMX by default
export JMXDISABLE=1

# fatal log
log_fatal() {
    osp-log --fatal "$@"
    exit 1
}

# info log
log_info() {
    osp-log --info "$@"
}

# debug log
log_debug() {
    osp-log --debug "$@"
}

# check unit hooks environment variables
check_unit_env() {
    if [[ -z "$OSP_UNIT_HOME" ]]; then
        log_fatal "Please set env OSP_UNIT_HOME"
        return 1
    fi

    if [[ -z "$OSP_PROGRAM_HOME" ]]; then
        log_fatal "Please set env OSP_PROGRAM_HOME"
        return 1
    fi

    if [[ -z "$OSP_UNIT_ID" ]]; then
        log_fatal "Please set env OSP_UNIT_ID"
        return 1
    fi
    return 0
}

# get region from the logic idcmap
get_region() {
    local idc=$1
    if [ "$idc" = "jx" ] || [ "$idc" = "tc" ]; then
        echo "bj"
    elif [[ $idc = nj* ]]; then
        echo "nj"
    elif [[ $idc = hz* ]]; then
        echo "hz"
    fi
}

