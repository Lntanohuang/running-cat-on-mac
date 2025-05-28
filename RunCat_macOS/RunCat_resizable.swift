import Cocoa
import AppKit

class RunCatController {
    private var statusItem: NSStatusItem
    private var animationTimer: Timer?
    private var cpuTimer: Timer?
    
    // 动画相关
    private var currentFrame = 0
    private var animationSpeed: TimeInterval = 0.2
    private var currentAnimal = "cat"
    private var currentTheme = "auto" // auto, light, dark
    
    // 图标数组
    private var lightCatIcons: [NSImage] = []
    private var darkCatIcons: [NSImage] = []
    
    // CPU相关
    private var currentCPU: Double = 0.0
    
    init() {
        statusItem = NSStatusBar.system.statusItem(withLength: 30)
        
        print("🐱 RunCat 正在启动...")
        
        loadIconsFromFiles()
        setupStatusItem()
        setupMenu()
        startAnimation()
        startCPUMonitoring()
        
        print("✅ RunCat 启动完成！请查看菜单栏。")
    }
    
    private func loadIconsFromFiles() {
        print("📁 加载原版图标文件...")
        
        let basePath = "../RunCat/resources/cat"
        
        // 加载浅色主题图标
        for i in 0...4 {
            if let iconPath = Bundle.main.path(forResource: "light_cat_\(i)", ofType: "ico") {
                if let icon = NSImage(contentsOfFile: iconPath) {
                    lightCatIcons.append(icon)
                }
            } else {
                // 如果找不到文件，使用相对路径
                let iconPath = "\(basePath)/light_cat_\(i).ico"
                if let icon = NSImage(contentsOfFile: iconPath) {
                    lightCatIcons.append(icon)
                } else {
                    // 如果还是找不到，创建备用图标
                    lightCatIcons.append(createBackupCatIcon(frame: i, isDark: false))
                }
            }
        }
        
        // 加载深色主题图标
        for i in 0...4 {
            if let iconPath = Bundle.main.path(forResource: "dark_cat_\(i)", ofType: "ico") {
                if let icon = NSImage(contentsOfFile: iconPath) {
                    darkCatIcons.append(icon)
                }
            } else {
                // 如果找不到文件，使用相对路径
                let iconPath = "\(basePath)/dark_cat_\(i).ico"
                if let icon = NSImage(contentsOfFile: iconPath) {
                    darkCatIcons.append(icon)
                } else {
                    // 如果还是找不到，创建备用图标
                    darkCatIcons.append(createBackupCatIcon(frame: i, isDark: true))
                }
            }
        }
        
        print("✅ 图标加载完成！浅色: \(lightCatIcons.count), 深色: \(darkCatIcons.count)")
    }
    
    private func createBackupCatIcon(frame: Int, isDark: Bool) -> NSImage {
        let size = NSSize(width: 22, height: 22)
        let image = NSImage(size: size)
        
        image.lockFocus()
        
        let context = NSGraphicsContext.current?.cgContext
        context?.setFillColor(isDark ? NSColor.white.cgColor : NSColor.black.cgColor)
        
        let baseY: CGFloat = 4
        let runOffset = CGFloat(frame % 2) * 1
        
        // 猫身体
        let bodyRect = NSRect(x: 5, y: baseY + runOffset, width: 12, height: 6)
        context?.fillEllipse(in: bodyRect)
        
        // 猫头
        let headRect = NSRect(x: 14, y: baseY + runOffset + 3, width: 7, height: 5)
        context?.fillEllipse(in: headRect)
        
        // 猫耳朵
        let ear1 = NSRect(x: 14, y: baseY + runOffset + 7, width: 2, height: 2)
        let ear2 = NSRect(x: 19, y: baseY + runOffset + 7, width: 2, height: 2)
        context?.fillEllipse(in: ear1)
        context?.fillEllipse(in: ear2)
        
        // 猫尾巴
        let tailX: CGFloat = 2 + CGFloat(frame % 3) * 0.5
        let tailRect = NSRect(x: tailX, y: baseY + runOffset + 4, width: 3, height: 8)
        context?.fillEllipse(in: tailRect)
        
        // 腿部动画
        if frame % 2 == 0 {
            context?.fill(NSRect(x: 12, y: baseY + runOffset - 1, width: 1, height: 3))
            context?.fill(NSRect(x: 15, y: baseY + runOffset - 1, width: 1, height: 3))
            context?.fill(NSRect(x: 7, y: baseY + runOffset - 1, width: 1, height: 3))
            context?.fill(NSRect(x: 10, y: baseY + runOffset - 1, width: 1, height: 3))
        } else {
            context?.fill(NSRect(x: 13, y: baseY + runOffset - 1, width: 1, height: 3))
            context?.fill(NSRect(x: 16, y: baseY + runOffset - 1, width: 1, height: 3))
            context?.fill(NSRect(x: 6, y: baseY + runOffset - 1, width: 1, height: 3))
            context?.fill(NSRect(x: 9, y: baseY + runOffset - 1, width: 1, height: 3))
        }
        
        image.unlockFocus()
        return image
    }
    
