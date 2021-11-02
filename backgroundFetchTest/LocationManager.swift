//
//  LocationManager.swift
//  backgroundFetchTest
//
//  Created by 藤治仁 on 2021/10/24.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()

    /// 緯度
    var latitude: CLLocationDegrees = 0
    /// 経度
    var longitude: CLLocationDegrees = 0
    var isUpdate: Bool = false

    private let locationManager = CLLocationManager()
    private var status: CLAuthorizationStatus {
        print("\(locationManager.authorizationStatus.rawValue)")
        return locationManager.authorizationStatus
    }
    
    override init() {
        super.init()
        locationManager.delegate = self
        authorization()
    }
    
    func authorization() {
        if status == .restricted || status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse {
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    func start() {
        if status == .authorizedAlways {
            locationManager.distanceFilter = 100
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
            isUpdate = true
        }
    }
}
