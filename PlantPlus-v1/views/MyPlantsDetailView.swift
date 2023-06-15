//
//  MyPlantsDetailView.swift
//  PlantPlus-v1
//
//  Created by anthony on 2023-06-13.
//

import SwiftUI
import UserNotifications

struct MyPlantsDetailView: View {
    
    let selectedMyPlantApiId : String
    
    @EnvironmentObject var perenualHelper : PerenualHelper
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    @State var showingNoWateringPopup = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.8), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(" \(perenualHelper.plantDetailResponse.common_name ?? "")")
                    .font(.system(size: 26))
                
                SwiftUI.Image(uiImage: perenualHelper.plantDetailResponse.image ?? UIImage())
                    .resizable()
                    .frame(width: 200, height: 200)
                
                Form {
                    Section {
                        
                        HStack {
                            Text("Watering:")
                            Text("\(perenualHelper.plantDetailResponse.watering ?? "")")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            
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
                                content.title = "Water your \(perenualHelper.plantDetailResponse.common_name ?? "")"
                                content.sound = UNNotificationSound.default

                                if perenualHelper.plantDetailResponse.watering ?? "" == "none" {
                                    // pop up, no watering
                                    showingNoWateringPopup = true
                                } else {
                                    var dayInterval = 1
                                    switch perenualHelper.plantDetailResponse.watering ?? "" {
                                    case "frequent":
                                        dayInterval = 1
                                    case "average":
                                        dayInterval = 3
                                    case "minimum":
                                        dayInterval = 7
                                    default:
                                        dayInterval = 1
                                    }
                                    
                                    // show this notification five seconds from now
                                    // TODO: for testing purpose, interval is set to 5 seconds
//                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(dayInterval * 86400), repeats: true)
                                    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

                                    // choose a random identifier
                                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

                                    // add our notification request
                                    UNUserNotificationCenter.current().add(request)
                                }
                            }) {
                                Text("Set Reminder")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .alert("No watering needed!", isPresented: $showingNoWateringPopup) {
                            Button("OK", role: .cancel) { }
                        }
                        
                        HStack {
                            Text("Sunlight:")
                            Text("\(perenualHelper.plantDetailResponse.sunlight?.joined(separator: ", ") ?? "")")
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                    }
                }
            }
            .onAppear {
                self.getDetail()
            }
        }
    }
    
    private func getDetail() {
        self.perenualHelper.fetchPlant(id: selectedMyPlantApiId, withCompletion: { resp in
            print(#function, "onAppear - data : \(resp)")
        })
    }
}
