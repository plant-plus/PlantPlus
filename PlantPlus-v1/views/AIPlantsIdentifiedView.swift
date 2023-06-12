//
//  AIPlantsIdentified.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-06-11.
//

import SwiftUI

struct AIPlantsIdentifiedView: View {
    
    @EnvironmentObject var aiPlantHelper : AIPlantHelper
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    if searchText.isEmpty{

                        ForEach(self.aiPlantHelper.aIPlantResponse.suggestions?.enumerated().map({$0}) ?? [], id: \.element.self){index, currentPlant in
                            NavigationLink(destination: PlantDetailView(selectedPlant: "\(currentPlant.id!)")){
                                HStack {
                                    SwiftUI.Image(uiImage: currentPlant.image ?? UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                    VStack(alignment: .leading){
                                        //Text("\(currentPlant.id ?? "")")
                                        Text("\(currentPlant.plant_name ?? "")")
                                            .bold()
                                        Text("Probability: \( (currentPlant.probability ?? 0.0) * 100) %")
                                    }
                                }
                            }
                        }
                    }
                    }//ForEach
                }
            .searchable(text: $searchText)
    }
    .padding()
    .onAppear(){
        //try to fetch weather using fetchWeatherInfo() function
        //self.getPlantsList()
    }
    
    }
    
    

}

struct AIPlantsIdentified_Previews: PreviewProvider {
    static var previews: some View {
        AIPlantsIdentifiedView()
    }
}
