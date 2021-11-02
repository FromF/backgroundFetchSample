//
//  MusicMonitor.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/11/02.
//

import UIKit
import MediaPlayer

class MusicMonitor: NSObject , ObservableObject {
    static let shared = MusicMonitor()
    @Published var status: String = "不明"
    
    func start() {
        let player = MPMusicPlayerController.systemMusicPlayer
        // 通知の有効化
        player.beginGeneratingPlaybackNotifications()
        
        NotificationCenter.default.addObserver(self, selector: #selector(musicStateChanged), name: .MPMusicPlayerControllerPlaybackStateDidChange, object: player)
        musicStateChanged()
    }
    
    func stop() {
        let player = MPMusicPlayerController.systemMusicPlayer
        player.endGeneratingPlaybackNotifications()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: self)
        status = "不明"
    }
    
    @objc private func musicStateChanged() {
        debugLog("\(MPMusicPlayerController.systemMusicPlayer.playbackState.rawValue)")
        switch MPMusicPlayerController.systemMusicPlayer.playbackState {
        case .stopped:
            status = "停止中"
        case .playing:
            status = "再生中"
        case .paused:
            status = "一時停止"
        case .interrupted:
            status = "中断"
        case .seekingForward:
            status = "早送り"
        case .seekingBackward:
            status = "巻き戻し"
        @unknown default:
            status = "不明"
        }
    }
    
}
