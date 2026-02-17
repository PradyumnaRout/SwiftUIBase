//
//  LocationManager.swift
//  MVVMBaseProject
//
//  Created by hb on 24/07/23.
//

import UIKit
import CoreLocation


protocol LocationUpdateDelegate: AnyObject {
    func didReceiveLocation(
        _ location: CLLocation,
        animationDuration: Double,
        isFirstTime: Bool
    )
}

final class LocationManager: NSObject {

    static let shared = LocationManager()

    private let manager = CLLocationManager()
    private let geocoder = CLGeocoder()

    weak var locationUpdateDelegate: LocationUpdateDelegate?

    var changeAuthorizationCallback: ((CLAuthorizationStatus) -> Void)?
    var getLocationCompletion: ((Bool) -> Void)?

    private(set) var newLocation: CLLocation?
    private(set) var oldLocation: CLLocation?
    private(set) var placemark: CLPlacemark?

    private var isFirstTime = true

    private override init() {
        super.init()
        configure()
    }

    // MARK: Setup

    private func configure() {
        manager.delegate = self
        manager.activityType = .automotiveNavigation
        manager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        manager.distanceFilter = 50
        manager.pausesLocationUpdatesAutomatically = false
    }

    // MARK: Permission

    @discardableResult
    func requestLocationPermission() -> Bool {

        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            return false

        case .restricted, .denied:
            changeAuthorizationCallback?(.denied)
            return false

        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
            return true

        @unknown default:
            return false
        }
    }

    var isPermissionGranted: Bool {
        manager.authorizationStatus == .authorizedAlways ||
        manager.authorizationStatus == .authorizedWhenInUse
    }

    var isPermissionNotDetermined: Bool {
        manager.authorizationStatus == .notDetermined
    }
}

// MARK: CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(
        _ manager: CLLocationManager,
        didUpdateLocations locations: [CLLocation]
    ) {

        guard let location = locations.last else {
            getLocationCompletion?(false)
            return
        }

        oldLocation = newLocation
        newLocation = location

        let duration: Double
        if let old = oldLocation,
           location.speed > 0 {
            let distance = location.distance(from: old)
            duration = distance / location.speed
        } else {
            duration = 0
        }

        locationUpdateDelegate?.didReceiveLocation(
            location,
            animationDuration: duration,
            isFirstTime: isFirstTime
        )

        isFirstTime = false
        manager.stopUpdatingLocation()
        getLocationCompletion?(true)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        changeAuthorizationCallback?(manager.authorizationStatus)
    }
}

// MARK: Reverse Geocoding (Modern)

extension LocationManager {

    func reverseGeocode(
        latitude: Double,
        longitude: Double
    ) async -> CLPlacemark? {

        let location = CLLocation(latitude: latitude, longitude: longitude)

        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            placemark = placemarks.first
            return placemark
        } catch {
            print("Reverse geocode failed:", error.localizedDescription)
            return nil
        }
    }

    func refreshPlacemark() async -> CLPlacemark? {
        guard let loc = newLocation else { return nil }
        return await reverseGeocode(
            latitude: loc.coordinate.latitude,
            longitude: loc.coordinate.longitude
        )
    }
    
    // Get Address
    @discardableResult
    func currentAddress() async -> (city: String, country: String)? {
        // Check for permission
        guard LocationManager.shared.isPermissionGranted else {
            print("Location permission not granted")
            return nil
        }
        
        if let placemark = await LocationManager.shared.refreshPlacemark() {
            print("City:", placemark.locality ?? "")
            print("Country:", placemark.country ?? "")
        } else {
            return nil
        }
        return nil
    }
    

}
