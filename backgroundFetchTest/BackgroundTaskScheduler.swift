//
//  BackgroundTaskScheduler.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/10/23.
//

import UIKit
import BackgroundTasks

class BackgroundTaskScheduler: NSObject {
    static let shared = BackgroundTaskScheduler()
    
    /// リフレッシュ処理タスクのIdentifier
    private let apprefreshIdentifier: String = "FromF.github.com.backgroundFetchTest.refresh"
    
    func registAppRefresh() {
        // リフレッシュ処理用タスクハンドラの登録
        // 第一引数: Info.plistで定義したIdentifierを指定
        // 第二引数: タスクを実行するキューを指定。nilの場合は、デフォルトのバックグラウンドキューが利用されます。
        // 第三引数: 実行する処理
        BGTaskScheduler.shared.register(forTaskWithIdentifier: apprefreshIdentifier, using: nil) { task in
            // バックグラウンド処理したい内容 ※後述します
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
            debugLog("call handleAppRefresh")
        }
        debugLog("registAppRefresh")
        DataShare.shared.post(kind: "Task regist")
    }

    /// リフレッシュ処理タスクの予約
    func scheduleAppRefresh() {
        // リクエスト作成
        // 引数: Info.plistで定義したIdentifierを指定
        let request = BGAppRefreshTaskRequest(identifier: apprefreshIdentifier)
        // タスク実行までのディレイ
        // 指定日時より早くに実行されることはないが、逆にこの日時に達したら即実行されるものでもない
        //request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)

        do {
            // スケジューラーに実行リクエストを登録
            try BGTaskScheduler.shared.submit(request)
            debugLog("scheduled")
            DataShare.shared.post(kind: "Task scheduled")

            LocationManager.shared.start()
        } catch {
            errorLog("Could not schedule app refresh: \(error)")
        }
    }

    private func handleAppRefresh(task: BGAppRefreshTask) {
        // 1日の間、何度も実行したい場合は、1回実行するごとに新たにスケジューリングに登録します
        scheduleAppRefresh()

        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1

        // 時間内に実行完了しなかった場合は、処理を解放します
        // バックグラウンドで実行する処理は、次回に回しても問題ない処理のはずなので、これでOK
        task.expirationHandler = {
            queue.cancelAllOperations()
        }

        // サンプルの処理をキューに詰めます
        let array = [1/*, 2, 3, 4, 5*/]
        array.enumerated().forEach { arg in
            let (offset, value) = arg
            let operation = BackgroundOperation(id: value)
            if offset == array.count - 1 {
                operation.completionBlock = {
                    // 最後の処理が完了したら、必ず完了したことを伝える必要があります
                    task.setTaskCompleted(success: operation.isFinished)
                }
            }
            queue.addOperation(operation)
        }
    }
}

//Pause ProgramExecutionしてから下記コマンドをLLDBに入力する
/*
e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateLaunchForTaskWithIdentifier:@"FromF.github.com.backgroundFetchTest.refresh"]
 
 e -l objc -- (void)[[BGTaskScheduler sharedScheduler] _simulateExpirationForTaskWithIdentifier:@"FromF.github.com.backgroundFetchTest.refresh"]


*/

