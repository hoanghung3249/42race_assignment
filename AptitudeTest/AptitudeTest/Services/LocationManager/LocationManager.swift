//
//  LocationManager.swift
//  AptitudeTest
//
//  Created by Hung Nguyen on 21/05/2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    
    private var location: CLLocation?
    private var locale = Locale.current
    
    var userLocation: CLLocationCoordinate2D?
    
    var didUpdateLocation: ((CLLocationCoordinate2D?) -> Void)?
    
    override init() {
        super.init()
        setup()
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
//        locationManager.startUpdatingHeading()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingLocation()
        locationManager.stopUpdatingHeading()
    }
}

// MARK: - Private Method
private extension LocationManager {
    
    func setup() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            startTracking()
        }
    }
    
}

// MARK: - Location Manager Delegate
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        self.userLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        didUpdateLocation?(userLocation)
//        fetchCityAndCountry(from: location) { city, country, error in
//            guard let city = city, let country = country, error == nil else { return }
//            print(city + ", " + country)
//        }
        stopTracking()
    }
    
    func fetchCityAndCountry(from location: CLLocation, completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(location) { placemarks, error in
            completion(placemarks?.first?.locality,
                       placemarks?.first?.country,
                       error)
        }
    }
}
