import SwiftUI
struct AIPlantsIdentifiedView: View {
    @EnvironmentObject var aiPlantHelper: AIPlantHelper
    
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
                            ForEach(self.aiPlantHelper.aIPlantResponse.suggestions?.enumerated().map({$0}) ?? [], id: \.element.self) { index, currentPlant in
                                NavigationLink(destination: PlantDetailView(selectedPlant: "\(currentPlant.id!)")) {
                                    HStack {
                                        SwiftUI.Image(uiImage: currentPlant.image ?? UIImage())
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 100, height: 100)
                                        VStack(alignment: .leading) {
                                            Text("\(currentPlant.plant_name ?? "")")
                                                .bold()
                                            Text("Probability: \(String(format: "%.2f", (currentPlant.probability ?? 0.0) * 100))%")
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
            //try to fetch weather using fetchWeatherInfo() function
            //self.getPlantsList()
        }
    }
}
