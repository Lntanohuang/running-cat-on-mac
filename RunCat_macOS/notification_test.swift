import Cocoa
import UserNotifications

let app = NSApplication.shared
app.setActivationPolicy(.accessory)

// 请求通知权限
let center = UNUserNotificationCenter.current()
center.requestAuthorization(options: [.alert, .sound]) { granted, error in
    if granted {
        // 发送测试通知
        let content = UNMutableNotificationContent()
        content.title = "RunCat 测试"
        content.body = "如果您看到这个通知，说明应用程序正在正常运行！请检查菜单栏右上角。"
        content.sound = .default
        
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: nil)
        center.add(request)
    }
}

// 创建状态栏项目 - 使用更大的空间
let statusItem = NSStatusBar.system.statusItem(withLength: 100)

// 创建超级明显的按钮
if let button = statusItem.button {
    // 设置背景色
    button.wantsLayer = true
    button.layer?.backgroundColor = NSColor.red.cgColor
    
    // 设置文字
    button.title = "🐱 TEST 🐱"
    button.font = NSFont.systemFont(ofSize: 14, weight: .bold)
    
    // 设置工具提示
    button.toolTip = "RunCat 测试 - 如果您能看到这个红色按钮，说明状态栏正常工作！"
    
    print("✅ 超级明显的红色按钮已创建")
}

// 创建菜单
let menu = NSMenu()
let testItem = NSMenuItem(title: "🎉 恭喜！状态栏正常工作！", action: nil, keyEquivalent: "")
let infoItem = NSMenuItem(title: "现在可以运行 RunCat 了", action: nil, keyEquivalent: "")
let quitItem = NSMenuItem(title: "退出测试", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q")

menu.addItem(testItem)
menu.addItem(infoItem)
menu.addItem(NSMenuItem.separator())
menu.addItem(quitItem)

statusItem.menu = menu

print("🔴 通知测试启动！")
print("📱 您应该会收到一个系统通知")
print("🔴 菜单栏应该有一个红色的 '🐱 TEST ��' 按钮")

app.run() 