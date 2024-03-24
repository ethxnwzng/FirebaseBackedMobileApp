/**
 * HomepageView shows the login screen and takes users to the main page where they can
 * search, view, and filter through articles.
 */
import SwiftUI
import Firebase

struct SignInView: View {
    @EnvironmentObject var auth: FirebaseBackedMobileAppAuth
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color.purple.edgesIgnoringSafeArea(.all) // Background color

            VStack(spacing: 20) {
                Text("Welcome to GamerBlog!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Text("A blogging app for video game players.")
                Spacer()
                    .frame(height:20)
                Text("Please sign in or sign up to get started.")
                    .font(.footnote)

                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)

                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(5.0)
                    .padding(.bottom, 20)
                    .disableAutocorrection(true)
                    .autocapitalization(.none)
                
                Button("Sign In") {
                    signInUser(email: email, password: password)
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color.black)
                .cornerRadius(15.0)

                Button("Sign Up") {
                    signUpUser(email: email, password: password)
                }
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(width: 220, height: 60)
                .background(Color.gray)
                .cornerRadius(15.0)
            }
            .padding()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    //Signs in a user, Auth.auth().signIn()... code taken from Firebase authentification documentation
    func signInUser(email: String, password: String) {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                } else if let user = authResult?.user {
                    self.auth.user = user
                }
            }
        }
        
        func signUpUser(email: String, password: String) {
            Auth.auth().createUser(withEmail: email, password: password) {  authResult, error in
                if let error = error {
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                } else if let user = authResult?.user {
                    self.auth.user = user
                    // Call to create user document in Firestore upon successful sign-up
                    auth.createUserDocument(userId: user.uid, email: email)
                }
            }
        }
    
}
#Preview {
    SignInView()
}
