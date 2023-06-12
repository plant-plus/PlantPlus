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
            VStack{
                Text("AI PLANT")
                if let image = vm.image {
                    ZoomableScrollView {
                        SwiftUI.Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                } else {
                    SwiftUI.Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .opacity(0.6)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding(.horizontal)
                }
                
                
                Button(action:{
                    print("Identifying Plant")
                    let success = self.getUrlImage(image2: vm.image)
                    aiPlantHelper.performRequest(url: success)
                    //aiPlantHelper.performRequest()
                    //self.signUpSelection = 3
                }){
                    Text("Identify Plant")
                }//Button ends
                
                HStack {
                    Button {
                        vm.source = .camera
                        vm.showPhotoPicker()
                    } label: {
                        Text("Camera")
                    }
                    Button {
                        vm.source = .library
                        vm.showPhotoPicker()
                    } label: {
                        Text("Photos")
                    }
                }
            }.sheet(isPresented: $vm.showPicker) {
                ImagePicker(sourceType: vm.source == .library ? .photoLibrary : .camera, selectedImage: $vm.image)
                    .ignoresSafeArea()
            }
        }
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
