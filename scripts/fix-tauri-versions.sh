#!/bin/bash

# ========================================================================
# Tauri 版本修复脚本 (Linux/macOS)
# 作者: xiaocuanChina
# 版本: 1.0
# ========================================================================

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# 显示标题
echo -e "${CYAN}========================================================================${RESET}"
echo -e "${CYAN}    Tauri 版本修复脚本${RESET}"
echo -e "${CYAN}========================================================================${RESET}"
echo

# 函数：显示错误并退出
error_exit() {
    echo -e "${RED}❌ 错误: $1${RESET}"
    if [ ! -z "$2" ]; then
        echo -e "${YELLOW}💡 解决方案: $2${RESET}"
    fi
    exit 1
}

# [1/5] 检查项目目录
echo -e "${BLUE}[1/5]${RESET} 检查项目目录..."
if [ ! -f "package.json" ]; then
    error_exit "未找到 package.json 文件" "请确保在 opcode 项目根目录运行此脚本"
fi

if [ ! -d "src-tauri" ]; then
    error_exit "未找到 src-tauri 目录" "请确保在 opcode 项目根目录运行此脚本"
fi

echo -e "${GREEN}✅ 项目目录正确${RESET}"
echo

# [2/5] 备份 package.json
echo -e "${BLUE}[2/5]${RESET} 备份 package.json..."
if [ -f "package.json.bak" ]; then
    rm "package.json.bak"
fi

if cp "package.json" "package.json.bak"; then
    echo -e "${GREEN}✅ 已备份 package.json${RESET}"
else
    echo -e "${YELLOW}⚠️  备份失败，继续执行${RESET}"
fi
echo

# [3/5] 更新 package.json 版本
echo -e "${BLUE}[3/5]${RESET} 更新 Tauri 版本..."

# 使用 jq 更新 package.json (如果可用)
if command -v jq &> /dev/null; then
    # 使用 jq 更新版本
    jq '
        .dependencies."@tauri-apps/api" = "^2.8.5" |
        .dependencies."@tauri-apps/plugin-dialog" = "^2.4.0" |
        .dependencies."@tauri-apps/plugin-global-shortcut" = "^2.3.0" |
        .dependencies."@tauri-apps/plugin-opener" = "^2.4.0" |
        .dependencies."@tauri-apps/plugin-shell" = "^2.3.1" |
        .devDependencies."@tauri-apps/cli" = "^2.8.5"
    ' package.json > package.json.tmp && mv package.json.tmp package.json

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ package.json 版本更新完成${RESET}"
    else
        error_exit "package.json 更新失败" "请手动更新 package.json 中的 Tauri 版本"
    fi
else
    echo -e "${YELLOW}⚠️  未找到 jq 工具，使用 sed 进行简单替换${RESET}"

    # 使用 sed 进行简单替换（可能不够精确）
    sed -i.bak \
        -e 's/"@tauri-apps\/api": "[^"]*"/"@tauri-apps\/api": "^2.8.5"/' \
        -e 's/"@tauri-apps\/plugin-dialog": "[^"]*"/"@tauri-apps\/plugin-dialog": "^2.4.0"/' \
        -e 's/"@tauri-apps\/plugin-global-shortcut": "[^"]*"/"@tauri-apps\/plugin-global-shortcut": "^2.3.0"/' \
        -e 's/"@tauri-apps\/plugin-opener": "[^"]*"/"@tauri-apps\/plugin-opener": "^2.4.0"/' \
        -e 's/"@tauri-apps\/plugin-shell": "[^"]*"/"@tauri-apps\/plugin-shell": "^2.3.1"/' \
        -e 's/"@tauri-apps\/cli": "[^"]*"/"@tauri-apps\/cli": "^2.8.5"/' \
        package.json

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ package.json 版本更新完成${RESET}"
    else
        error_exit "package.json 更新失败" "请手动更新 package.json 中的 Tauri 版本"
    fi
fi
echo

# [4/5] 清理旧依赖
echo -e "${BLUE}[4/5]${RESET} 清理旧依赖..."
if [ -d "node_modules" ]; then
    echo -e "${YELLOW}⚠️  正在删除 node_modules...${RESET}"
    rm -rf "node_modules"
fi

if [ -f "package-lock.json" ]; then
    rm "package-lock.json"
fi

if [ -d".npm" ]; then
    rm -rf ".npm"
fi

echo -e "${GREEN}✅ 旧依赖清理完成${RESET}"
echo

# [5/5] 重新安装依赖
echo -e "${BLUE}[5/5]${RESET} 重新安装依赖..."
echo -e "${YELLOW}⚠️  这可能需要几分钟时间，请耐心等待...${RESET}"
echo

if ! npm install; then
    error_exit "依赖安装失败" "检查网络连接或手动运行 'npm install'"
fi

echo -e "${GREEN}✅ 依赖安装完成${RESET}"
echo

# [可选] 清理 Rust 缓存
echo -e "${BLUE}[可选]${RESET} 清理 Rust 缓存..."
if [ -d "src-tauri" ]; then
    cd src-tauri
    echo -e "${YELLOW}⚠️  正在清理 Rust 缓存...${RESET}"
    cargo clean
    cd ..
    echo -e "${GREEN}✅ Rust 缓存清理完成${RESET}"
fi
echo

echo -e "${CYAN}========================================================================${RESET}"
echo -e "${GREEN}🎉 Tauri 版本修复完成！${RESET}"
echo
echo -e "${BLUE}📝 后续步骤:${RESET}"
echo -e "${BLUE}    1. 运行: npm run build        (构建前端)${RESET}"
echo -e "${BLUE}    2. 运行: npm run start:chinese (启动应用)${RESET}"
echo -e "${BLUE}    3. 如果仍有问题，请查看: 修复Tauri版本问题.md${RESET}"
echo -e "${CYAN}========================================================================${RESET}"
echo