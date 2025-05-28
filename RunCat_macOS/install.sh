#!/bin/bash

# RunCat for macOS 安装脚本

echo "🐱 RunCat for macOS 安装程序"
echo "================================"
echo ""

# 检查是否已构建应用程序
if [ ! -f "build/RunCat_macOS" ]; then
    echo "📦 正在构建应用程序..."
    ./build.sh
    if [ $? -ne 0 ]; then
        echo "❌ 构建失败！"
        exit 1
    fi
fi

# 检查是否已创建应用程序包
if [ ! -d "RunCat.app" ]; then
    echo "📦 正在创建应用程序包..."
    ./create_app_bundle.sh
    if [ $? -ne 0 ]; then
        echo "❌ 创建应用程序包失败！"
        exit 1
    fi
fi

# 安装到Applications文件夹
echo "📥 正在安装到 /Applications 文件夹..."

# 如果已存在，先删除旧版本
if [ -d "/Applications/RunCat.app" ]; then
    echo "🗑️  删除旧版本..."
    rm -rf "/Applications/RunCat.app"
fi

# 复制新版本
cp -r "RunCat.app" "/Applications/"

if [ $? -eq 0 ]; then
    echo "✅ 安装成功！"
    echo ""
    echo "🚀 您现在可以："
    echo "   1. 在启动台中找到 RunCat 并启动"
    echo "   2. 或者运行: open /Applications/RunCat.app"
    echo ""
    echo "🐱 启动后，您会在菜单栏看到一个可爱的跑步猫咪！"
    echo "   点击猫咪图标可以访问设置菜单。"
    echo ""
    echo "💡 提示："
    echo "   - 动画速度会根据CPU使用率自动调整"
    echo "   - 支持浅色/深色主题自动切换"
    echo "   - 可以选择不同的动物（猫咪、鹦鹉、马）"
    echo "   - 支持设置开机启动"
    echo ""
    
    # 询问是否立即启动
    read -p "🤔 是否立即启动 RunCat？(y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "🚀 正在启动 RunCat..."
        open "/Applications/RunCat.app"
        echo "✨ RunCat 已启动！请查看菜单栏。"
    fi
else
    echo "❌ 安装失败！请检查权限。"
    exit 1
fi 