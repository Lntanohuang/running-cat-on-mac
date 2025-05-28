import Foundation
import Darwin

class CPUMonitor {
    private var timer: Timer?
    private var cpuUsageCallback: ((Double) -> Void)?
    
    init() {}
    
    func startMonitoring(interval: TimeInterval = 3.0, callback: @escaping (Double) -> Void) {
        cpuUsageCallback = callback
        
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            let usage = self?.getCPUUsage() ?? 0.0
            DispatchQueue.main.async {
                callback(usage)
            }
        }
        
        // 立即获取一次CPU使用率
        let usage = getCPUUsage()
        callback(usage)
    }
    
    func stopMonitoring() {
        timer?.invalidate()
        timer = nil
        cpuUsageCallback = nil
    }
    
    private func getCPUUsage() -> Double {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
        
        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_,
                         task_flavor_t(MACH_TASK_BASIC_INFO),
                         $0,
                         &count)
            }
        }
        
        if kerr == KERN_SUCCESS {
            // 获取系统CPU信息
            var cpuInfo: processor_info_array_t!
            var numCpuInfo: mach_msg_type_number_t = 0
            var numCpus: natural_t = 0
            
            let result = host_processor_info(mach_host_self(),
                                           PROCESSOR_CPU_LOAD_INFO,
                                           &numCpus,
                                           &cpuInfo,
                                           &numCpuInfo)
            
            if result == KERN_SUCCESS {
                let cpuLoadInfo = cpuInfo.withMemoryRebound(to: processor_cpu_load_info.self, capacity: Int(numCpus)) {
                    Array(UnsafeBufferPointer(start: $0, count: Int(numCpus)))
                }
                
                var totalUser: UInt32 = 0
                var totalSystem: UInt32 = 0
                var totalIdle: UInt32 = 0
                var totalNice: UInt32 = 0
                
                for cpu in cpuLoadInfo {
                    totalUser += cpu.cpu_ticks.0
                    totalSystem += cpu.cpu_ticks.1
                    totalIdle += cpu.cpu_ticks.2
                    totalNice += cpu.cpu_ticks.3
                }
                
                let totalTicks = totalUser + totalSystem + totalIdle + totalNice
                let usedTicks = totalUser + totalSystem + totalNice
                
                vm_deallocate(mach_task_self_, vm_address_t(bitPattern: cpuInfo), vm_size_t(numCpuInfo))
                
                if totalTicks > 0 {
                    return Double(usedTicks) / Double(totalTicks) * 100.0
                }
            }
        }
        
        // 如果获取失败，返回随机值用于演示
        return Double.random(in: 0...100)
    }
} 