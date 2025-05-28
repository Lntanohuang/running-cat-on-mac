#!/bin/bash

# 创建完整的 macOS 应用程序包

echo "🐱 创建 RunCat.app 应用程序包..."

# 创建应用程序包结构
APP_NAME="RunCat.app"
mkdir -p "$APP_NAME/Contents/MacOS"
mkdir -p "$APP_NAME/Contents/Resources"

# 复制可执行文件
cp build/RunCat_macOS "$APP_NAME/Contents/MacOS/RunCat"
chmod +x "$APP_NAME/Contents/MacOS/RunCat"

# 创建 Info.plist
cat > "$APP_NAME/Contents/Info.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>CFBundleDevelopmentRegion</key>
    <string>zh_CN</string>
    <key>CFBundleExecutable</key>
    <string>RunCat</string>
    <key>CFBundleIdentifier</key>
    <string>com.runcat.macos</string>
    <key>CFBundleInfoDictionaryVersion</key>
    <string>6.0</string>
    <key>CFBundleName</key>
    <string>RunCat</string>
    <key>CFBundlePackageType</key>
    <string>APPL</string>
    <key>CFBundleShortVersionString</key>
    <string>1.0.0</string>
    <key>CFBundleVersion</key>
    <string>1</string>
    <key>LSMinimumSystemVersion</key>
    <string>13.0</string>
    <key>LSUIElement</key>
    <true/>
    <key>NSHumanReadableCopyright</key>
    <string>Copyright © 2024 RunCat. All rights reserved.</string>
    <key>NSHighResolutionCapable</key>
    <true/>
    <key>NSSupportsAutomaticGraphicsSwitching</key>
    <true/>
</dict>
</plist>
EOF

echo "✅ 应用程序包创建完成！"
echo "📦 应用程序位置: $APP_NAME"
echo ""
echo "运行应用："
echo "  open $APP_NAME"
echo ""
echo "安装到应用程序文件夹："
echo "  cp -r $APP_NAME /Applications/" 