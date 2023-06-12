//
//  PickerController.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-06-10.
//

import SwiftUI
import UIKit

class PickerHelper: ObservableObject {
    @Published var image: UIImage?
    @Published var showPicker = false
    @Published var source: Picker.Source = .library
    
    func showPhotoPicker() {
        if source == .camera {
            if !Picker.checkPermissions() {
                print("There is no camera on this device")
                return
            }
        }
        showPicker = true
    }
    
    
}
