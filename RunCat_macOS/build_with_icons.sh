#!/bin/bash

echo "🐱 构建使用原版图标的 RunCat..."

# 编译Swift程序
swiftc -o runcat_with_icons -framework Cocoa RunCat_with_icons.swift

if [ $? -ne 0 ]; then
    echo "❌ 编译失败"
    exit 1
fi

# 创建应用程序包
APP_NAME="RunCat.app"
rm -rf "$APP_NAME"
mkdir -p "$APP_NAME/Contents/MacOS"
mkdir -p "$APP_NAME/Contents/Resources"

# 复制可执行文件
cp runcat_with_icons "$APP_NAME/Contents/MacOS/RunCat"
chmod +x "$APP_NAME/Contents/MacOS/RunCat"

# 复制ICO文件到Resources目录
echo "📁 复制原版图标文件..."
cp ../RunCat/resources/cat/*.ico "$APP_NAME/Contents/Resources/"

# 创建 Info.plist
cat > "$APP_NAME/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>RunCat</string>
    <key>CFBundleIdentifier</key>
    <string>com.runcat.macos</string>
    <key>CFBundleName</key>
    <string>RunCat</string>
    <key>CFBundleDisplayName</key>
    <string>RunCat</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>2.0</string>
    <key>CFBundleVersion</key>
    <string>2.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSSupportsAutomaticGraphicsSwitching</key>
    <true/>
</dict>
</plist>
EOF

echo "✅ RunCat 构建完成！"
echo "🚀 运行: open $APP_NAME"
echo "📍 或者安装到应用程序文件夹: cp -r $APP_NAME /Applications/" 