#!/bin/bash

echo "🔧 创建简单的测试应用程序..."

# 编译简单测试程序
swiftc -o simple_test_app -framework Cocoa simple_test.swift

if [ $? -ne 0 ]; then
    echo "❌ 编译失败"
    exit 1
fi

# 创建应用程序包
APP_NAME="SimpleTest.app"
rm -rf "$APP_NAME"
mkdir -p "$APP_NAME/Contents/MacOS"
mkdir -p "$APP_NAME/Contents/Resources"

# 复制可执行文件
cp simple_test_app "$APP_NAME/Contents/MacOS/SimpleTest"
chmod +x "$APP_NAME/Contents/MacOS/SimpleTest"

# 创建 Info.plist
cat > "$APP_NAME/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleExecutable</key>
    <string>SimpleTest</string>
    <key>CFBundleIdentifier</key>
    <string>com.test.simpletest</string>
    <key>CFBundleName</key>
    <string>SimpleTest</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHighResolutionCapable</key>
    <true/>
</dict>
</plist>
EOF

echo "✅ 测试应用程序创建完成: $APP_NAME"
echo "🚀 运行测试: open $APP_NAME"
echo ""
echo "📍 运行后请查看菜单栏右上角是否有红色圆圈和🐱符号" 