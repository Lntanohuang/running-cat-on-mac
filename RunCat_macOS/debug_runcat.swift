import Cocoa
import AppKit

class DebugStatusBarController {
    private var statusItem: NSStatusItem
    private var animationTimer: Timer?
    private var currentFrame = 0
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: 30)
        setupStatusItem()
        startAnimation()
        print("🐱 调试版RunCat已启动！")
        print("📍 请查看菜单栏右上角的彩色猫咪图标")
    }
    
    private func setupStatusItem() {
        if let button = statusItem.button {
            button.image = createDebugCatIcon(frame: 0)
            button.image?.isTemplate = false
            button.toolTip = "调试版RunCat - 如果您能看到这个，说明状态栏功能正常！"
            print("✅ 调试图标已设置")
        }
        
        statusItem.isVisible = true
        
        // 创建菜单
        let menu = NSMenu()
        let infoItem = NSMenuItem(title: "调试版RunCat正在运行", action: nil, keyEquivalent: "")
        let quitItem = NSMenuItem(title: "退出", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        
        menu.addItem(infoItem)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(quitItem)
        
        statusItem.menu = menu
    }
    
    private func createDebugCatIcon(frame: Int) -> NSImage {
        let size = NSSize(width: 28, height: 28)
        let image = NSImage(size: size)
        
        image.lockFocus()
        
        let context = NSGraphicsContext.current?.cgContext
        
        // 使用彩色，更容易看到
        let colors = [NSColor.red, NSColor.blue, NSColor.green, NSColor.orange, NSColor.purple]
        let color = colors[frame % colors.count]
        context?.setFillColor(color.cgColor)
        
        let baseY: CGFloat = 8
        let runOffset = CGFloat(frame % 2) * 3
        
        // 猫身体 - 超大版本
        let bodyRect = NSRect(x: 7, y: baseY + runOffset, width: 16, height: 10)
        context?.fillEllipse(in: bodyRect)
        
        // 猫头
        let headRect = NSRect(x: 18, y: baseY + runOffset + 6, width: 10, height: 8)
        context?.fillEllipse(in: headRect)
        
        // 猫耳朵
        let ear1 = NSRect(x: 18, y: baseY + runOffset + 13, width: 4, height: 5)
        let ear2 = NSRect(x: 24, y: baseY + runOffset + 13, width: 4, height: 5)
        context?.fillEllipse(in: ear1)
        context?.fillEllipse(in: ear2)
        
        // 猫尾巴
        let tailX: CGFloat = 2 + CGFloat(frame % 3) * 1.5
        let tailRect = NSRect(x: tailX, y: baseY + runOffset + 8, width: 6, height: 15)
        context?.fillEllipse(in: tailRect)
        
        // 腿部
        if frame % 2 == 0 {
            context?.fill(NSRect(x: 16, y: baseY + runOffset - 3, width: 4, height: 8))
            context?.fill(NSRect(x: 21, y: baseY + runOffset - 3, width: 4, height: 8))
            context?.fill(NSRect(x: 9, y: baseY + runOffset - 3, width: 4, height: 8))
            context?.fill(NSRect(x: 14, y: baseY + runOffset - 3, width: 4, height: 8))
        } else {
            context?.fill(NSRect(x: 17, y: baseY + runOffset - 3, width: 4, height: 8))
            context?.fill(NSRect(x: 22, y: baseY + runOffset - 3, width: 4, height: 8))
            context?.fill(NSRect(x: 8, y: baseY + runOffset - 3, width: 4, height: 8))
            context?.fill(NSRect(x: 13, y: baseY + runOffset - 3, width: 4, height: 8))
        }
        
        // 眼睛
        context?.setFillColor(NSColor.white.cgColor)
        context?.fillEllipse(in: NSRect(x: 20, y: baseY + runOffset + 9, width: 3, height: 3))
        context?.fillEllipse(in: NSRect(x: 24, y: baseY + runOffset + 9, width: 3, height: 3))
        
        image.unlockFocus()
        return image
    }
    
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            self?.updateAnimation()
        }
    }
    
    private func updateAnimation() {
        currentFrame = (currentFrame + 1) % 5
        statusItem.button?.image = createDebugCatIcon(frame: currentFrame)
        print("🎭 动画帧: \(currentFrame)")
    }
    
    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
}

class DebugApp: NSObject, NSApplicationDelegate {
    var statusBarController: DebugStatusBarController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        statusBarController = DebugStatusBarController()
    }
}

// 创建应用程序实例
let app = NSApplication.shared
let delegate = DebugApp()
app.delegate = delegate
app.run() 