//
//  backgroundFetchTestApp.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/10/23.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        BackgroundTaskScheduler.shared.registAppRefresh()

        return true
    }
}

@main
struct backgroundFetchTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onChange(of: scenePhase) { scene in
                    switch scene {
                    case .active:
                        debugLog("scenePhase: active")
                        DataShare.shared.post(kind: "active")
                    case .inactive:
                        debugLog("scenePhase: inactive")
                        DataShare.shared.post(kind: "inactive")
                    case .background:
                        debugLog("scenePhase: background")
                        BackgroundTaskScheduler.shared.scheduleAppRefresh()
                        DataShare.shared.post(kind: "background")
                    @unknown default: break
                    }
                }
        }
    }
}
