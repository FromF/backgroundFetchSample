//
//  AudioOutputMonitor.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/12/03.
//

import UIKit
import AVFoundation

enum AudioOutput {
    case speaker
    case headphone
    case external
    case unknown
    
    func toString() -> String {
        switch self {
        case .speaker:
            return "スピーカー"
        case .headphone:
            return "ヘッドホン"
        case .external:
            return "外部出力"
        case .unknown:
            return "不明"
        }
    }
}

class AudioOutputMonitor: ObservableObject {
    static let shared = AudioOutputMonitor()

    @Published var audioOutputDevice: AudioOutput = .unknown
    
    var audioOutput: AudioOutput {
        for component in AVAudioSession.sharedInstance().currentRoute.outputs {
            debugLog(component)
            if component.portType == .headphones ||
                component.portType == .bluetoothA2DP ||
                component.portType == .bluetoothLE ||
                component.portType == .bluetoothHFP ||
                component.portType == .usbAudio
            {
                // イヤホン(Bluetooth含む)
                return .headphone
            }
            if component.portType == .builtInReceiver ||
                component.portType == .builtInSpeaker {
                // 内蔵スピーカーはスピーカーとする
                return .speaker
            }
            if component.portType == .airPlay ||
                component.portType == .HDMI ||
                component.portType == .lineOut ||
                component.portType == .AVB ||
                component.portType == .displayPort ||
                component.portType == .carAudio ||
                component.portType == .fireWire ||
                component.portType == .PCI ||
                component.portType == .thunderbolt ||
                component.portType == .virtual
            {
                //その他オーディオデバイスは外部出力扱いする
                return .external
            }
        }
        return .unknown
    }
    
    init() {
        do {
            try AVAudioSession.sharedInstance().setActive(true, options: [])
        } catch {
            fatalError("\(error.localizedDescription)")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeAudioSessionRoute(_:)), name:  AVAudioSession.routeChangeNotification, object: nil)
        
        audioOutputDevice = audioOutput
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    @objc private func didChangeAudioSessionRoute(_ notification: Notification) {
        audioOutputDevice = audioOutput
    }
}
