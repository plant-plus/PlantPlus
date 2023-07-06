//
//  LocationHelper.swift
//  PlanPlus_G12
//
//  Created by Alvaro García Méndez on 30/03/23.
//

import Foundation
import CoreLocation

class LocationHelper : NSObject, ObservableObject, CLLocationManagerDelegate{
    
    @Published var authorizationStatus : CLAuthorizationStatus = .notDetermined
    
    @Published var currentLocation : CLLocation?
    private var lastKnownLocation : CLLocation? = nil
    
    @Published var longitude : Double = 0.0
    @Published var latitude : Double = 0.0
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        self.locationManager.delegate = self
    }
    
    deinit{
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function, "Authorization : \(manager.authorizationStatus.rawValue)")
        
        self.authorizationStatus = manager.authorizationStatus
        
        switch (self.locationManager.authorizationStatus){
            
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
        case .restricted:
            self.locationManager.requestAlwaysAuthorization()
        case .denied:
//            self.locationManager.requestWhenInUseAuthorization()
            //disable any location related features
            print(#function, "Location permission denied")
        case .authorizedAlways:
            self.locationManager.startUpdatingLocation()
        case .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
        @unknown default:
            self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function, "Location not available : \(error)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if locations.last != nil{
            self.currentLocation = locations.last!
            self.lastKnownLocation = locations.last!
        }else{
            self.currentLocation = locations.first
            self.lastKnownLocation = locations.first
        }
        print(#function, "location updated : \(self.currentLocation)")
        print(#function, "Longitude : \(self.currentLocation?.coordinate.longitude)")
        print(#function, "Latitude : \(self.currentLocation?.coordinate.latitude)")
    }
    
    func clLocationDegreesToString(latOrLon: Optional<CLLocationDegrees>) -> String {
        return NSNumber(value: (latOrLon)! as Double).stringValue
    }
    
    func clLocationDegreesToDouble(latOrLon: Optional<CLLocationDegrees>) -> Double {
        return (latOrLon)! as Double
    }
}
