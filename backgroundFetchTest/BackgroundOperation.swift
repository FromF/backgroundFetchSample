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
        print("\(Date()) this operation id is \(self.id)")
        
        DataShare.shared.add("\(LocationManager.shared.latitude) \(LocationManager.shared.longitude)")
        DataShare.shared.add("\(StepManager.shared.isUpdate) \(StepManager.shared.steps)")
        StepManager.shared.isUpdate = false
    }
}
