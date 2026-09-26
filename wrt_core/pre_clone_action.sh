#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

# ======================
# 仅做环境准备、变量导出，不执行任何源码补丁
# 源码尚未clone，不能source system.sh
# ======================

# 基础路径
export BASE_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export BUILD_DIR="${BASE_PATH}/openwrt"

# 业务变量，根据你的yml配置修改
export THEME_SET="argon"
export LAN_ADDR="192.168.2.1"

# 模拟原仓库两个自定义feed路径函数，后面system.sh需要调用
get_custom_feed_worktree_dir(){
    echo "${BUILD_DIR}/customfeeds"
}
get_custom_feed_package_dir(){
    echo "${BUILD_DIR}/customfeeds"
}

echo "pre_clone_action.sh: BASE_PATH=${BASE_PATH}"
echo "pre_clone_action.sh: BUILD_DIR=${BUILD_DIR}"
echo "pre_clone_action.sh: 源码克隆前准备完成"
