//
//  CallKitController.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/11/02.
//

import UIKit
import CallKit

class CallKitController: NSObject, ObservableObject {
    @Published var status: String = "unknown"
    
    var callObserver = CXCallObserver()
    
    override init() {
        super.init()
        callObserver.setDelegate(self, queue: DispatchQueue.main)
        print("コールキットオブザーバーinit")
    }
}

extension CallKitController: CXCallObserverDelegate {
    func callObserver(_ callObserver: CXCallObserver, callChanged call: CXCall) {
        callStateValue(call: call)
    }
    
    func callStateValue(call: CXCall)  {
        print("通知があったよ！")
        print("isOutgoing   ", call.isOutgoing);
        print("hasConnected ", call.hasConnected);
        print("hasEnded     ", call.hasEnded);
        print("isOnHold     ", call.isOnHold);
        
        // 発信
        if (call.isOutgoing == true && call.hasConnected == false) {
            print("発信　CXCallState : Dialing");
            status = "Dialing"
        }

        // 着信
        if (call.hasConnected == false && call.hasEnded == false) {
            print("着信　CXCallState : Incoming");
            status = "Incoming"
        }

        // 受話
        if (call.hasConnected == true && call.hasEnded == false) {
            print("受話　CXCallState : Connected");
            // Notification通知を送る（通知を送りたい箇所に書く。例えば何らかのボタンを押した際の処理の中等）
            NotificationCenter.default.post(name: Notification.Name("myNotificationName"),
                                            object: nil)
            status = "Connected"
        }

        // 切断
        if (call.hasConnected == true && call.hasEnded == true) {
            print("切断　CXCallState : Disconnected");
            status = "Disconnected"
        }
    }
}
