import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var fireAuthHelper: FireAuthHelper
    
    @State private var userEmail: String = ""
    @State private var userPassword: String = ""
    
    @State private var homeSelection: Int? = nil
    @State private var signUpSelection: Int? = nil
    
    @Binding var rootScreen: RootView
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) { // Set spacing to 0
                NavigationLink(
                    destination: SignUpView(rootScreen: $rootScreen).environmentObject(self.fireAuthHelper),
                    tag: 3,
                    selection: self.$signUpSelection
                ) {
                    EmptyView()
                }
                
                Form {
                    Section(header: Text("Login").foregroundColor(.green)) {
                        TextField(
                            "User Email",
                            text: self.$userEmail
                        )
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textContentType(.emailAddress)
                        .keyboardType(.emailAddress)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                        
                        SecureField(
                            "Password",
                            text: self.$userPassword
                        )
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .textContentType(.password)
                        .keyboardType(.default)
                        .padding()
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Button(action: {
                        // Validate the data
                        if isValidEmail(userEmail) && isValidPassword(userPassword) {
                            self.fireAuthHelper.signIn(email: self.userEmail, password: self.userPassword)
                            
                            if fireAuthHelper.isSignIn() {
                                self.rootScreen = .Home
                            } else {
                                self.homeSelection = 2
                            }
                        } else {
                            // Show alert for invalid email or password
                            self.alertMessage = "Invalid email or password"
                            self.showAlert = true
                        }
                    }) {
                        Text("Sign In")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    
                    NavigationLink(
                        destination: SignUpView(rootScreen: $rootScreen).environmentObject(self.fireAuthHelper),
                        tag: 3,
                        selection: self.$signUpSelection
                    ) {
                        Text("Sign Up")
                            .foregroundColor(.green)
                            .underline()
                            .padding(.vertical)
                    }
                }
                
                SwiftUI.Image(systemName: "leaf")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
            }
            .padding()
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.green.opacity(0.8), Color.white]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .edgesIgnoringSafeArea(.all)
            )
        }
        .navigationBarTitle("Welcome to Plant+")
        .accentColor(.green)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Validation Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
       
    }
    
    // Validate email format
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    // Validate password length
    private func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
}
