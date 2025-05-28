import Cocoa
import AppKit

class StatusBarController {
    private var statusItem: NSStatusItem
    private var cpuMonitor: CPUMonitor
    private var animationTimer: Timer?
    
    // 动画相关
    private var currentFrame = 0
    private var animationSpeed: TimeInterval = 0.2
    private var currentAnimal = "cat"
    private var currentTheme = "auto" // auto, light, dark
    
    // 图标数组
    private var catIcons: [NSImage] = []
    private var parrotIcons: [NSImage] = []
    private var horseIcons: [NSImage] = []
    
    // CPU相关
    private var currentCPU: Double = 0.0
    private var speedLimit = "default"
    
    init() {
        // 创建状态栏项目
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        cpuMonitor = CPUMonitor()
        
        print("🐱 RunCat 正在初始化...")
        
        setupStatusItem()
        loadIcons()
        setupMenu()
        startAnimation()
        startCPUMonitoring()
        
        print("✅ RunCat 初始化完成！请查看菜单栏右上角。")
        
        // 监听系统主题变化
        DistributedNotificationCenter.default.addObserver(
            self,
            selector: #selector(themeChanged),
            name: NSNotification.Name("AppleInterfaceThemeChangedNotification"),
            object: nil
        )
    }
    
    private func setupStatusItem() {
        print("📍 设置状态栏图标...")
        
        if let button = statusItem.button {
            let initialIcon = createCatIcon(frame: 0, isDark: isDarkMode())
            button.image = initialIcon
            button.image?.isTemplate = false
            button.toolTip = "RunCat - CPU: 0.0%"
            
            // 确保按钮可见
            button.imagePosition = .imageOnly
            button.frame = NSRect(x: 0, y: 0, width: 22, height: 22)
            
            print("✅ 状态栏图标设置完成")
        } else {
            print("❌ 无法创建状态栏按钮")
        }
        
        // 确保状态栏项目可见
        statusItem.isVisible = true
        statusItem.length = 22
    }
    
    private func loadIcons() {
        print("🎨 加载动画图标...")
        
        // 创建猫咪图标
        catIcons = (0...4).map { frame in
            createCatIcon(frame: frame, isDark: isDarkMode())
        }
        
        // 创建鹦鹉图标（简化版本）
        parrotIcons = (0...4).map { frame in
            createParrotIcon(frame: frame, isDark: isDarkMode())
        }
        
        // 创建马图标（简化版本）
        horseIcons = (0...4).map { frame in
            createHorseIcon(frame: frame, isDark: isDarkMode())
        }
        
        print("✅ 图标加载完成，共 \(catIcons.count) 帧猫咪动画")
    }
    
    private func createCatIcon(frame: Int, isDark: Bool) -> NSImage {
        let size = NSSize(width: 24, height: 24)  // 进一步增大图标尺寸
        let image = NSImage(size: size)
        
        image.lockFocus()
        
        let context = NSGraphicsContext.current?.cgContext
        // 使用更明显的颜色
        if isDark {
            context?.setFillColor(NSColor.white.cgColor)
        } else {
            context?.setFillColor(NSColor.black.cgColor)
        }
        
        // 简化的猫咪动画帧 - 更大更明显
        let baseY: CGFloat = 6
        let runOffset = CGFloat(frame % 2) * 2 // 增大跑步时的上下移动
        
        // 猫身体 - 更大更明显
        let bodyRect = NSRect(x: 6, y: baseY + runOffset, width: 14, height: 8)
        context?.fillEllipse(in: bodyRect)
        
        // 猫头 - 更大
        let headRect = NSRect(x: 16, y: baseY + runOffset + 5, width: 8, height: 7)
        context?.fillEllipse(in: headRect)
        
        // 猫耳朵 - 更明显
        let ear1 = NSRect(x: 16, y: baseY + runOffset + 11, width: 3, height: 4)
        let ear2 = NSRect(x: 21, y: baseY + runOffset + 11, width: 3, height: 4)
        context?.fillEllipse(in: ear1)
        context?.fillEllipse(in: ear2)
        
        // 猫尾巴（根据帧数摆动）- 更明显
        let tailX: CGFloat = 2 + CGFloat(frame % 3) * 1
        let tailRect = NSRect(x: tailX, y: baseY + runOffset + 6, width: 5, height: 12)
        context?.fillEllipse(in: tailRect)
        
        // 腿部动画 - 更粗更明显
        if frame % 2 == 0 {
            // 前腿
            context?.fill(NSRect(x: 14, y: baseY + runOffset - 2, width: 3, height: 6))
            context?.fill(NSRect(x: 18, y: baseY + runOffset - 2, width: 3, height: 6))
            // 后腿
            context?.fill(NSRect(x: 8, y: baseY + runOffset - 2, width: 3, height: 6))
            context?.fill(NSRect(x: 12, y: baseY + runOffset - 2, width: 3, height: 6))
        } else {
            // 前腿
            context?.fill(NSRect(x: 15, y: baseY + runOffset - 2, width: 3, height: 6))
            context?.fill(NSRect(x: 19, y: baseY + runOffset - 2, width: 3, height: 6))
            // 后腿
            context?.fill(NSRect(x: 7, y: baseY + runOffset - 2, width: 3, height: 6))
            context?.fill(NSRect(x: 11, y: baseY + runOffset - 2, width: 3, height: 6))
        }
        
        // 添加眼睛让猫咪更可爱
        context?.setFillColor(isDark ? NSColor.black.cgColor : NSColor.white.cgColor)
        context?.fillEllipse(in: NSRect(x: 18, y: baseY + runOffset + 8, width: 2, height: 2))
        context?.fillEllipse(in: NSRect(x: 21, y: baseY + runOffset + 8, width: 2, height: 2))
        
        image.unlockFocus()
        return image
    }
    
