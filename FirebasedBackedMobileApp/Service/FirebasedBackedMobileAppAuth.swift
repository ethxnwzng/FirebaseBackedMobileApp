//
//  FirebasedBackedMobileAppAuth.swift
//  FirebasedBackedMobileApp
//
//  Created by Ethan Wong on 3/18/24.
//

import Foundation
import Firebase
import FirebaseAuthUI
import FirebaseEmailAuthUI


class FirebaseBackedMobileAppAuth: NSObject, ObservableObject, FUIAuthDelegate {
    let authUI: FUIAuth? = FUIAuth.defaultAuthUI()

    // Multiple providers can be supported! See: https://firebase.google.com/docs/auth/ios/firebaseui
    let providers: [FUIAuthProvider] = [
        FUIEmailAuth()
    ]

    @Published var user: User?

    /**
     * You might not have overriden a constructor in Swift before...well, here it is.
     */
    override init() {
        super.init()

        // Note that authUI is marked as _optional_. If things don’t appear to work
        // as expected, check to see that you actually _got_ an authUI object from
        // the Firebase library.
        authUI?.delegate = self
        authUI?.providers = providers
    }

    /**
     * In another case of the documentation being somewhat behind the latest libraries,
     * this delegate method:
     *
     *     func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?)
     *
     * …has been deprecated in favor of the one below.
     */
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        if let actualResult = authDataResult {
            user = actualResult.user
        }
    }

    func signOut() throws {
        try authUI?.signOut()

        // If we get past the logout attempt, we can safely clear the user.
        user = nil
    }
    
    var userID: String? {
            return user?.uid
    }
    
    //userprofile functions
    func updateUserProfile(userId: String, username: String) {
        let db = Firestore.firestore()
        //taken from firebase "data model" and "data types" firestore documentation
        db.collection("users").document(userId).updateData(["username": username])
    }
    
    
    func fetchUsername(completion: @escaping (String?) -> Void) {
            guard let userId = self.userID else {
                completion(nil)
                return
            }
            
            fetchUserData(userId: userId) { userData in
                completion(userData?["username"] as? String)
            }
    }
        
    
    func fetchUserData(userId: String, completion: @escaping ([String: Any]?) -> Void) {
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(userId)
            
        userDocRef.getDocument { document, error in
            guard let document = document, document.exists else {
                print("No document found for user with ID \(userId)")
                //send nothing if user was not found
                completion(nil)
                return
            }
            //send user data
            completion(document.data())
        }
    }
    
    func createUserDocument(userId: String, email: String) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).setData([
            "email": email,
            "username": "No username yet" // Default username
        ]) { error in
            if let error = error {
                print("Error creating user document: \(error.localizedDescription)")
            } else {
                print("User document successfully created")
            }
        }
    }
    
    
    func fetchUsernameFromID(userId: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { document, error in
            if let document = document, document.exists, let username = document.data()?["username"] as? String {
                completion(username)
            } else {
                print("Document does not exist or username is missing")
                completion("Unknown User")
            }
        }
    }

}

    

