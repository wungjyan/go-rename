#!/bin/bash

# Go语言批量重命名工具构建脚本
# 用于本地构建多平台二进制文件

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# 版本信息
VERSION=${1:-"dev"}
BUILD_TIME=$(date -u '+%Y-%m-%d_%H:%M:%S')
GIT_COMMIT=$(git rev-parse --short HEAD 2>/dev/null || echo "unknown")

echo -e "${BLUE}=== Go Rename Tool 构建脚本 ===${NC}"
echo -e "${YELLOW}版本: ${VERSION}${NC}"
echo -e "${YELLOW}构建时间: ${BUILD_TIME}${NC}"
echo -e "${YELLOW}Git提交: ${GIT_COMMIT}${NC}"
echo ""

# 清理之前的构建
echo -e "${BLUE}清理构建目录...${NC}"
rm -rf dist
mkdir -p dist

# 构建标志
LDFLAGS="-s -w -X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME} -X main.GitCommit=${GIT_COMMIT}"

# 支持的平台
platforms=(
    "windows/amd64"
    "windows/386"
    "darwin/amd64"
    "darwin/arm64"
    "linux/amd64"
    "linux/386"
    "linux/arm64"
    "linux/arm"
)

echo -e "${BLUE}开始构建多平台二进制文件...${NC}"
echo ""

# 构建每个平台
for platform in "${platforms[@]}"; do
    platform_split=(${platform//\// })
    GOOS=${platform_split[0]}
    GOARCH=${platform_split[1]}
    
    output_name="go-rename-${GOOS}-${GOARCH}"
    if [ $GOOS = "windows" ]; then
        output_name+='.exe'
    fi
    
    echo -e "${YELLOW}构建 ${GOOS}/${GOARCH}...${NC}"
    
    env GOOS=$GOOS GOARCH=$GOARCH go build -ldflags="${LDFLAGS}" -o dist/$output_name .
    
    if [ $? -eq 0 ]; then
        file_size=$(ls -lh dist/$output_name | awk '{print $5}')
        echo -e "${GREEN}✓ ${output_name} (${file_size})${NC}"
    else
        echo -e "${RED}✗ 构建 ${GOOS}/${GOARCH} 失败${NC}"
        exit 1
    fi
done

echo ""
echo -e "${BLUE}生成校验和文件...${NC}"
cd dist
sha256sum * > checksums.txt
echo -e "${GREEN}✓ checksums.txt 已生成${NC}"

echo ""
echo -e "${GREEN}=== 构建完成 ===${NC}"
echo -e "${YELLOW}构建文件位于 dist/ 目录:${NC}"
ls -la

echo ""
echo -e "${BLUE}校验和信息:${NC}"
cat checksums.txt

echo ""
echo -e "${GREEN}所有平台构建成功！${NC}"