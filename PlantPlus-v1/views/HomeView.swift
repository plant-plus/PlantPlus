//
//  HomeView.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-25.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct HomeView: View {
    private let fireDBHelper = FireDBHelper.getInstance() ?? FireDBHelper(store: Firestore.firestore())
    private let fireAuthHelper = FireAuthHelper()
    let perenualHelper = PerenualHelper()
    
    let aiPlantHelper = AIPlantHelper()
    
    //let viewModel = ViewModel()
    @StateObject var vm = PickerHelper()
    @State private var root: RootView = .Login
    
    var body: some View {
        NavigationView {
            switch root {
                case .Login:
                    LoginView(rootScreen: $root).environmentObject(self.fireAuthHelper).environmentObject(self.fireDBHelper).environmentObject(self.perenualHelper)
                case .Home:
                    TabView {
                        
                        AIPlantView()
                            .environmentObject(self.aiPlantHelper)
                            .environmentObject(self.vm)
                            .onAppear{
                                UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                            }
                            .tabItem {
                                Label("AI Plants", systemImage: "list.dash")
                            }
                        
                        AIPlantsIdentifiedView()
                            .environmentObject(self.aiPlantHelper)
                            .tabItem {
                                Label("AI Plants I", systemImage: "list.dash")
                            }
                        
                        PlantsView()
                            .environmentObject(self.perenualHelper)
                            .environmentObject(self.fireDBHelper)
                            .environmentObject(self.fireAuthHelper)
                            .tabItem {
                                Label("Plants", systemImage: "list.dash")
                            }
                        
                        MyPlantsView()
                            .environmentObject(self.fireDBHelper)
                            .environmentObject(self.fireAuthHelper)
                            .tabItem {
                                Label("My Plants", systemImage: "square")
                            }
                        
                        
                        UserProfileView()
                            .environmentObject(self.fireAuthHelper)
                            .environmentObject(self.fireDBHelper)
                            .environmentObject(self.perenualHelper)
                            .tabItem {
                                Label("Profile", systemImage: "person")
                            }
                        
                    }.navigationBarBackButtonHidden(true)
                    .toolbar{
                        ToolbarItemGroup(placement: .navigationBarTrailing){
                            Button(action: {
                                self.signOut()
                            }){
                                Text("Sign Out")
                            }
                        }
                    }
            } // Switch ends
        }// Navigation ends
    }// body ends
    
    func signOut() {
        self.fireAuthHelper.signOut()
        self.root = .Login
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
