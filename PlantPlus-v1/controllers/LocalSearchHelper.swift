//
//  LocalSearchHelper.swift
//  PlanPlus_G12
//
//  Created by Alvaro García Méndez on 30/03/23.
//

import Foundation
import Combine
import MapKit

final class LocalSearchHelper {
    let localSearchPublisher = PassthroughSubject<[MKMapItem], Never>()
    private let centerLocation: CLLocationCoordinate2D
    private let radius: CLLocationDistance

    init(centerLocation: CLLocationCoordinate2D, radius: CLLocationDistance = 200) {
        self.centerLocation = centerLocation
        self.radius = radius
    }
    
    func searchPointOfInterests(searchText: String) {
        request(searchText: searchText)
    }
    
    private func request(searchText: String) {
        let localSearchReq = MKLocalSearch.Request()
        localSearchReq.naturalLanguageQuery = searchText
        localSearchReq.pointOfInterestFilter = .includingAll
        localSearchReq.resultTypes = .pointOfInterest
        localSearchReq.region = MKCoordinateRegion(
            center: centerLocation,
            latitudinalMeters: radius,
            longitudinalMeters: radius
        )
        
        let search = MKLocalSearch(request: localSearchReq)

        search.start { [weak self](response, _) in
            guard let response = response else {
                return
            }

            self?.localSearchPublisher.send(response.mapItems)
        }
    }
}
