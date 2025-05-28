import Cocoa

// 创建一个超级简单的状态栏测试
let app = NSApplication.shared
app.setActivationPolicy(.accessory)

// 创建状态栏项目
let statusItem = NSStatusBar.system.statusItem(withLength: 50)

// 创建一个超级明显的图标
let image = NSImage(size: NSSize(width: 30, height: 30))
image.lockFocus()
NSColor.red.setFill()
NSBezierPath(ovalIn: NSRect(x: 5, y: 5, width: 20, height: 20)).fill()
NSColor.white.setFill()
NSBezierPath(ovalIn: NSRect(x: 10, y: 10, width: 10, height: 10)).fill()
image.unlockFocus()

// 设置图标
if let button = statusItem.button {
    button.image = image
    button.image?.isTemplate = false
    button.title = "🐱"  // 添加文字，更容易看到
    button.toolTip = "如果您能看到这个，说明状态栏正常工作！"
}

// 创建菜单
let menu = NSMenu()
let item1 = NSMenuItem(title: "✅ 状态栏测试成功！", action: nil, keyEquivalent: "")
let item2 = NSMenuItem(title: "🔍 请查看菜单栏右上角", action: nil, keyEquivalent: "")
let quitItem = NSMenuItem(title: "退出测试", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")

menu.addItem(item1)
menu.addItem(item2)
menu.addItem(NSMenuItem.separator())
menu.addItem(quitItem)

statusItem.menu = menu

print("🔴 简单测试启动！")
print("📍 请查看菜单栏右上角是否有红色圆圈和猫咪表情符号")
print("💡 如果看不到，可能需要检查系统设置中的菜单栏显示选项")

// 运行应用
app.run() 