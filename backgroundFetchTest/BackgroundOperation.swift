//
//  BackgroundOperation.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/10/23.
//

import UIKit

class BackgroundOperation: Operation {
    let id: Int

    init(id: Int) {
        self.id = id
    }

    override func main() {
//        DataShare.shared.add("\(self.id)")
        debugLog("\(Date()) this operation id is \(self.id)")
        DataShare.shared.add("fetch...")
        
        if LocationManager.shared.isUpdate {
            DataShare.shared.add("\(LocationManager.shared.latitude) \(LocationManager.shared.longitude)")
            LocationManager.shared.isUpdate = false
        }

        if StepManager.shared.isUpdate {
            DataShare.shared.add("\(StepManager.shared.isUpdate) \(StepManager.shared.steps)")
            StepManager.shared.steps = 0
            StepManager.shared.isUpdate = false
        }
    }
}
