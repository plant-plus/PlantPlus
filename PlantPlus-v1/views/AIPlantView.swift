//
//  AIPlantView.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-06-10.
//

import SwiftUI

struct AIPlantView: View {
    
    @EnvironmentObject var aiPlantHelper : AIPlantHelper
    @EnvironmentObject var vm: PickerHelper
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.4), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
                
                VStack{
                    if let image = vm.image {
                        ZoomableScrollView {
                            SwiftUI.Image(uiImage: image)
                                .resizable()
                                //.scaledToFit()
                                //.frame(minWidth: 0, maxWidth: .infinity)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 300, height: 250)
                        }
                    } else {
                        SwiftUI.Image(systemName: "leaf.fill")
                            .resizable()
                            //.scaledToFit()
                            .opacity(0.6)
                            //.frame(minWidth: 0, maxWidth: .infinity)
                            //.padding(.horizontal)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 300, height: 250)
                    }
                    HStack {
                        Button {
                            vm.source = .camera
                            vm.showPhotoPicker()
                        } label: {
                            VStack{
                                SwiftUI.Image("iconCamera")
                                    .resizable()
                                    .frame(width: 32.0, height: 32.0)
                                //Text("Camera")
                            }
                        }
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                        
                        Button {
                            vm.source = .library
                            vm.showPhotoPicker()
                        } label: {
                            VStack{
                                SwiftUI.Image("iconGallery")
                                    .resizable()
                                    .frame(width: 32.0, height: 32.0)
                                //Text("Camera")
                            }
                        }
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 2)
                        )
                    }.padding()
                    Button(action:{
                        print("Identifying Plant")
                        let success = self.getUrlImage(image2: vm.image)
                        aiPlantHelper.performRequest(url: success)
                        //aiPlantHelper.performRequest()
                        //self.signUpSelection = 3
                    }, label: {
                        VStack{
                            SwiftUI.Image("iconAI")
                                .resizable()
                                .frame(width: 32.0, height: 32.0)
                            //Text("Camera")
                        }
                    }
                    ).padding()
                    .background(Color.green)
                    .foregroundColor(Color.white)
                    .cornerRadius(10)
                    
                }.sheet(isPresented: $vm.showPicker) {
                    ImagePicker(sourceType: vm.source == .library ? .photoLibrary : .camera, selectedImage: $vm.image)
                        .ignoresSafeArea()
                }
            }
        } //Navigation view
 
    }
    
    
    func getUrlImage(image2: UIImage?) -> URL? {
        guard let data = image2!.jpegData(compressionQuality: 0.75) ?? image2!.pngData() else {
            return nil
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return nil
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            return URL(string : "\(directory.filePathURL!)fileName.png")
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func saveImage(image2: UIImage?) -> Bool {
        guard let data = image2!.jpegData(compressionQuality: 0.75) ?? image2!.pngData() else {
            return false
        }
        guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {
            return false
        }
        do {
            try data.write(to: directory.appendingPathComponent("fileName.png")!)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}

struct AIPlantView_Previews: PreviewProvider {
    static var previews: some View {
        AIPlantView()
    }
}
