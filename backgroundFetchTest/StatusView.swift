//
//  StatusView.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/11/02.
//

import SwiftUI
import MediaPlayer

struct StatusView: View {
    @ObservedObject private var callKit = CallKitController.shared
    @ObservedObject private var music = MusicMonitor.shared
    @ObservedObject private var battery = BatteryMonitor.shared
    @ObservedObject private var step = StepManager.shared
    @ObservedObject private var location = LocationManager.shared

    
    
    @State private var systemUptime: String = ""
    @State private var lastSystemUptime: TimeInterval = 0
    
    var body: some View {
        VStack {
            List() {
                HStack {
                    Text("位置情報:")
                    Text("\(location.latitude) , \(location.longitude)")
                }
                HStack {
                    Text("歩数:")
                    Text("\(step.steps)")
                }
                HStack {
                    Text("スマホのON/OFF:")
                    Text("\(systemUptime)")
                }
                HStack {
                    Text("充電の有無:")
                    Text(battery.status)
                }
                HStack {
                    Text("音楽などのメディア再生中:")
                    Text(music.status)
                }
                HStack {
                    Text("通話状態:")
                    Text(callKit.status)
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
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView()
    }
}
