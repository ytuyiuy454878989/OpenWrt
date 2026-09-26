#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

export BASE_PATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
export BUILD_DIR="${BASE_PATH}/openwrt"

# 导入system.sh全部函数
source "${BASE_PATH}/modules/system.sh"

# 执行全部补丁
run_all_system_fix

echo "所有源码补丁执行完毕，可以执行 make defconfig"

