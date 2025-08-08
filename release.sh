#!/bin/bash

# Go语言批量重命名工具发布脚本
# 用于创建Git标签并触发GitHub Actions自动发布

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Go Rename Tool 发布脚本 ===${NC}"
echo ""

# 检查是否在Git仓库中
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo -e "${RED}错误: 当前目录不是Git仓库${NC}"
    exit 1
fi

# 检查是否有未提交的更改
if ! git diff-index --quiet HEAD --; then
    echo -e "${RED}错误: 存在未提交的更改，请先提交所有更改${NC}"
    echo -e "${YELLOW}提示: 运行 'git status' 查看未提交的文件${NC}"
    exit 1
fi

# 获取当前分支
current_branch=$(git branch --show-current)
if [ "$current_branch" != "main" ] && [ "$current_branch" != "master" ]; then
    echo -e "${YELLOW}警告: 当前不在主分支 (当前分支: $current_branch)${NC}"
    read -p "是否继续? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}发布已取消${NC}"
        exit 0
    fi
fi

# 获取最新的标签
latest_tag=$(git describe --tags --abbrev=0 2>/dev/null || echo "v0.0.0")
echo -e "${BLUE}当前最新标签: ${latest_tag}${NC}"

# 提示输入新版本
echo ""
echo -e "${YELLOW}请输入新版本号 (格式: v1.0.0):${NC}"
read -p "版本号: " new_version

# 验证版本号格式
if [[ ! $new_version =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo -e "${RED}错误: 版本号格式不正确，应为 vX.Y.Z 格式 (如: v1.0.0)${NC}"
    exit 1
fi

# 检查标签是否已存在
if git rev-parse "$new_version" >/dev/null 2>&1; then
    echo -e "${RED}错误: 标签 $new_version 已存在${NC}"
    exit 1
fi

# 确认发布
echo ""
echo -e "${YELLOW}=== 发布信息确认 ===${NC}"
echo -e "${BLUE}新版本: ${new_version}${NC}"
echo -e "${BLUE}当前分支: ${current_branch}${NC}"
echo -e "${BLUE}最新提交: $(git log -1 --oneline)${NC}"
echo ""
read -p "确认发布? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo -e "${YELLOW}发布已取消${NC}"
    exit 0
fi

# 创建标签
echo -e "${BLUE}创建标签 ${new_version}...${NC}"
git tag -a "$new_version" -m "Release $new_version"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 标签创建成功${NC}"
else
    echo -e "${RED}✗ 标签创建失败${NC}"
    exit 1
fi

# 推送标签
echo -e "${BLUE}推送标签到远程仓库...${NC}"
git push origin "$new_version"

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ 标签推送成功${NC}"
else
    echo -e "${RED}✗ 标签推送失败${NC}"
    echo -e "${YELLOW}提示: 可以手动运行 'git push origin $new_version' 重试${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}=== 发布完成 ===${NC}"
echo -e "${BLUE}版本 ${new_version} 已成功发布！${NC}"
echo -e "${YELLOW}GitHub Actions 将自动构建并创建 Release${NC}"
echo -e "${YELLOW}请访问 GitHub 仓库的 Actions 页面查看构建进度${NC}"
echo -e "${YELLOW}构建完成后可在 Releases 页面下载编译好的程序${NC}"
echo ""
echo -e "${BLUE}相关链接:${NC}"
echo -e "${BLUE}- Actions: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:\/]\([^.]*\).*/\1/')/actions${NC}"
echo -e "${BLUE}- Releases: https://github.com/$(git config --get remote.origin.url | sed 's/.*github.com[:\/]\([^.]*\).*/\1/')/releases${NC}"