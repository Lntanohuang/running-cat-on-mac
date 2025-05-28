# RunCat for macOS (M4 Compatible)

**一个可爱的跑步猫咪动画，显示在您的macOS菜单栏中。**

这是原Windows版RunCat的macOS移植版本，专门为Apple Silicon（包括M4芯片）优化。

## 功能特性

- 🐱 **可爱的动画**：在菜单栏显示跑步的猫咪、鹦鹉或马的动画
- 📊 **CPU监控**：动画速度根据CPU使用率实时调整
- 🎨 **主题支持**：自动适配系统浅色/深色主题，也可手动选择
- ⚡ **速度控制**：可设置动画速度上限
- 🚀 **开机启动**：支持设置开机自动启动
- 💻 **原生性能**：使用Swift和AppKit开发，完美适配Apple Silicon

## 系统要求

- macOS 13.0 或更高版本
- Apple Silicon (M1/M2/M3/M4) 或 Intel 处理器

## 安装方法

### 方法一：使用Xcode构建

1. 确保您已安装Xcode 14.0或更高版本
2. 打开终端，导航到项目目录
3. 运行以下命令：

```bash
cd RunCat_macOS
xcodebuild -project RunCat_macOS.xcodeproj -scheme RunCat_macOS -configuration Release build
```

4. 构建完成后，在`build/Release/`目录中找到`RunCat_macOS.app`
5. 将应用拖拽到`/Applications`文件夹

### 方法二：直接在Xcode中运行

1. 双击`RunCat_macOS.xcodeproj`打开项目
2. 选择目标设备（Mac）
3. 点击运行按钮（⌘+R）

## 使用方法

1. 启动应用后，您会在菜单栏看到一个跑步的猫咪图标
2. 点击图标可以访问设置菜单：
   - **动物**：选择猫咪、鹦鹉或马
   - **主题**：选择自动、浅色或深色主题
   - **速度限制**：设置动画最大速度
   - **开机启动**：设置是否开机自动启动

3. 动画速度会根据CPU使用率自动调整：
   - CPU使用率越高，动画越快
   - CPU使用率低时，动画较慢

## 技术特性

- **原生Swift开发**：使用最新的Swift语言和AppKit框架
- **高效CPU监控**：使用系统级API获取准确的CPU使用率
- **内存优化**：动态生成图标，减少内存占用
- **主题自适应**：自动检测系统主题变化
- **登录项管理**：原生支持macOS登录项

## 与原版差异

相比Windows版本，macOS版本具有以下特点：

- 使用Swift重写，性能更优
- 适配macOS设计规范
- 支持macOS特有的主题系统
- 原生支持Apple Silicon架构
- 更好的电池续航优化

## 开发者信息

这是一个开源项目，基于原Windows版RunCat的设计理念，使用Swift为macOS重新开发。

## 许可证

本项目遵循Apache License 2.0许可证。

## 贡献

欢迎提交Issue和Pull Request来改进这个项目！

---

**享受您的可爱跑步猫咪吧！** 🐱‍💻 