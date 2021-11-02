//
//  CallKitController.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/11/02.
//

import UIKit
import CallKit

class CallKitController: NSObject, ObservableObject {
    static let shared = CallKitController()

    @Published var status: String = "unknown"
    
    var callObserver = CXCallObserver()
    
    override init() {
        super.init()
        callObserver.setDelegate(self, queue: DispatchQueue.main)
        debugLog("")
    }
}

extension CallKitController: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        callStateValue(call: call)
    }
    
    func callStateValue(call: CXCall)  {
        status = "unknown"
        
        debugLog("isOutgoing   \(call.isOutgoing)");
        debugLog("hasConnected \(call.hasConnected)");
        debugLog("hasEnded     \(call.hasEnded)");
        debugLog("isOnHold     \(call.isOnHold)");
        
        // 発信
        if (call.isOutgoing == true && call.hasConnected == false) {
            debugLog("発信　CXCallState : Dialing");
            status = "Dialing"
        }

        // 着信
        if (call.hasConnected == false && call.hasEnded == false) {
            debugLog("着信　CXCallState : Incoming");
            status = "Incoming"
        }

        // 受話
        if (call.hasConnected == true && call.hasEnded == false) {
            debugLog("受話　CXCallState : Connected");
            // Notification通知を送る（通知を送りたい箇所に書く。例えば何らかのボタンを押した際の処理の中等）
            NotificationCenter.default.post(name: Notification.Name("myNotificationName"),
                                            object: nil)
            status = "Connected"
        }

        // 切断
        if (call.hasConnected == true && call.hasEnded == true) {
            debugLog("切断　CXCallState : Disconnected");
            status = "Disconnected"
        }
    }
}
