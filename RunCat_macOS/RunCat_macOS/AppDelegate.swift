import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var statusBarController: StatusBarController?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // 隐藏Dock图标，让应用只在菜单栏显示
        NSApp.setActivationPolicy(.accessory)
        
        // 初始化状态栏控制器
        statusBarController = StatusBarController()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // 清理资源
        statusBarController?.cleanup()
    }
    
    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
} 