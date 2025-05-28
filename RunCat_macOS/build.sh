#!/bin/bash

# RunCat macOS 构建脚本

echo "🐱 开始构建 RunCat for macOS..."

# 创建构建目录
mkdir -p build

# 编译Swift文件
echo "📦 编译Swift源文件..."
swiftc -o build/RunCat_macOS \
    -framework Cocoa \
    -framework AppKit \
    -framework Foundation \
    RunCat_macOS/AppDelegate.swift \
    RunCat_macOS/StatusBarController.swift \
    RunCat_macOS/CPUMonitor.swift

if [ $? -eq 0 ]; then
    echo "✅ 编译成功！"
    echo "🚀 可执行文件位置: build/RunCat_macOS"
    echo ""
    echo "运行应用："
    echo "  ./build/RunCat_macOS"
    echo ""
    echo "或者双击运行："
    echo "  open build/RunCat_macOS"
else
    echo "❌ 编译失败！"
    exit 1
fi 