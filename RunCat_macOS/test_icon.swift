import Cocoa
import AppKit

// 创建一个简单的测试图标
func createTestIcon() -> NSImage {
    let size = NSSize(width: 22, height: 22)
    let image = NSImage(size: size)
    
    image.lockFocus()
    
    let context = NSGraphicsContext.current?.cgContext
    context?.setFillColor(NSColor.red.cgColor)
    
    // 画一个简单的红色圆圈
    let rect = NSRect(x: 2, y: 2, width: 18, height: 18)
    context?.fillEllipse(in: rect)
    
    image.unlockFocus()
    return image
}

// 创建状态栏项目
let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

if let button = statusItem.button {
    button.image = createTestIcon()
    button.image?.isTemplate = false
    button.toolTip = "测试图标"
    print("✅ 测试图标已创建并设置到状态栏")
} else {
    print("❌ 无法创建状态栏按钮")
}

statusItem.isVisible = true

// 创建一个简单的菜单
let menu = NSMenu()
let quitItem = NSMenuItem(title: "退出测试", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")
menu.addItem(quitItem)
statusItem.menu = menu

print("🔴 如果您在菜单栏看到一个红色圆圈，说明状态栏功能正常")
print("按 Ctrl+C 退出测试")

// 保持应用程序运行
NSApplication.shared.run() 