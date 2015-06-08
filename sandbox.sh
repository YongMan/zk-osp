#!/bin/bash

version="v5"

osp program upgrade --program=zookeeper --src=ftp://10.94.66.53/home/users/yanming02/workspace/zk-osp/zookeeper.tar.gz --version=${version} --l=""

osp service upgrade -s=rdtest-r3zk1.osp.jx -v=${version}

osp service upgrade -s=rdtest-r3zk1.osp.tc -v=${version}

osp service upgrade -s=rdtest-r3zk2.osp.jx -v=${version}
