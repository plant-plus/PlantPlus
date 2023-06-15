import SwiftUI

struct SignUpView: View {
    
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var name: String = ""
    @State private var contactNumber: String = ""
    
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    @Binding var rootScreen: RootView
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Sign Up Form").foregroundColor(.black)) {
                    TextField("Enter Email", text: self.$email)
                                           .disableAutocorrection(true)
                                           .keyboardType(.emailAddress)
                                           .textContentType(.emailAddress)
                                           .font(.title3)
                                           .padding()
                                           .foregroundColor(.black)
                                           .background(RoundedRectangle(cornerRadius: 5).fill(Color(.systemGreen).opacity(0.2)))
                    
                    SecureField("Enter Password", text: self.$password)
                                           .disableAutocorrection(true)
                                           .textContentType(.password)
                                           .font(.title3)
                                           .padding()
                                           .foregroundColor(.black)
                                           .background(RoundedRectangle(cornerRadius: 5).fill(Color(.systemGreen).opacity(0.2)))
                    
                    SecureField("Enter Password Again", text: self.$confirmPassword)
                                        .disableAutocorrection(true)
                                        .textContentType(.password)
                                        .font(.title3)
                                        .padding()
                                        .foregroundColor(.black)
                                        .background(RoundedRectangle(cornerRadius: 5).fill(Color(.systemGreen).opacity(0.2)))
                    
                    TextField("Enter Name", text: self.$name)
                                           .disableAutocorrection(true)
                                           .font(.title3)
                                           .padding()
                                           .foregroundColor(.black)
                                           .background(RoundedRectangle(cornerRadius: 5).fill(Color(.systemGreen).opacity(0.2)))
                    
                    TextField("Enter Contact Number", text: self.$contactNumber)
                                        .disableAutocorrection(true)
                                        .keyboardType(.phonePad)
                                        .font(.title3)
                                        .padding()
                                        .foregroundColor(.black)
                                        .background(RoundedRectangle(cornerRadius: 5).fill(Color(.systemGreen).opacity(0.2)))
                }
            }
            .navigationTitle("Welcome")
            
            Section {
                Button(action: {
                    if validateForm() {
                        signUpUser()
                    }
                }) {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                }
            }
            
        }
        .accentColor(.green)
    }
    
    private func validateForm() -> Bool {
        if email.isEmpty || password.isEmpty || confirmPassword.isEmpty || name.isEmpty || contactNumber.isEmpty {
            showAlert(message: "All fields are required.")
            return false
        }
        
        if password != confirmPassword {
            showAlert(message: "Passwords do not match.")
            return false
        }
        
        if !isValidEmail(email) {
            showAlert(message: "Invalid email address.")
            return false
        }
        
        if !isValidPhoneNumber(contactNumber) {
            showAlert(message: "Invalid phone number.")
            return false
        }
        
        return true
    }
    
    private func signUpUser() {
        let newUser = UserPlants(name: self.name, email: self.email, contactNumber: self.contactNumber)
        
        self.fireAuthHelper.signUp(newUser: newUser, password: self.password)
        self.rootScreen = .Home
    }
    
    private func showAlert(message: String) {
        alertMessage = message
        showAlert = true
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPredicate.evaluate(with: email)
    }
    
    private func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegEx = "^[0-9]{10}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneRegEx)
        return phonePredicate.evaluate(with: phoneNumber)
    }
}
