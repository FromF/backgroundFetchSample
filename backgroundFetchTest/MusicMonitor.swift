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
    
    func current() -> String {
        switch MPMusicPlayerController.systemMusicPlayer.playbackState {
        case .stopped:
            return "停止中"
        case .playing:
            return "再生中"
        case .paused:
            return "一時停止"
        case .interrupted:
            return "中断"
        case .seekingForward:
            return "早送り"
        case .seekingBackward:
            return "巻き戻し"
        @unknown default:
            return "不明"
        }
    }
    
    @objc private func musicStateChanged() {
        status = current()
    }
    
}