    private func setupStatusItem() {
        if let button = statusItem.button {
            let initialIcon = getCurrentIcons()[0]
            button.image = initialIcon
            button.image?.isTemplate = false
            button.toolTip = "RunCat - CPU: 0.0%"
        }
        
        statusItem.isVisible = true
    }
    
    private func getCurrentIcons() -> [NSImage] {
        let isDark = isDarkMode()
        
        if isDark && !darkCatIcons.isEmpty {
            return darkCatIcons
        } else if !isDark && !lightCatIcons.isEmpty {
            return lightCatIcons
        } else {
            // 如果没有加载到图标，返回备用图标
            return (0...4).map { createBackupCatIcon(frame: $0, isDark: isDark) }
        }
    }
    
    private func isDarkMode() -> Bool {
        if currentTheme == "light" {
            return false
        } else if currentTheme == "dark" {
            return true
        } else {
            // 自动模式：检测系统主题
            let appearance = NSApp.effectiveAppearance
            return appearance.bestMatch(from: [.darkAqua, .aqua]) == .darkAqua
        }
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        
        // 主题选择
        let themeMenu = NSMenuItem(title: "主题", action: nil, keyEquivalent: "")
        let themeSubmenu = NSMenu()
        
        let autoTheme = NSMenuItem(title: "自动", action: #selector(selectAutoTheme), keyEquivalent: "")
        autoTheme.target = self
        autoTheme.state = currentTheme == "auto" ? .on : .off
        themeSubmenu.addItem(autoTheme)
        
        let lightTheme = NSMenuItem(title: "浅色", action: #selector(selectLightTheme), keyEquivalent: "")
        lightTheme.target = self
        lightTheme.state = currentTheme == "light" ? .on : .off
        themeSubmenu.addItem(lightTheme)
        
        let darkTheme = NSMenuItem(title: "深色", action: #selector(selectDarkTheme), keyEquivalent: "")
        darkTheme.target = self
        darkTheme.state = currentTheme == "dark" ? .on : .off
        themeSubmenu.addItem(darkTheme)
        
        themeMenu.submenu = themeSubmenu
        menu.addItem(themeMenu)
        
        menu.addItem(NSMenuItem.separator())
        
        // 退出
        let quitItem = NSMenuItem(title: "退出", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
    }
    
    private func startAnimation() {
        animationTimer = Timer.scheduledTimer(withTimeInterval: animationSpeed, repeats: true) { [weak self] _ in
            self?.updateAnimation()
        }
    }
    
    private func updateAnimation() {
        currentFrame = (currentFrame + 1) % 5
        let icons = getCurrentIcons()
        
        if !icons.isEmpty && currentFrame < icons.count {
            statusItem.button?.image = icons[currentFrame]
        }
    }
    
    private func startCPUMonitoring() {
        cpuTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true) { [weak self] _ in
            self?.updateCPU()
        }
    }
    
    private func updateCPU() {
        // 简化的CPU监控 - 使用随机值演示
        currentCPU = Double.random(in: 0...100)
        
        // 根据CPU使用率调整动画速度
        let minSpeed = 0.5  // 最慢
        let maxSpeed = 0.1  // 最快
        let normalizedCPU = currentCPU / 100.0
        animationSpeed = minSpeed - (normalizedCPU * (minSpeed - maxSpeed))
        
        // 更新工具提示
        statusItem.button?.toolTip = String(format: "RunCat - CPU: %.1f%%", currentCPU)
        
        // 重启动画定时器
        animationTimer?.invalidate()
        startAnimation()
        
        print("💻 CPU: \(String(format: "%.1f", currentCPU))%, 动画速度: \(String(format: "%.2f", animationSpeed))s")
    }
    
    // MARK: - Menu Actions
    
    @objc private func selectAutoTheme() {
        currentTheme = "auto"
        setupMenu()
    }
    
    @objc private func selectLightTheme() {
        currentTheme = "light"
        setupMenu()
    }
    
    @objc private func selectDarkTheme() {
        currentTheme = "dark"
        setupMenu()
    }
    
    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
    
    deinit {
        animationTimer?.invalidate()
        cpuTimer?.invalidate()
    }
}

class RunCatApp: NSObject, NSApplicationDelegate {
    var runCatController: RunCatController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        runCatController = RunCatController()
    }
}

// 启动应用程序
let app = NSApplication.shared
let delegate = RunCatApp()
app.delegate = delegate
app.run() 