import SwiftUI

struct PlantsView: View {
    @EnvironmentObject var perenualHelper: PerenualHelper
    @EnvironmentObject var fireDBHelper: FireDBHelper
    
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.8), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack {
                    List {
                        if searchText.isEmpty {
                            ForEach(self.perenualHelper.perenualResponse.data?.enumerated().map({$0}) ?? [], id: \.element.self) { index, currentPlant in
                                NavigationLink(destination: PlantDetailView(selectedPlant: "\(currentPlant.id!)")) {
                                    HStack {
                                        SwiftUI.Image(uiImage: currentPlant.image ?? UIImage())
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 80, height: 80)
                                        VStack(alignment: .leading) {
                                            Text("\(currentPlant.common_name ?? "")")
                                                .bold()
                                            Text("Scientific Name: \(currentPlant.scientific_name?[0] ?? "")")
                                        }
                                    }
                                }
                            }
                        } else {
                            ForEach(self.perenualHelper.perenualResponse.data?.enumerated().map({$0}) ?? [], id: \.element.self) { index, currentPlant in
                                if (currentPlant.common_name ?? "").contains(searchText) {
                                    NavigationLink(destination: PlantDetailView(selectedPlant: "\(currentPlant.id!)")) {
                                        HStack {
                                            SwiftUI.Image(uiImage: currentPlant.image ?? UIImage())
                                                .resizable()
                                                .aspectRatio(contentMode: .fit)
                                                .frame(width: 80, height: 80)
                                            VStack(alignment: .leading) {
                                                Text("\(currentPlant.common_name ?? "")")
                                                    .bold()
                                                Text("Scientific Name: \(currentPlant.scientific_name?[0] ?? "")")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                .searchable(text: $searchText)
            }
        }
        .onAppear() {
            self.getPlantsList()
            self.fireDBHelper.getUser()
        }
    }
    
    private func getPlantsList() {
        self.perenualHelper.fetchPlantList()
    }
}
