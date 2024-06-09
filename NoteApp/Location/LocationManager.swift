//
//  LocationManager.swift
//  NoteApp
//
//  Created by דוד נוי on 09/06/2024.
//

import CoreLocation

protocol LocationManagerDelegate: AnyObject {
    func showAlert(withTitle title: String, message: String)
}

class LocationManager: NSObject {
    
    private let locationManager = CLLocationManager()
    public var location: CLLocationCoordinate2D?
    weak var delegate: LocationManagerDelegate?

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func checkLocationAuthorizationStatus() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            requestLocationPermission()
        case .restricted, .denied:
            delegate?.showAlert(withTitle: Strings.locationAccessDenied, message: Strings.pleaseEnableLocation)
        case .authorizedWhenInUse, .authorizedAlways:
            location = locationManager.location?.coordinate
            break
        @unknown default:
            break
        }
    }

    private func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            location = locationManager.location?.coordinate
            break
        case .denied:
            delegate?.showAlert(withTitle: Strings.locationAccessDenied, message: Strings.pleaseEnableLocation)
        case .restricted:
            delegate?.showAlert(withTitle: Strings.locationAccessRestrictedTitle, message: Strings.locationAccessRestrictedMessage)
        case .notDetermined:
            requestLocationPermission()
        @unknown default:
            break
        }
    }
}

