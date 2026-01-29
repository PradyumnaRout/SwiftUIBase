//
//  LocationManager.swift
//  MVVMBaseProject
//
//  Created by hb on 24/07/23.
//

import UIKit
import CoreLocation


protocol LocationUpdateDelegate: AnyObject {
    func DidReceiveLocation(location: CLLocation, animationDuration: Double, isCalledFirstTime: Bool)
}

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    private override init() {}
    
    var isFirstTime = true
    var locationUpdateDelegate: LocationUpdateDelegate?
    var changeLocationAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?
    private let manager = CLLocationManager()
    
    var newLocation = CLLocation()
    var oldLocation = CLLocation()
    var placeMark: CLPlacemark?
    var getLocation: ((Bool) -> Void)?
}

// MARK: Location Delegate -

extension LocationManager: CLLocationManagerDelegate {
    
    func getLocationPermission() -> Bool {
        
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            manager.startUpdatingLocation()
        case .restricted:
            print("Location Restricted")
        case .denied:
            print("Location Denied")
            self.changeLocationAuthorizationCallback?(.denied)
            return false
        default:
            manager.startUpdatingLocation()
        }
        
        manager.activityType = .automotiveNavigation
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.pausesLocationUpdatesAutomatically = false
        manager.distanceFilter = 50
        manager.delegate = self
        
        if (manager.authorizationStatus == .authorizedAlways) || (manager.authorizationStatus == .authorizedWhenInUse) {
            print(manager.location?.coordinate.latitude as Any)
            print(manager.location?.coordinate.longitude as Any)
            return true
        }
        return false
    }
    
    func isLocationPermissionAllow() -> Bool {
        if (manager.authorizationStatus == .authorizedAlways) || (manager.authorizationStatus == .authorizedWhenInUse) {
            return true
        }
        return false
    }
    
    func isLocationPermissionNotDetermined() -> Bool {
        return manager.authorizationStatus == .notDetermined
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {
            getLocation?(false)
            return
        }
        
        oldLocation = newLocation
        newLocation = location
        let distance = newLocation.distance(from: oldLocation)
        let speed = newLocation.speed
        locationUpdateDelegate?.DidReceiveLocation(location: location, animationDuration: distance/speed, isCalledFirstTime: isFirstTime)
        isFirstTime = false
        self.manager.stopUpdatingLocation()
        getLocation?(true)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .restricted || manager.authorizationStatus == .denied {
            print("locationManagerDidChangeAuthorization - Location Restricted Or Denied")
        }
        if #available(iOS 14.0, *) {
            self.changeLocationAuthorizationCallback?(manager.authorizationStatus)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .restricted || status == .denied {
            print("didChangeAuthorization - Location Restricted Or Denied")
        }
        self.changeLocationAuthorizationCallback?(status)
    }
}

// MARK: General Methods

extension LocationManager {
    
    func getAddressFromLatLon(pdblLatitude: Any, withLongitude pdblLongitude: Any, completion: @escaping (CLPlacemark?) -> Void) {
        
        let lat: Double = Double("\(pdblLatitude)")!
        let lon: Double = Double("\(pdblLongitude)")!
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: lat, longitude: lon)
        
        ceo.reverseGeocodeLocation(loc, completionHandler: { [weak self] (placemarks, error) in
            
            guard let _ = self else { return }
            
            if (error != nil) {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            
            if (pm.count > 0) {
                let pmData = placemarks![0]
                self?.placeMark = pmData
                completion(pmData)
            }
        })
    }
    
    func refreshPlaceMark(_ completion: @escaping (CLPlacemark?) -> Void) {
        self.getAddressFromLatLon(pdblLatitude: self.newLocation.coordinate.latitude, withLongitude: self.newLocation.coordinate.longitude, completion: completion)
    }
}
