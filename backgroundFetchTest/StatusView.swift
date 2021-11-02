//
//  StatusView.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/11/02.
//

import SwiftUI
import MediaPlayer

struct StatusView: View {
    @ObservedObject private var callKitController = CallKitController()
    @State private var location: String = ""
    @State private var stepCount: String = ""
    @State private var systemUptime: String = ""
    @State private var batteryState: String = ""
    @State private var mediaState: String = ""
    @State private var lastSystemUptime: TimeInterval = 0
    
    var body: some View {
        VStack {
            List() {
                HStack {
                    Text("位置情報:")
                    Text("\(location)")
                }
                HStack {
                    Text("歩数:")
                    Text("\(stepCount)")
                }
                HStack {
                    Text("スマホのON/OFF:")
                    Text("\(systemUptime)")
                }
                HStack {
                    Text("充電の有無:")
                    Text("\(batteryState)")
                }
                HStack {
                    Text("音楽などのメディア再生中:")
                    Text("\(mediaState)")
                }
                HStack {
                    Text("通話状態:")
                    Text("\(callKitController.status)")
                }
            }
            Button(action: {
                refresh()
            }) {
                Text("Refresh")
            }
        }
        .onAppear {
            refresh()
        }
    }
    
    private func refresh() {
        let nowSystemUptime = ProcessInfo.processInfo.systemUptime
        systemUptime =  "\(nowSystemUptime - lastSystemUptime)"
        lastSystemUptime = nowSystemUptime

        location = "\(LocationManager.shared.latitude) , \(LocationManager.shared.longitude)"
        stepCount = "\(StepManager.shared.steps)"
        batteryState =  UIDevice().batteryState ==
            .charging ? "充電中" : "非充電"
        mediaState = MPMusicPlayerController.systemMusicPlayer.playbackState == .playing ? "再生中" : "停止"
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
