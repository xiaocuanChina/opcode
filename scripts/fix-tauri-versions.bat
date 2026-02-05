@echo off

REM ========================================================================
REM Tauri 版本修复脚本 (Windows)
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
echo %CYAN%    Tauri 版本修复脚本%RESET%
echo %CYAN%========================================================================%RESET%
echo.

REM 检查是否在项目根目录
echo %BLUE%[1/5]%RESET% 检查项目目录...
if not exist "package.json" (
    echo %RED%❌ 错误: 未找到 package.json 文件%RESET%
    echo %YELLOW%💡 请确保在 opcode 项目根目录运行此脚本%RESET%
    pause
    exit /b 1
)
if not exist "src-tauri" (
    echo %RED%❌ 错误: 未找到 src-tauri 目录%RESET%
    echo %YELLOW%💡 请确保在 opcode 项目根目录运行此脚本%RESET%
    pause
    exit /b 1
)

echo %GREEN%✅ 项目目录正确%RESET%
echo.

REM 备份 package.json
echo %BLUE%[2/5]%RESET% 备份 package.json...
if exist "package.json.bak" (
    del "package.json.bak"
)
copy "package.json" "package.json.bak" >nul
if %ERRORLEVEL% EQU 0 (
    echo %GREEN%✅ 已备份 package.json%RESET%
) else (
    echo %YELLOW%⚠️  备份失败，继续执行%RESET%
)
echo.

REM 更新 package.json 版本
echo %BLUE%[3/5]%RESET% 更新 Tauri 版本...

REM 使用 PowerShell 更新 package.json
powershell -Command ^
    $json = Get-Content 'package.json' -Raw ^| ConvertFrom-Json; ^
    $json.dependencies.'@tauri-apps/api' = '^&2.8.5'; ^
    $json.dependencies.'@tauri-apps/plugin-dialog' = '^&2.4.0'; ^
    $json.dependencies.'@tauri-apps/plugin-global-shortcut' = '^&2.3.0'; ^
    $json.dependencies.'@tauri-apps/plugin-opener' = '^&2.4.0'; ^
    $json.dependencies.'@tauri-apps/plugin-shell' = '^&2.3.1'; ^
    $json.devDependencies.'@tauri-apps/cli' = '^&2.8.5'; ^
    $json ^| ConvertTo-Json -Depth 10 ^| Set-Content 'package.json'

if %ERRORLEVEL% EQU 0 (
    echo %GREEN%✅ package.json 版本更新完成%RESET%
) else (
    echo %RED%❌ package.json 更新失败%RESET%
    echo %YELLOW%💡 请手动更新 package.json 中的 Tauri 版本%RESET%
)
echo.

REM 清理旧的依赖
echo %BLUE%[4/5]%RESET% 清理旧依赖...
if exist "node_modules" (
    echo %YELLOW%⚠️  正在删除 node_modules...%RESET%
    rmdir /s /q "node_modules"
)
if exist "package-lock.json" (
    del "package-lock.json"
)
if exist ".npm" (
    rmdir /s /q ".npm"
)
echo %GREEN%✅ 旧依赖清理完成%RESET%
echo.

REM 重新安装依赖
echo %BLUE%[5/5]%RESET% 重新安装依赖...
echo %YELLOW%⚠️  这可能需要几分钟时间，请耐心等待...%RESET%
echo.

call npm install
if %ERRORLEVEL% NEQ 0 (
    echo %RED%❌ 依赖安装失败%RESET%
    echo %YELLOW%💡 解决方案: 检查网络连接或手动运行 'npm install'%RESET%
    pause
    exit /b 1
)

echo %GREEN%✅ 依赖安装完成%RESET%
echo.

REM 清理 Rust 缓存
echo %BLUE%[可选]%RESET% 清理 Rust 缓存...
if exist "src-tauri" (
    cd src-tauri
    echo %YELLOW%⚠️  正在清理 Rust 缓存...%RESET%
    call cargo clean
    cd ..
    echo %GREEN%✅ Rust 缓存清理完成%RESET%
)
echo.

echo %CYAN%========================================================================%RESET%
echo %GREEN%🎉 Tauri 版本修复完成！%RESET%
echo.
echo %BLUE%📝 后续步骤:%RESET%
echo %BLUE%    1. 运行: npm run build        (构建前端)%RESET%
echo %BLUE%    2. 运行: npm run start:chinese (启动应用)%RESET%
echo %BLUE%    3. 如果仍有问题，请查看: 修复Tauri版本问题.md%RESET%
echo %CYAN%========================================================================%RESET%
echo.

pause