import SwiftUI

struct MyPlantsView: View {
    @EnvironmentObject var fireDBHelper: FireDBHelper
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @EnvironmentObject var perenualHelper: PerenualHelper

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.8), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            VStack {
                List {
                    ForEach(self.fireDBHelper.plantList.enumerated().map({ $0 }), id: \.element.self) { index, currentPlant in
                        NavigationLink(destination: MyPlantsDetailView(selectedMyPlantApiId: currentPlant).environmentObject(self.perenualHelper)) {
                            HStack {
                                /*SwiftUI.Image(systemName: "leaf")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 70, height: 70)
                                    .foregroundColor(.green)
                                    .clipShape(Circle())
                                */
                                AsyncImage(url: URL(string: currentPlant.url_image)) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 70, height: 70)
                                        .foregroundColor(.green)
                                        .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    Text("\(currentPlant.nick_name ?? "")")
                                        .font(.headline)
                                        .foregroundColor(.black)
                                    
                                    Text("\(currentPlant.common_name ?? "")")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                        .italic()

                                    
                                        
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    .listRowBackground(Color.clear)
                    
                }
                .navigationTitle("My History")
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            // Get all plants from DB
            let userId = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
            self.fireDBHelper.plantList.removeAll()
            self.fireDBHelper.getAllPlants(plantID: userId)
        }
        .navigationViewStyle(StackNavigationViewStyle()) // Apply stack navigation style
        .accentColor(.green) // Set the accent color to green
        .background(Color.white) // Set background color to white
        .navigationBarTitle("Home", displayMode: .inline) // Set navigation title
    }
}
