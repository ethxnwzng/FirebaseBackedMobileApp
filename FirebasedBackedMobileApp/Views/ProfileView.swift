import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var auth: FirebaseBackedMobileAppAuth
    @Binding var isPresented: Bool
    @State private var username: String = ""
    @State private var editingUsername: Bool = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    HStack {
                        if editingUsername {
                            TextField("No username yet", text: $username)
                                .autocapitalization(.none)
                        } else {
                            Text(username.isEmpty ? "No username yet" : username)
                            Spacer()
                            Button(action: {
                                self.editingUsername = true
                            }) {
                                Image(systemName: "pencil.circle")
                            }
                        }
                    }
                }
                
                if editingUsername {
                    Button("Save Changes") {
                        guard let userId = auth.userID else { return }
                        // Call updateUserProfile to save the new username
                        auth.updateUserProfile(userId: userId, username: username)
                        self.isPresented = false
                    }
                }
            }
            .navigationTitle("My Profile")
            .onAppear {
                // Fetch the current username when the view appears
                auth.fetchUsername { fetchedUsername in
                    self.username = fetchedUsername ?? ""
                }
            }
        }
    }
}
