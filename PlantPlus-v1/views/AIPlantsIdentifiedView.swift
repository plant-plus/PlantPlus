import SwiftUI
struct AIPlantsIdentifiedView: View {
    @EnvironmentObject var aiPlantHelper: AIPlantHelper
    @EnvironmentObject var fireDBHelper : FireDBHelper
    
    @State private var searchText = ""
    @State private var isPresentingConfirm: Bool = false
    
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
                                //NavigationLink(destination: PlantDetailView(selectedPlant: "\(currentPlant.id!)")) {
                                    HStack {
                                        SwiftUI.Image(uiImage: currentPlant.image ?? UIImage())
                                            .resizable()
                                            //.aspectRatio(contentMode: .fit)
                                            .frame(width: 70, height: 70)
                                            .foregroundColor(.green)
                                            .clipShape(Circle())
                                        VStack(alignment: .leading) {
                                            Text("\(currentPlant.plant_name ?? "")")
                                                .bold()
                                            Text("Probability: \(String(format: "%.2f", (currentPlant.probability ?? 0.0) * 100))%")
                                            
                                           
                                        }
                                        Button("Add Plant", role: .destructive) {
                                              isPresentingConfirm = true
                                            }.confirmationDialog("Are you sure?",
                                                                 isPresented: $isPresentingConfirm) {
                                                                 Button("Add plant", role: .destructive) {
                                                                     self.insertPlant(currentPlant: currentPlant)
                                                                  }
                                                                 .background(Color.green)
                                                                 .cornerRadius(10)
                                                                 .foregroundColor(.white)
                                                                
                                                                
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
            //self.getDetail(plantFromAI)
        }
    }
    
    //private func getDetail(plantFromAI : String){
    //    self.perenualHelper.fetchPlantFromAI()
    //}
    
    private func insertPlant(currentPlant : SuggestionsAIPlant){
        //let userId = fireAuthHelper.user?.email ?? ""
        let userEmail = UserDefaults.standard.string(forKey: "KEY_EMAIL") ?? ""
        var newPlant = Plant()
        
        print(currentPlant)
        
        newPlant.common_name = currentPlant.plant_name ?? ""
        newPlant.url_image = currentPlant.plant_details!.wiki_image!.value ?? ""
        newPlant.watering = ""
        //let newPlant = Plant(api_id: selectedPlant, nick_name : nickname, common_name: perenualHelper.plantDetailResponse.common_name ?? "", watering: perenualHelper.plantDetailResponse.watering ?? "")

        //self.fireDBHelper.insertPlant(newPlant: newPlant, userID: userId)
        self.fireDBHelper.insertPlant(newPlant: newPlant, userEmail: userEmail)
    }
}
