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
                LoginView(rootScreen: $root)
                    .environmentObject(self.fireAuthHelper)
                    .environmentObject(self.fireDBHelper)
                    .environmentObject(self.perenualHelper)
            case .Home:
                TabView {
                    AIPlantView()
                        .environmentObject(self.aiPlantHelper)
                        .environmentObject(self.vm)
                        .onAppear {
                            UserDefaults.standard.setValue(false, forKey: "_UIConstraintBasedLayoutLogUnsatisfiable")
                        }
                        .tabItem {
                            Label("AI Plants", systemImage: "sun.max.fill" )
                        }
                        .accentColor(.green) // Set the accent color to green

                    AIPlantsIdentifiedView()
                        .environmentObject(self.aiPlantHelper)
                        .tabItem {
                            Label("AI Plants I", systemImage: "square")
                        }
                        .accentColor(.green) // Set the accent color to green

                    MapSearchView()
                        .environmentObject(self.fireAuthHelper)
                        .environmentObject(self.fireDBHelper)
                        .environmentObject(self.perenualHelper)
                        .tabItem {
                            Label("Nurseries Near Me", systemImage: "map")
                        }
                        .accentColor(.green) // Set the accent color to green
                    
                    PlantsView()
                        .environmentObject(self.perenualHelper)
                        .environmentObject(self.fireDBHelper)
                        .environmentObject(self.fireAuthHelper)
                        .tabItem {
                            Label("Plants", systemImage: "list.dash")
                        }
                        .accentColor(.green) // Set the accent color to green

                    MyPlantsView()
                        .environmentObject(self.fireDBHelper)
                        .environmentObject(self.fireAuthHelper)
                        .environmentObject(self.perenualHelper)
                        .tabItem {
                            Label("My Plants", systemImage: "heart.fill")
                        }
                        .accentColor(.green) // Set the accent color to green

                    UserProfileView()
                        .environmentObject(self.fireAuthHelper)
                        .environmentObject(self.fireDBHelper)
                        .environmentObject(self.perenualHelper)
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                        .accentColor(.green) // Set the accent color to green
                }
                /*.navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: {
                            self.signOut()
                        }) {
                            Text("Sign Out")
                        }
                    }
                }*/
            } // Switch ends
        }// Navigation ends
        .navigationViewStyle(StackNavigationViewStyle()) // Apply stack navigation style
        .accentColor(.green) // Set the accent color to green
        .background(Color.white) // Set background color to white
        .navigationBarTitle("Home", displayMode: .inline) // Set navigation title
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
