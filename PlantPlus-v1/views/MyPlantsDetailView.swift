//
//  MyPlantsDetailView.swift
//  PlantPlus-v1
//
//  Created by anthony on 2023-06-13.
//

import SwiftUI
import UserNotifications

struct MyPlantsDetailView: View {
    
    let selectedMyPlantApiId : Plant
    
    @EnvironmentObject var perenualHelper : PerenualHelper
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    @State var showingNoWateringPopup = false
    let dayIntervals = [1,3,5,7,14]
    
    @State private var selectedDayInterval = 1
    
    var body: some View {
        NavigationStack{
            
            
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.8), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    Text(" \(perenualHelper.plantDetailResponse.common_name ?? selectedMyPlantApiId.common_name)")
                        .font(.system(size: 26))
                    
                    //SwiftUI.Image(uiImage: perenualHelper.plantDetailResponse.image ?? URL(from: selectedMyPlantApiId.url_image))
                    //Ima
                    //    .resizable()
                    //    .frame(width: 200, height: 200)
                    AsyncImage(url: URL(string: selectedMyPlantApiId.url_image)) { image in
                                image.resizable()
                            } placeholder: {
                                ProgressView()
                            }
                            .frame(width: 300, height: 300)
                    Form{
                        Section {
                            
                            HStack {
                                Text("Watering:")
                                Text("\(perenualHelper.plantDetailResponse.watering ?? "Frequent")")
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                
                            }
                            
                            HStack{
                                SwiftUI.Picker("Select an interval", selection: $selectedDayInterval) {
                                    ForEach(dayIntervals, id: \.self) {
                                        Text("\($0) days")
                                    }
                                }
                            }
                            
                            HStack{
                                
                                Button(action: {
                                    // request permission
                                    UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                        if success {
                                            print("All set!")
                                        } else if let error = error {
                                            print(error.localizedDescription)
                                        }
                                    }
                                    
                                    // scheduling
                                    let content = UNMutableNotificationContent()
                                    content.title = "Water your \(perenualHelper.plantDetailResponse.common_name ?? selectedMyPlantApiId.common_name)"
                                    content.sound = UNNotificationSound.default
                                    
                                    
                                    
                                    // show this notification five seconds from now
                                    // TODO: for testing purpose, interval is set to 5 seconds
                                    //                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(selectedDayInterval * 86400), repeats: true)
                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                                    
                                    // choose a random identifier
                                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                                    
                                    // add our notification request
                                    UNUserNotificationCenter.current().add(request)
                                }
                                ) {
                                    Text("Set Reminder")
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .alert("No watering needed!", isPresented: $showingNoWateringPopup) {
                                Button("OK", role: .cancel) { }
                            }
                        }
                        
                        HStack {
                            Text("Sunlight:")
                            Text("\(perenualHelper.plantDetailResponse.sunlight?.joined(separator: ", ") ?? "")")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        
                    }
                }

                .onAppear {
                    self.getDetail()
                }
            }
        }
    }
    
    private func getDetail() {
        self.perenualHelper.fetchPlant(id: selectedMyPlantApiId.id ?? "", withCompletion: { resp in
            print(#function, "onAppear - data : \(resp)")
        })
    }
}
