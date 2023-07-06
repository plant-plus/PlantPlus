//
//  ContentView.swift
//  PlanPlus_G12
//
//  Created by Alvaro García Méndez on 30/03/23.
//

import Foundation
import MapKit
import Combine

struct MapSearch: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    
    init(mapItem: MKMapItem) {
        self.title = mapItem.name ?? ""
        self.subtitle = mapItem.placemark.title ?? ""
    }
}

final class ResultsModel: ObservableObject {
    
    private let locationHelper = LocationHelper()
    
    private var cancellable: AnyCancellable?
    
    @Published var keyword = "" {
        didSet {
            searchPointOfInterests(text: keyword)
        }
    }
    
    @Published var mapSearchData = [MapSearch]()

    var localSearchHelper: LocalSearchHelper
    
    init() {
        let defaultLocation = CLLocationCoordinate2D(latitude: 43.675558, longitude: -79.389100)
        let userPosition = self.locationHelper.currentLocation?.coordinate
        localSearchHelper = LocalSearchHelper(centerLocation: userPosition ?? defaultLocation)
        print(#function, "user postition: \(userPosition)")
        
        cancellable = localSearchHelper.localSearchPublisher.sink { mapItems in
            self.mapSearchData = mapItems.map({ MapSearch(mapItem: $0) })
        }
    }
    
    private func searchPointOfInterests(text: String) {
        localSearchHelper.searchPointOfInterests(searchText: text)
    }
}
