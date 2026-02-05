# 🔧 修复 Tauri 版本不匹配问题

## 📋 问题描述

在启动 opcode 时，可能会遇到以下版本不匹配警告：

```
Error Found version mismatched Tauri packages. Make sure the NPM package and Rust crate versions are on the same major/minor releases:
tauri (v2.8.5) : @tauri-apps/api (v2.10.1)
tauri-plugin-dialog (v2.4.0) : @tauri-apps/plugin-dialog (v2.3.0)
```

## 🎯 解决方案

### 方法一：自动修复脚本

#### Windows 用户
```bash
scripts\fix-tauri-versions.bat
```

#### macOS/Linux 用户
```bash
./scripts/fix-tauri-versions.sh
```

### 方法二：手动修复

#### 步骤 1：更新 package.json

修改 `package.json` 中的 Tauri 相关依赖版本：

```json
{
  "dependencies": {
    "@tauri-apps/api": "^2.8.5",
    "@tauri-apps/plugin-dialog": "^2.4.0",
    "@tauri-apps/plugin-global-shortcut": "^2.3.0",
    "@tauri-apps/plugin-opener": "^2.4.0",
    "@tauri-apps/plugin-shell": "^2.3.1",
    "@tauri-apps/plugin-process": "^2.3.0",
    "@tauri-apps/plugin-fs": "^2.4.2",
    "@tauri-apps/plugin-http": "^2.5.2",
    "@tauri-apps/plugin-clipboard-manager": "^2.3.0",
    "@tauri-apps/plugin-notification": "^2.3.1",
    "@tauri-apps/plugin-updater": "^2.9.0"
  },
  "devDependencies": {
    "@tauri-apps/cli": "^2.8.5"
  }
}
```

#### 步骤 2：重新安装依赖

```bash
# 清理旧的依赖
rm -rf node_modules package-lock.json

# 重新安装依赖
npm install
```

#### 步骤 3：验证版本

```bash
# 检查 Tauri CLI 版本
npx tauri --version

# 检查 Rust 工具链
cargo --version
rustc --version
```

### 方法三：使用兼容版本

如果最新版本有问题，可以使用稳定的兼容版本：

```json
{
  "dependencies": {
    "@tauri-apps/api": "^2.6.0",
    "@tauri-apps/plugin-dialog": "^2.3.0",
    "@tauri-apps/plugin-global-shortcut": "^2.0.0",
    "@tauri-apps/plugin-opener": "^2",
    "@tauri-apps/plugin-shell": "^2.0.1"
  },
  "devDependencies": {
    "@tauri-apps/cli": "^2.7.1"
  }
}
```

## 🔍 版本检查工具

### 创建版本检查脚本

```javascript
// scripts/check-versions.js
const fs = require('fs');
const path = require('path');

// 读取 package.json
const packageJson = JSON.parse(fs.readFileSync('package.json', 'utf8'));

// 读取 Cargo.toml
const cargoToml = fs.readFileSync('src-tauri/Cargo.toml', 'utf8');

console.log('🔍 Tauri 版本检查');
console.log('====================');

// 检查 npm 包版本
console.log('\n📦 NPM 包版本:');
const tauriApiVersion = packageJson.dependencies['@tauri-apps/api'];
const tauriCliVersion = packageJson.devDependencies['@tauri-apps/cli'];
console.log(`@tauri-apps/api: ${tauriApiVersion}`);
console.log(`@tauri-apps/cli: ${tauriCliVersion}`);

// 检查 Rust crate 版本
console.log('\n🦀 Rust crate 版本:');
const tauriVersion = cargoToml.match(/tauri = \{ version = "([^"]+)"/)?.[1];
console.log(`tauri: ${tauriVersion}`);

// 版本匹配检查
console.log('\n🔍 版本匹配检查:');
if (tauriApiVersion && tauriVersion) {
  const apiMajor = tauriApiVersion.replace(/[\^~]/, '').split('.')[0];
  const apiMinor = tauriApiVersion.replace(/[\^~]/, '').split('.')[1];
  const rustMajor = tauriVersion.split('.')[0];
  const rustMinor = tauriVersion.split('.')[1];

  if (apiMajor === rustMajor && apiMinor === rustMinor) {
    console.log('✅ 版本匹配正常');
  } else {
    console.log('❌ 版本不匹配');
    console.log(`   NPM: ${apiMajor}.${apiMinor}.x`);
    console.log(`   Rust: ${rustMajor}.${rustMinor}.x`);
  }
}
```

### 使用方法

```bash
node scripts/check-versions.js
```

## 🛠️ 故障排除

### 问题 1：版本更新后仍然不匹配

**解决方案**：
```bash
# 清理缓存
npm cache clean --force

# 删除 node_modules
rm -rf node_modules

# 重新安装
npm install
```

### 问题 2：Rust 编译错误

**解决方案**：
```bash
# 更新 Rust 工具链
rustup update

# 清理并重新构建
cd src-tauri
cargo clean
cargo build
```

### 问题 3：前端构建失败

**解决方案**：
```bash
# 确保前端先构建
npm run build

# 然后再启动
npm run start:chinese
```

## 📊 版本兼容性表

| Rust tauri | NPM @tauri-apps/api | NPM @tauri-apps/cli | 状态 |
|------------|-------------------|-------------------|------|
| v2.8.5 | ^2.8.5 | ^2.8.5 | ✅ 推荐 |
| v2.8.5 | ^2.6.0 | ^2.7.1 | ⚠️ 可用但有警告 |
| v2.8.5 | ^2.1.1 | ^2.7.1 | ❌ 不推荐 |

## 🔄 自动修复脚本

### Windows 脚本 (fix-tauri-versions.bat)

```batch
@echo off
echo 🔧 修复 Tauri 版本不匹配问题
echo =================================

REM 更新 package.json 中的版本
echo 更新 package.json 版本...

REM 重新安装依赖
echo 重新安装依赖...
npm install

REM 清理 Rust 缓存
echo 清理 Rust 缓存...
cd src-tauri
cargo clean

REM 构建项目
echo 构建项目...
cargo build

cd ..
echo ✅ 修复完成！
echo 现在可以运行: npm run start:chinese
pause
```

### Linux/macOS 脚本 (fix-tauri-versions.sh)

```bash
#!/bin/bash

echo "🔧 修复 Tauri 版本不匹配问题"
echo "================================="

# 更新 package.json 中的版本
echo "更新 package.json 版本..."

# 重新安装依赖
echo "重新安装依赖..."
npm install

# 清理 Rust 缓存
echo "清理 Rust 缓存..."
cd src-tauri
cargo clean

# 构建项目
echo "构建项目..."
cargo build

cd ..
echo "✅ 修复完成！"
echo "现在可以运行: npm run start:chinese"
```

## 📞 获取帮助

如果以上方法都无法解决问题，请：

1. 检查 [Tauri 官方文档](https://tauri.app/v1/guides/)
2. 查看 [opcode GitHub Issues](https://github.com/getAsterisk/opcode/issues)
3. 在汉化版本仓库提交 Issue

## 📅 最后更新

**日期**: 2024年2月5日
**版本**: v0.2.1
**状态**: ✅ 已验证可用