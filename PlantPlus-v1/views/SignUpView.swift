//
//  SignUpView.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-06-01.
//

import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    @State private var email : String = ""
    @State private var password : String = ""
    @State private var confirmPassword : String = ""
    
    @State private var name : String = ""
    @State private var contactNumber : String = ""
    
    @Binding var rootScreen: RootView
    
    var body: some View {
        VStack{
            Form{
                Section("Sign Up Form") {
                    TextField("Enter Email", text: self.$email)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                    
                    SecureField("Enter Password", text: self.$password)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .textContentType(.password)
                        .keyboardType(.default)
                    
                    SecureField("Enter Password Again", text: self.$confirmPassword)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .textContentType(.password)
                        .keyboardType(.default)
                    
                    TextField("Enter Name", text: self.$name)
                        .disableAutocorrection(true)
                    
                    TextField("Enter Contact Number", text: self.$contactNumber)
                        .disableAutocorrection(true)
                        .keyboardType(.phonePad)
                }
            }//Forms ends
            .navigationTitle("Welcome")
            
            Section{
                Button(action: {
                    //validate the data
                    //such as all the inputs aere not empty
                    //and cgeck for password tule
                    //and display alert accordingly
                    
                    //if all the data is validated
                    self.singUpUser()
                }){
                    Text("Create Account")
                }//Button ends
                .disabled(self.password != self.confirmPassword && self.email.isEmpty && self.password.isEmpty && self.confirmPassword.isEmpty)
                
            }
            
        }//VStack ends
    }
    
    func singUpUser(){
        
        let newUser = UserPlants(name: self.name, email: self.email, contactNumber: self.contactNumber)
        
        self.fireAuthHelper.signUp(newUser: newUser, password: self.password)
        //self.rootScreen = .Home
    }
}

/*
struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}*/