    private func createParrotIcon(frame: Int, isDark: Bool) -> NSImage {
        let size = NSSize(width: 22, height: 22)
        let image = NSImage(size: size)
        
        image.lockFocus()
        
        let context = NSGraphicsContext.current?.cgContext
        context?.setFillColor(isDark ? NSColor.white.cgColor : NSColor.black.cgColor)
        
        let baseY: CGFloat = 6
        let flyOffset = CGFloat(frame % 2) * 2
        
        // 鹦鹉身体
        let bodyRect = NSRect(x: 7, y: baseY + flyOffset, width: 10, height: 7)
        context?.fillEllipse(in: bodyRect)
        
        // 鹦鹉头
        let headRect = NSRect(x: 14, y: baseY + flyOffset + 5, width: 6, height: 5)
        context?.fillEllipse(in: headRect)
        
        // 翅膀动画
        if frame % 2 == 0 {
            // 翅膀向上
            context?.fill(NSRect(x: 4, y: baseY + flyOffset + 4, width: 5, height: 3))
            context?.fill(NSRect(x: 15, y: baseY + flyOffset + 4, width: 5, height: 3))
        } else {
            // 翅膀向下
            context?.fill(NSRect(x: 4, y: baseY + flyOffset + 1, width: 5, height: 3))
            context?.fill(NSRect(x: 15, y: baseY + flyOffset + 1, width: 5, height: 3))
        }
        
        image.unlockFocus()
        return image
    }
    
