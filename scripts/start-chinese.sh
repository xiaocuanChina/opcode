#!/bin/bash

# ========================================================================
# opcode 中文版本启动脚本 (Linux/macOS)
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
echo -e "${CYAN}    opcode 中文版本启动脚本${RESET}"
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

# [1/6] 检查 Node.js
echo -e "${BLUE}[1/6]${RESET} 检查 Node.js 环境..."
if ! command -v node &> /dev/null; then
    error_exit "未找到 Node.js" "请安装 Node.js 18 或更高版本\n    下载地址: https://nodejs.org/"
fi

NODE_VERSION=$(node --version)
echo -e "${GREEN}✅ Node.js 已安装: ${NODE_VERSION}${RESET}"
echo

# [2/6] 检查 npm
echo -e "${BLUE}[2/6]${RESET} 检查 npm 包管理器..."
if ! command -v npm &> /dev/null; then
    error_exit "未找到 npm" "请确保 Node.js 安装完整"
fi

NPM_VERSION=$(npm --version)
echo -e "${GREEN}✅ npm 已安装: ${NPM_VERSION}${RESET}"
echo

# [3/6] 检查 Rust
echo -e "${BLUE}[3/6]${RESET} 检查 Rust 环境..."
if ! command -v rustc &> /dev/null; then
    error_exit "未找到 Rust" "请安装 Rust 1.70.0 或更高版本\n    安装命令: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh"
fi

RUST_VERSION=$(rustc --version)
echo -e "${GREEN}✅ Rust 已安装: ${RUST_VERSION}${RESET}"
echo

# [4/6] 检查当前目录
echo -e "${BLUE}[4/6]${RESET} 检查项目目录..."
if [ ! -f "package.json" ]; then
    error_exit "未找到 package.json 文件" "请确保在 opcode 项目根目录运行此脚本"
fi

echo -e "${GREEN}✅ 项目目录正确${RESET}"
echo

# [5/6] 检查依赖
echo -e "${BLUE}[5/6]${RESET} 检查项目依赖..."
if [ ! -d "node_modules" ]; then
    echo -e "${YELLOW}⚠️  未找到 node_modules 目录，正在安装依赖...${RESET}"
    echo
    if ! npm install; then
        error_exit "依赖安装失败" "请检查网络连接或手动运行 'npm install'"
    fi
    echo -e "${GREEN}✅ 依赖安装完成${RESET}"
else
    echo -e "${GREEN}✅ 依赖已安装${RESET}"
fi
echo

# [6/6] 启动应用
echo -e "${BLUE}[6/6]${RESET} 启动 opcode 中文版本..."
echo -e "${CYAN}========================================================================${RESET}"
echo -e "${YELLOW}🚀 正在启动应用，请稍候...${RESET}"
echo -e "${YELLOW}💡 提示: 这是中文汉化版本，默认显示中文界面${RESET}"
echo -e "${CYAN}========================================================================${RESET}"
echo

# 启动开发服务器
if ! npm run tauri dev; then
    echo
    echo -e "${RED}❌ 应用启动失败${RESET}"
    echo -e "${YELLOW}💡 常见问题解决方案:${RESET}"
    echo -e "${YELLOW}    1. macOS: 确保已安装 Xcode Command Line Tools${RESET}"
    echo -e "${YELLOW}    2. Linux: 安装必要的系统依赖${RESET}"
    echo -e "${YELLOW}    3. 检查 Rust 工具链: rustup update${RESET}"
    echo -e "${YELLOW}    4. 查看详细错误: npm run check${RESET}"
    exit 1
fi

echo
echo -e "${GREEN}🎉 opcode 中文版本启动成功！${RESET}"
echo -e "${BLUE}📝 使用说明:${RESET}"
echo -e "${BLUE}    - 点击右上角的 🌐 图标可以切换语言${RESET}"
echo -e "${BLUE}    - 默认显示中文界面${RESET}"
echo -e "${BLUE}    - 语言偏好会自动保存${RESET}"
echo