//
//  HomeView.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-25.
//

import SwiftUI

struct HomeView: View {
    
    let perenualHelper = PerenualHelper()
    
    var body: some View {
        NavigationView {
            TabView {
                PlantsView()
                    .environmentObject(self.perenualHelper)
                    .tabItem {
                        Label("Plants", systemImage: "list.dash")
                    }
                
                MyPlantsView()
                    .tabItem {
                        Label("My Plants", systemImage: "square")
                    }
                
                UserProfileView()
                    .tabItem {
                        Label("Profile", systemImage: "person")
                    }
                
            }
            
        }// Navigation ends
    }// body ends
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
