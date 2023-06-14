import SwiftUI
struct UserProfileView: View {
    
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    
    @EnvironmentObject var fireDBHelper : FireDBHelper
    @EnvironmentObject var fireAuthHelper : FireAuthHelper
    
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
                        saveUserData()
                    }) {
                        Text("Save")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.green)
                            .cornerRadius(10)
                    }
                }
            }//form ends
            .onAppear {
                self.name = self.fireDBHelper.user.name
                self.phoneNumber = self.fireDBHelper.user.contactNumber
                self.email = self.fireDBHelper.user.email
            }
        }
        .navigationBarTitle(Text("User Profile"), displayMode: .inline)
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
    
    func saveUserData() {
        let userData = UserPlants(name: self.name, email: self.email, contactNumber: self.phoneNumber)
        //Get id of document
        var userIdS = self.fireAuthHelper.user?.email ?? ""
        //updating document
        self.fireDBHelper.updateUser(userToUpdate: userData, userID: userIdS)
        //get data of user
        self.fireDBHelper.getUser()
    }
}
