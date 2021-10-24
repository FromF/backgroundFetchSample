//
//  StepManager.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/10/24.
//

import UIKit
import CoreMotion
import SwiftUI

class StepManager: NSObject {
    static let shared = StepManager()
    
    var steps: Int = 0
    var isUpdate: Bool = false
    
    private let pedometer = CMPedometer()
    
    override init() {
        super.init()
        
        if CMPedometer.isStepCountingAvailable() {
            self.pedometer.startUpdates(from: Date()) { data, error in
                if let numberOfSteps = data?.numberOfSteps,
                   let steps = numberOfSteps as? Int {
                    self.steps += steps
                    self.isUpdate = true
                }
            }
        }
    }
    
}
