//
//  LoginView.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-06-05.
//

import SwiftUI


struct LoginView: View {
    
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
    @State private var userEmail: String = ""
    @State private var userPassword: String = ""
    
    @State private var homeSelection : Int? = nil
    @State private var signUpSelection : Int? = nil
    
    @Binding var rootScreen: RootView
    
    var body: some View {
        NavigationView{
            VStack{
                NavigationLink(destination: SignUpView(rootScreen: $rootScreen).environmentObject(self.fireAuthHelper), tag: 3, selection: self.$signUpSelection){}
                
                Form {
                    Section("Login"){
                        TextField(
                            "User Email",
                            text: self.$userEmail
                        )
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        SecureField(
                            "Password",
                            text: self.$userPassword
                        )
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                        .textContentType(.password)
                        .keyboardType(.default)
                    }
                    
                    
                    Button(action:{
                        //validate the data
                        if(!self.userEmail.isEmpty && !self.userPassword.isEmpty){
                            
                            self.fireAuthHelper.signIn(email: self.userEmail, password: self.userPassword)
                            
                            if fireAuthHelper.isSignIn() {
                                self.rootScreen = .Home
                            } else {
                                self.homeSelection = 2
                            }
                        }else{
                            //trigger alert displaying errors
                            print(#function, "email and password cannot be empty")
                        }
                    }){
                        Text("Sign In")
                    }//Button ends
                    
                    
                    Text("or")
                    Button(action:{
                        print("SIGN UP")
                        self.signUpSelection = 3
                    }){
                        Text("Sign Up")
                    }//Button ends
                } // end forms
                SwiftUI.Image(systemName: "leaf")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                Spacer()
            }
            .navigationBarTitle("Welcome to Plant+")
        }
    } // end view
}

/*
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}*/
