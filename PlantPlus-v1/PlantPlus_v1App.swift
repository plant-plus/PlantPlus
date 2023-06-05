//
//  PlantPlus_v1App.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-25.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

@main
struct PlantPlus_v1App: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
