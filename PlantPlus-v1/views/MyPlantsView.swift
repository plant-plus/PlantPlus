import SwiftUI

struct MyPlantsView: View {

    @EnvironmentObject var fireDBHelper: FireDBHelper
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    @EnvironmentObject var perenualHelper: PerenualHelper

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                gradient: Gradient(colors: [Color.green.opacity(0.8), Color.white]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)

            List {
                ForEach(self.fireDBHelper.plantList.enumerated().map({ $0 }), id: \.element.self) { index, currentPlant in
                    NavigationLink(destination: MyPlantsDetailView(selectedMyPlantApiId: "\(currentPlant.api_id)").environmentObject(self.perenualHelper)) {
                        HStack {
                            SwiftUI.Image(systemName: "leaf")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 70, height: 70)
                                .foregroundColor(.green)
                                .clipShape(Circle())

                            VStack(alignment: .leading) {
                                Text("\(currentPlant.common_name ?? "")")
                                    .font(.headline)
                                    .foregroundColor(.black)

                                Text("Id Plant - \(currentPlant.api_id)")
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
            .onAppear {
                // Get all plants from DB
                let userId = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
                self.fireDBHelper.plantList.removeAll()
                self.fireDBHelper.getAllPlants(plantID: userId)
            }
            .padding(.bottom, 20)
        }
    }
}
