@echo off

REM ========================================================================
REM opcode 中文版本启动脚本 (Windows)
REM 作者: xiaocuanChina
REM 版本: 1.0
REM ========================================================================

setlocal enabledelayedexpansion

REM 设置颜色
set RED=[31m
set GREEN=[32m
set YELLOW=[33m
set BLUE=[34m
set MAGENTA=[35m
set CYAN=[36m
set WHITE=[37m
set RESET=[0m

echo %CYAN%========================================================================%RESET%
echo %CYAN%    opcode 中文版本启动脚本%RESET%
echo %CYAN%========================================================================%RESET%
echo.

REM 检查 Node.js
echo %BLUE%[1/6]%RESET% 检查 Node.js 环境...
where node >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %RED%❌ 错误: 未找到 Node.js%RESET%
    echo %YELLOW%💡 解决方案: 请安装 Node.js 18 或更高版本%RESET%
    echo %YELLOW%    下载地址: https://nodejs.org/%RESET%
    pause
    exit /b 1
)

for /f "delims=" %%i in ('node --version') do set NODE_VERSION=%%i
echo %GREEN%✅ Node.js 已安装: %NODE_VERSION%%RESET%
echo.

REM 检查 npm
echo %BLUE%[2/6]%RESET% 检查 npm 包管理器...
where npm >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %RED%❌ 错误: 未找到 npm%RESET%
    echo %YELLOW%💡 解决方案: 请确保 Node.js 安装完整%RESET%
    pause
    exit /b 1
)

for /f "delims=" %%i in ('npm --version') do set NPM_VERSION=%%i
echo %GREEN%✅ npm 已安装: %NPM_VERSION%%RESET%
echo.

REM 检查 Rust
echo %BLUE%[3/6]%RESET% 检查 Rust 环境...
where rustc >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo %RED%❌ 错误: 未找到 Rust%RESET%
    echo %YELLOW%💡 解决方案: 请安装 Rust 1.70.0 或更高版本%RESET%
    echo %YELLOW%    安装命令: curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh%RESET%
    pause
    exit /b 1
)

for /f "delims=" %%i in ('rustc --version') do set RUST_VERSION=%%i
echo %GREEN%✅ Rust 已安装: %RUST_VERSION%%RESET%
echo.

REM 检查当前目录
echo %BLUE%[4/6]%RESET% 检查项目目录...
if not exist "package.json" (
    echo %RED%❌ 错误: 未找到 package.json 文件%RESET%
    echo %YELLOW%💡 解决方案: 请确保在 opcode 项目根目录运行此脚本%RESET%
    pause
    exit /b 1
)

echo %GREEN%✅ 项目目录正确%RESET%
echo.

REM 检查依赖
echo %BLUE%[5/6]%RESET% 检查项目依赖...
if not exist "node_modules" (
    echo %YELLOW%⚠️  未找到 node_modules 目录，正在安装依赖...%RESET%
    echo.
    call npm install
    if %ERRORLEVEL% NEQ 0 (
        echo %RED%❌ 错误: 依赖安装失败%RESET%
        echo %YELLOW%💡 解决方案: 请检查网络连接或手动运行 'npm install'%RESET%
        pause
        exit /b 1
    )
    echo %GREEN%✅ 依赖安装完成%RESET%
) else (
    echo %GREEN%✅ 依赖已安装%RESET%
)
echo.

REM 启动应用
echo %BLUE%[6/6]%RESET% 启动 opcode 中文版本...
echo %CYAN%========================================================================%RESET%
echo %YELLOW%🚀 正在启动应用，请稍候...%RESET%
echo %YELLOW%💡 提示: 这是中文汉化版本，默认显示中文界面%RESET%
echo %CYAN%========================================================================%RESET%
echo.

REM 启动开发服务器
call npm run tauri dev

if %ERRORLEVEL% NEQ 0 (
    echo.
    echo %RED%❌ 应用启动失败%RESET%
    echo %YELLOW%💡 常见问题解决方案:%RESET%
    echo %YELLOW%    1. 确保已安装 Microsoft C++ Build Tools%RESET%
    echo %YELLOW%    2. 确保已安装 WebView2%RESET%
    echo %YELLOW%    3. 检查 Rust 工具链: rustup update%RESET%
    echo %YELLOW%    4. 查看详细错误: npm run check%RESET%
    pause
    exit /b 1
)

echo.
echo %GREEN%🎉 opcode 中文版本启动成功！%RESET%
echo %BLUE%📝 使用说明:%RESET%
echo %BLUE%    - 点击右上角的 🌐 图标可以切换语言%RESET%
echo %BLUE%    - 默认显示中文界面%RESET%
echo %BLUE%    - 语言偏好会自动保存%RESET%
echo.

pause