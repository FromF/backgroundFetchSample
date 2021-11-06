//
//  BackgroundOperation.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/10/23.
//

import UIKit

class BackgroundOperation: Operation {
    let id: Int
    private var lastSteps  = 0
    init(id: Int) {
        self.id = id
    }

    override func main() {
//        DataShare.shared.add("\(self.id)")
        debugLog("\(Date()) this operation id is \(self.id)")
        
        var gps = ""
        if LocationManager.shared.isUpdate {
            gps = "\(LocationManager.shared.latitude) \(LocationManager.shared.longitude)"
            LocationManager.shared.isUpdate = false
        }

        var steps = ""
        if StepManager.shared.isUpdate {
            steps = "\(StepManager.shared.steps - lastSteps)"
            lastSteps = StepManager.shared.steps
            StepManager.shared.isUpdate = false
        }
        
        DataShare.shared.post(kind: "fetch",
                              gps: gps,
                              steps: steps,
                              call: "\(CallKitController.shared.status)",
                              charge: "\(BatteryMonitor.shared.current())",
                              music: "\(MusicMonitor.shared.current())",
                              systemUpTime: "\(ProcessInfo.processInfo.systemUptime)")
    }
}
