//
//  BatteryMonitor.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/11/02.
//

import UIKit

class BatteryMonitor: NSObject , ObservableObject {
    static let shared = BatteryMonitor()

    @Published var status: String = "不明"
    
    func start() {
        // バッテリーのモニタリングを開始にする
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(batteryStateChanged), name: UIDevice.batteryStateDidChangeNotification, object: nil)
        batteryStateChanged()
    }
    
    func stop() {
        // バッテリーのモニタリングを停止にする
        UIDevice.current.isBatteryMonitoringEnabled = false
        
        NotificationCenter.default.removeObserver(self, name: UIDevice.batteryStateDidChangeNotification, object: self)
        status = "不明"
    }
    
    @objc private func batteryStateChanged() {
        switch UIDevice.current.batteryState {
        case .unknown:
            status = "不明"
        case .unplugged:
            status = "非充電"
        case .charging:
            status = "充電中"
        case .full:
            status = "充電完了"
        @unknown default:
            status = "不明"
        }
    }
}
