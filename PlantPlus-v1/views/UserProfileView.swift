//
//  UserProfileView.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-25.
//

import SwiftUI

struct UserProfileView: View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    
    var body: some View {
        VStack {
            Form {
                Section {
                    TextField("Name", text: self.$name)
                        .disableAutocorrection(true)
                    TextField("Enter Email", text: self.$email)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                    TextField("Contact Number", text: self.$phoneNumber)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.namePhonePad)
                    Button(action: {
                    }) {
                        Text("Save")
                    }
                }
            }//form ends
            .onAppear {
                
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
