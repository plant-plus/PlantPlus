//
//  FireAuthHelper.swift
//  PlantPlus-v1
//
//  Created by Test on 2023-05-31.
//

import Foundation
import FirebaseAuth

class FireAuthHelper : ObservableObject{
    
    @Published var user : User?{
        didSet{
            objectWillChange.send()
        }
    }
    
    func listenToAuthState(){
        Auth.auth().addStateDidChangeListener{[weak self] _, user in
            guard let self = self else{
                return
            }
            
            self.user = user
        }
    }
    
    func updateUserEmail(email : String){
        Auth.auth().currentUser?.updateEmail(to: email) { error in
            
        }
    }
    
    func updateUserPassword(password : String){
        Auth.auth().currentUser?.updatePassword(to: password) { error in
            
        }
    }
    
    func isSignIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true
        } else {
            return false
        }
    }
    
    func signUp(newUser : UserPlants, password : String){
        Auth.auth().createUser(withEmail : newUser.email.lowercased(), password: password){
            [self] authResult, error in
            
            guard let result = authResult else{
                print(#function, "Error while signug up the user : \(error)")
                return
            }
            
            print(#function, "AuthResult : \(result)")
            
            switch authResult{
            case .none:
                print(#function,  "Unable to create the account")
            case .some(_):
                print(#function, "Successfully created user account")
                self.user = authResult?.user
                FireDBHelper.getInstance()?.insertUser(newUser: newUser)
                UserDefaults.standard.set(self.user?.email, forKey: "KEY_EMAIL")
                
            }
        }
    }
    
    func signIn(email : String, password : String){
        Auth.auth().signIn(withEmail : email, password: password){
            [self] authResult, error in
            
            guard let result = authResult else{
                print(#function, "Error while signing up the user : \(error)")
                return
            }
            
            print(#function, "AuthResult : \(result)")
            
            switch authResult{
            case .none:
                print(#function,  "Unable to find the userr account")
            case .some(_):
                print(#function, "Login Successfull")
                self.user = authResult?.user
                print(#function, "Welcome \(self.user)")
                
                UserDefaults.standard.set(self.user?.email, forKey: "KEY_EMAIL")
            }
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.user = nil
            print("Sign out")
        } catch let signOutError as NSError {
            print(#function, "Unable to sign out user: \(signOutError)")
        }
        UserDefaults.standard.removeObject(forKey: "KEY_EMAIL")
    }
}
