//
//  MyPlantsView.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-25.
//

import SwiftUI

struct MyPlantsView: View {
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    var body: some View {
        ZStack(alignment: .bottom){
                           List{
                               ForEach(self.fireDBHelper.plantList.enumerated().map({$0}), id: \.element.self){index, currentPlant in

                                   VStack(alignment: .leading){
                                       Text("Id Plant - \(currentPlant.id_plant)")
                                           .italic()

                                       Text("Name: \(currentPlant.name)")
                                           .bold()

                                       Text("Date Added: \(currentPlant.dateAdded)")

                                   }//VStack
                               }//ForEach
                           }//List ends
                       }
                       .navigationTitle("My History")
                       .onAppear(){
                           //get all plants from DB
               
                           var userIdS = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""


                           self.fireDBHelper.plantList.removeAll()

                           self.fireDBHelper.getAllPlants(plantID: userIdS)
                       }
    }
}

struct MyPlantsView_Previews: PreviewProvider {
    static var previews: some View {
        MyPlantsView()
    }
}
