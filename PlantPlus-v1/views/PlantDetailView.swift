//
//  PlantDetailView.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-25.
//

import SwiftUI

struct PlantDetailView: View {

    let selectedPlant: String

    @EnvironmentObject var perenualHelper : PerenualHelper
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    @State private var showingNicknameAlert = false
    @State private var nickname = "my plant"

    var body: some View {
        VStack(){

            Text("\(perenualHelper.plantDetailResponse.common_name ?? "")")
                .font(.system(size: 26))

            SwiftUI.Image(uiImage: perenualHelper.plantDetailResponse.image ?? UIImage())
                .resizable()
                .frame(width: 200, height: 200)
            VStack{
                Text("Image license: \(perenualHelper.plantDetailResponse.license_name ?? "")")
                    .font(.system(size: 12))
            }
            .padding()
            Form {
                Section {
                    HStack{
                        Text("Scientific Name:")
                        Text("\(perenualHelper.plantDetailResponse.scientific_name?.first ?? "")")
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                    HStack{
                        Text("Other Name:")
                        Text("\(perenualHelper.plantDetailResponse.other_name?.first ?? "")")
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                    HStack{
                        Text("Cycle:")
                        Text("\(perenualHelper.plantDetailResponse.cycle ?? "")")
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                    HStack{
                        Text("Watering:")
                        Text("\(perenualHelper.plantDetailResponse.watering ?? "")")
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                    HStack {
                        Text("Attracts:")
                        Text("\(perenualHelper.plantDetailResponse.attracts?.joined(separator: ", ") ?? "")")
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                    HStack{
                        Text("Sunglight:")
                        Text("\(perenualHelper.plantDetailResponse.sunlight?.joined(separator: ", ") ?? "")")
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                    HStack{
                        Text("Soil:")
                        Text("\(perenualHelper.plantDetailResponse.soil?.joined(separator: ", ") ?? "")")
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                    HStack{
                        Text("Dimension:")
                        Text("\(perenualHelper.plantDetailResponse.dimension ?? "")")
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                    HStack{
                        Text("Propagation:")
                        Text("\(perenualHelper.plantDetailResponse.propagation?.joined(separator: ", ") ?? "")")
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                }
                Section {
                    HStack{
                        Text("Growth rate:")
                        Text("\(perenualHelper.plantDetailResponse.growth_rate ?? "")")
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                    HStack{
                        Text("Maintenance:")
                        Text("\(perenualHelper.plantDetailResponse.maintenance ?? "")")
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                    HStack{
                        Text("Invasive:")
                        Text("\((perenualHelper.plantDetailResponse.invasive != nil) && (perenualHelper.plantDetailResponse.invasive == true) ? "Yes" : "No")")
                            .frame(maxWidth: .infinity, alignment: .trailing)

                    }
                }
                Button(action:{
                    
                    showingNicknameAlert.toggle()
                    
                    
                }){
                    HStack {
                        SwiftUI.Image(systemName: "heart.fill")
                            .foregroundColor(Color.red).buttonStyle(.plain)
                        Text("Add to My Plants")
                    }
                }
                .alert("Enter the nickname", isPresented: $showingNicknameAlert) {
                            TextField("nickname", text: $nickname)
                            Button("OK", action: self.insertPlant)
                    Button("cancel", role: .cancel){}
                        }
            }
        }
        .onAppear {
            self.getDetail()
        }
    }

    private func insertPlant(){
        //let userId = fireAuthHelper.user?.email ?? ""
        let userEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""

        let newPlant = Plant(api_id: selectedPlant, nick_name : nickname, common_name: perenualHelper.plantDetailResponse.common_name ?? "", watering: perenualHelper.plantDetailResponse.watering ?? "")

        //self.fireDBHelper.insertPlant(newPlant: newPlant, userID: userId)
        self.fireDBHelper.insertPlant(newPlant: newPlant, userEmail: userEmail)
    }

    private func getDetail(){
        self.perenualHelper.fetchPlant(id: selectedPlant, withCompletion: {resp in
            print(#function, "onAppear - data : \(resp)")
        })
    }
}
