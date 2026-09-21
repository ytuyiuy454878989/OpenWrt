#!/usr/bin/env bash
set -euo pipefail
# Determine wrt_core path
if [ -d "wrt_core" ]; then
WRT_CORE_PATH="wrt_core"
elif [ -d "../wrt_core" ]; then
WRT_CORE_PATH="../wrt_core"
else
# Fallback to script directory if wrt_core is current dir or relative
WRT_CORE_PATH=$(dirname "$0")
fi
BASE_PATH=$(cd "$WRT_CORE_PATH" && pwd)
Dev=$1
INI_FILE="$BASE_PATH/compilecfg/$Dev.ini"
if [[ ! -f $INI_FILE ]]; then
 echo "INI file not found: $INI_FILE"
 exit 1
fi
read_ini_by_key() {
 local key=$1
 awk -F"=" -v key="$key" '$1 == key {print $2}' "$INI_FILE"
}
REPO_URL=$(read_ini_by_key "REPO_URL")
REPO_BRANCH=$(read_ini_by_key "REPO_BRANCH")
REPO_BRANCH=${REPO_BRANCH:-main}
# 读取ini中的BUILD_DIR
INI_BUILD_DIR=$(read_ini_by_key "BUILD_DIR")
if [ -n "$INI_BUILD_DIR" ]; then
  BUILD_DIR="$BASE_PATH/../$INI_BUILD_DIR"
else
  BUILD_DIR="$BASE_PATH/../action_build"
fi

echo "==== Pre Clone Info ===="
echo "REPO_URL: $REPO_URL"
echo "REPO_BRANCH: $REPO_BRANCH"
echo "BUILD_DIR: $BUILD_DIR"
echo "========================"

# Write flag one level up from wrt_core (repo root usually)
echo "$REPO_URL/$REPO_BRANCH" >"$BASE_PATH/../repo_flag"

# 如果目录已经存在，先删除
if [ -d "$BUILD_DIR" ];then
  echo "旧目录存在，删除 $BUILD_DIR"
  rm -rf "$BUILD_DIR"
fi

echo "开始 git clone --depth 1 -b $REPO_BRANCH $REPO_URL $BUILD_DIR"
git clone --depth 1 -b "$REPO_BRANCH" "$REPO_URL" "$BUILD_DIR"

# GitHub Action 移除国内下载源
PROJECT_MIRRORS_FILE="$BUILD_DIR/scripts/projectsmirrors.json"
if [ -f "$PROJECT_MIRRORS_FILE" ]; then
 sed -i '/.cn\//d; /tencent/d; /aliyun/d' "$PROJECT_MIRRORS_FILE"
fi

echo "✅ pre_clone 全部完成，BUILD_DIR=$BUILD_DIR"
ls -la "$BASE_PATH/../"
