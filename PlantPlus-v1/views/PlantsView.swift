//
//  PlantsView.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-25.
//

import SwiftUI

struct PlantsView: View {
    
    @EnvironmentObject var perenualHelper : PerenualHelper
    @EnvironmentObject var fireDBHelper : FireDBHelper
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(self.perenualHelper.perenualResponse.data?.enumerated().map({$0}) ?? [], id: \.element.self){index, currentPlant in
                        
                        NavigationLink(destination: PlantDetailView(selectedPlant: "\(currentPlant.id!)")){
                                HStack {
                                    SwiftUI.Image(uiImage: currentPlant.image ?? UIImage())
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 80, height: 80)
                                    VStack(alignment: .leading){
                                        Text("\(currentPlant.common_name ?? "")")
                                            .bold()
                                        Text("Scientific Name: \(currentPlant.scientific_name?[0] ?? "")")
                                    }
                                }
                            }
                        }
                    }//ForEach
                }
    }
    .padding()
    .onAppear(){
        //try to fetch weather using fetchWeatherInfo() function
        self.getPlantsList()
        self.fireDBHelper.getUser()
    }
    }
    
    
    private func getPlantsList(){
        self.perenualHelper.fetchPlantList()
    }
}

struct PlantsView_Previews: PreviewProvider {
    static var previews: some View {
        PlantsView()
    }
}