    private func createHorseIcon(frame: Int, isDark: Bool) -> NSImage {
        let size = NSSize(width: 22, height: 22)
        let image = NSImage(size: size)
        
        image.lockFocus()
        
        let context = NSGraphicsContext.current?.cgContext
        context?.setFillColor(isDark ? NSColor.white.cgColor : NSColor.black.cgColor)
        
        let baseY: CGFloat = 4
        let gallopOffset = CGFloat(frame % 2) * 1
        
        // 马身体
        let bodyRect = NSRect(x: 4, y: baseY + gallopOffset, width: 14, height: 7)
        context?.fillEllipse(in: bodyRect)
        
        // 马头
        let headRect = NSRect(x: 15, y: baseY + gallopOffset + 3, width: 5, height: 7)
        context?.fillEllipse(in: headRect)
        
        // 马鬃毛
        context?.fill(NSRect(x: 14, y: baseY + gallopOffset + 8, width: 4, height: 4))
        
        // 腿部动画（奔跑效果）
        let legPositions = [
            [(5, 7), (8, 6), (12, 7), (15, 6)],  // 帧0
            [(6, 6), (9, 7), (13, 6), (16, 7)]   // 帧1
        ]
        
        let legs = legPositions[frame % 2]
        for (x, y) in legs {
            context?.fill(NSRect(x: CGFloat(x), y: baseY + gallopOffset - CGFloat(y-5), width: 2, height: 5))
        }
        
        image.unlockFocus()
        return image
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        
        // 动物选择
        let animalMenu = NSMenuItem(title: "动物", action: nil, keyEquivalent: "")
        let animalSubmenu = NSMenu()
        
        let catItem = NSMenuItem(title: "猫咪", action: #selector(selectCat), keyEquivalent: "")
        catItem.target = self
        catItem.state = currentAnimal == "cat" ? .on : .off
        animalSubmenu.addItem(catItem)
        
        let parrotItem = NSMenuItem(title: "鹦鹉", action: #selector(selectParrot), keyEquivalent: "")
        parrotItem.target = self
        parrotItem.state = currentAnimal == "parrot" ? .on : .off
        animalSubmenu.addItem(parrotItem)
        
        let horseItem = NSMenuItem(title: "马", action: #selector(selectHorse), keyEquivalent: "")
        horseItem.target = self
        horseItem.state = currentAnimal == "horse" ? .on : .off
        animalSubmenu.addItem(horseItem)
        
        animalMenu.submenu = animalSubmenu
        menu.addItem(animalMenu)
        
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
        
        // 速度限制
        let speedMenu = NSMenuItem(title: "速度限制", action: nil, keyEquivalent: "")
        let speedSubmenu = NSMenu()
        
        let speeds = [
            ("默认", "default"),
            ("CPU 10%", "cpu10"),
            ("CPU 20%", "cpu20"),
            ("CPU 30%", "cpu30"),
            ("CPU 40%", "cpu40")
        ]
        
        for (title, value) in speeds {
            let item = NSMenuItem(title: title, action: #selector(selectSpeed(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = value
            item.state = speedLimit == value ? .on : .off
            speedSubmenu.addItem(item)
        }
        
        speedMenu.submenu = speedSubmenu
        menu.addItem(speedMenu)
        
        menu.addItem(NSMenuItem.separator())
        
        // 开机启动
        let startupItem = NSMenuItem(title: "开机启动", action: #selector(toggleStartup), keyEquivalent: "")
        startupItem.target = self
        startupItem.state = isLoginItem() ? .on : .off
        menu.addItem(startupItem)
        
        menu.addItem(NSMenuItem.separator())
        
        // 退出
        let quitItem = NSMenuItem(title: "退出", action: #selector(quit), keyEquivalent: "q")
        quitItem.target = self
        menu.addItem(quitItem)
        
        statusItem.menu = menu
    }
    
    private func startAnimation() {
        print("🎬 开始动画，速度: \(animationSpeed)秒/帧")
        animationTimer = Timer.scheduledTimer(withTimeInterval: animationSpeed, repeats: true) { [weak self] _ in
            self?.updateAnimation()
        }
    }
    
    private func updateAnimation() {
        currentFrame = (currentFrame + 1) % 5
        
        var icons: [NSImage]
        switch currentAnimal {
        case "parrot":
            icons = parrotIcons
        case "horse":
            icons = horseIcons
        default:
            icons = catIcons
        }
        
        if !icons.isEmpty {
            statusItem.button?.image = icons[currentFrame]
            // print("🎭 更新动画帧: \(currentFrame)")  // 可选的调试信息
        }
    }
    
    private func startCPUMonitoring() {
        print("📊 开始CPU监控...")
        cpuMonitor.startMonitoring { [weak self] usage in
            self?.currentCPU = usage
            self?.updateAnimationSpeed(cpuUsage: usage)
            self?.updateTooltip()
            print("💻 CPU使用率: \(String(format: "%.1f", usage))%")
        }
    }
    
    private func updateAnimationSpeed(cpuUsage: Double) {
        var speed = cpuUsage
        
        // 应用速度限制
        if speedLimit != "default" {
            let limit = Double(speedLimit.replacingOccurrences(of: "cpu", with: "")) ?? 100
            speed = min(speed, limit)
        }
        
        // 将CPU使用率转换为动画速度（CPU越高，动画越快）
        let minSpeed = 0.5  // 最慢速度
        let maxSpeed = 0.05 // 最快速度
        let normalizedSpeed = speed / 100.0
        animationSpeed = minSpeed - (normalizedSpeed * (minSpeed - maxSpeed))
        
        // 重启动画定时器
        animationTimer?.invalidate()
        startAnimation()
    }
    
    private func updateTooltip() {
        statusItem.button?.toolTip = String(format: "RunCat - CPU: %.1f%%", currentCPU)
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
    
    @objc private func themeChanged() {
        if currentTheme == "auto" {
            loadIcons()
        }
    }
    
    // MARK: - Menu Actions
    
    @objc private func selectCat() {
        currentAnimal = "cat"
        updateMenuStates()
    }
    
    @objc private func selectParrot() {
        currentAnimal = "parrot"
        updateMenuStates()
    }
    
    @objc private func selectHorse() {
        currentAnimal = "horse"
        updateMenuStates()
    }
    
    @objc private func selectAutoTheme() {
        currentTheme = "auto"
        loadIcons()
        updateMenuStates()
    }
    
    @objc private func selectLightTheme() {
        currentTheme = "light"
        loadIcons()
        updateMenuStates()
    }
    
    @objc private func selectDarkTheme() {
        currentTheme = "dark"
        loadIcons()
        updateMenuStates()
    }
    
    @objc private func selectSpeed(_ sender: NSMenuItem) {
        if let speed = sender.representedObject as? String {
            speedLimit = speed
            updateMenuStates()
        }
    }
    
    @objc private func toggleStartup() {
        if isLoginItem() {
            removeFromLoginItems()
        } else {
            addToLoginItems()
        }
        updateMenuStates()
    }
    
    @objc private func quit() {
        NSApplication.shared.terminate(nil)
    }
    
    private func updateMenuStates() {
        setupMenu() // 重新创建菜单以更新状态
    }
    
    // MARK: - Login Items (简化版本)
    
    private func isLoginItem() -> Bool {
        // 简化的登录项检查，在实际应用中可以使用更复杂的实现
        return UserDefaults.standard.bool(forKey: "LaunchAtLogin")
    }
    
    private func addToLoginItems() {
        // 简化的登录项添加，在实际应用中可以使用LaunchServices API
        UserDefaults.standard.set(true, forKey: "LaunchAtLogin")
        print("已添加到登录项（简化实现）")
    }
    
    private func removeFromLoginItems() {
        // 简化的登录项移除
        UserDefaults.standard.set(false, forKey: "LaunchAtLogin")
        print("已从登录项移除（简化实现）")
    }
    
    func cleanup() {
        animationTimer?.invalidate()
        cpuMonitor.stopMonitoring()
        DistributedNotificationCenter.default.removeObserver(self)
    }
} 