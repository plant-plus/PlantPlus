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
    @EnvironmentObject var perenualHelper : PerenualHelper

    var body: some View {
        ZStack(alignment: .bottom){


            List{
                ForEach(self.fireDBHelper.plantList.enumerated().map({$0}), id: \.element.self){index, currentPlant in
                    NavigationLink(destination: MyPlantsDetailView(selectedMyPlantApiId: "\(currentPlant.api_id)").environmentObject(self.perenualHelper)){
                        HStack {
//                                           SwiftUI.Image(uiImage: currentPlant.image ?? UIImage())
//                                               .resizable()
//                                               .aspectRatio(contentMode: .fit)
//                                               .frame(width: 80, height: 80)
                            VStack(alignment: .leading){
                            Text("\(currentPlant.common_name ?? "")")
                                                   .bold()


                                           }
                                       }
                                   }



//                                   VStack(alignment: .leading){
//                                       Text("Id Plant - \(currentPlant.api_id)")
//                                           .italic()
//
//                                       Text("Name: \(currentPlant.common_name)")
//                                           .bold()
//
//                                       Text("Date Added: \(currentPlant.dateAdded)")
//
//                                   }//VStack
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
