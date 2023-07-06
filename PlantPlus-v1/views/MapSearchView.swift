//
//  MapSearch.swift
//  PlanPlus_G12
//
//  Created by Alvaro García Méndez on 30/03/23.
//

import SwiftUI 

struct MapSearchView: View {
    
    private let locationHelper = LocationHelper()
    @StateObject private var resultsModel = ResultsModel()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.8), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
            
                List(resultsModel.mapSearchData) { item in
                    VStack(alignment: .leading) {
                        Text(item.title)
                        Text(item.subtitle)
                            .foregroundColor(.secondary)
                    }
                }.padding(.bottom, 20)
            }
            .onAppear {
                resultsModel.keyword = ""
                resultsModel.keyword = "Nurseries"
            }
            .onChange(of: self.locationHelper.currentLocation, perform: { _ in
                resultsModel.keyword = ""
                resultsModel.keyword = "Nurseries"
            })
        }
    }
    
    struct MapSearchView_Previews: PreviewProvider {
        static var previews: some View {
            MapSearchView()
        }
    }
}
