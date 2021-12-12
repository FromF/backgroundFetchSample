//
//  LocationManager.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/10/24.
//

import UIKit
import CoreLocation

class LocationManager: NSObject , ObservableObject {
    static let shared = LocationManager()

    /// 緯度
    @Published var latitude: CLLocationDegrees = 0
    /// 経度
    @Published var longitude: CLLocationDegrees = 0
    /// 速度
    @Published var speed: CLLocationSpeed = 0
    var isUpdate: Bool = false

    private let locationManager = CLLocationManager()
    private var status: CLAuthorizationStatus {
        debugLog("\(locationManager.authorizationStatus.rawValue)")
        return locationManager.authorizationStatus
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        //バックグランド中に位置情報を取得するか
        locationManager.allowsBackgroundLocationUpdates = true
        //システムが場所の更新を一時停止できるかどうか
        locationManager.pausesLocationUpdatesAutomatically = false
        authorization()
    }
    
    func authorization() {
        if status == .restricted || status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse {
            // バックグラウンドで場所へのアクセスを許可
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func start() {
        if status == .authorizedAlways {
            //検出範囲 kCLDistanceFilterNoneにすると最高精度になる。通常は10とか100にするとよい
            locationManager.distanceFilter = kCLDistanceFilterNone
            locationManager.startUpdatingLocation()
        }
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
    }
    
}


extension LocationManager: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorization()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
            speed = location.speed
            isUpdate = true
        }
        
        //
        var gps = "none"
        var speed = "none"
        if LocationManager.shared.isUpdate {
            gps = "\(LocationManager.shared.latitude) \(LocationManager.shared.longitude)"
            speed = "\(LocationManager.shared.speed)"
            LocationManager.shared.isUpdate = false
        }
        
        var steps = "none"
        if StepManager.shared.isUpdate {
            steps = "\(StepManager.shared.steps)"
            StepManager.shared.isUpdate = false
        }
        
        DataShare.shared.post(kind: "UpdateLocations",
                              gps: gps,
                              speed: speed,
                              steps: steps,
                              call: "\(CallKitController.shared.status)",
                              charge: "\(BatteryMonitor.shared.current())",
                              music: "\(MusicMonitor.shared.current())",
                              systemUpTime: "\(ProcessInfo.processInfo.systemUptime)",
                              audio: "\(AudioOutputMonitor.shared.audioOutput)")
    }
}
