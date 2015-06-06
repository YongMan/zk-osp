#!/bin/bash

[[ -s "/home/work/.jumbo/etc/bashrc" ]] && source "/home/work/.jumbo/etc/bashrc"

process_name="redis"

build_dir=$OSP_PROGRAM_HOME/build

# supervisorctl command
ctl="supervisorctl -c ${OSP_UNIT_HOME}/conf/supervisord.conf"

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

# check relation hooks environment variables
check_relation_env() {
    if ! check_unit_env; then
        return 1
    fi
    
    if [[ -z "$OSP_RELATION_ID" ]]; then
        log_fatal "Please set env OSP_RELATION_ID"
        return 1
    fi    
    
    return 0
}


# start the process
start() {
    local name="$1"
    $ctl start $name
}

# update the conf and restart the process if needed
update() {
    $ctl update
}

# stop the process
stop() {
    local name="$1"
    $ctl stop $name
}

# restart the process
restart() {
    local name="$1"
    $ctl restart $name
}

# restart the process if it's running
restart_if_running() {
    local name="$1"
    local status="$($ctl status $name)"
    if ! [[ "$status" = *RUNNING* ]]; then
        log_info "Process $name is not running"
        return 0
    fi
    $ctl restart $name
}

# stop the supervisord
stop_supervisord() {
    $ctl stop all
    $ctl shutdown
}

# start the supervisord
start_supervisord() {
    supervisord -c $OSP_UNIT_HOME/conf/supervisord.conf
    log_info "start_supervisord done"
}

# restart the supervisord
restart_supervisord() {
    stop_supervisord
    start_supervisord
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

