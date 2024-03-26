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
    
    //variable storing the users ID so that articles will be able to know their author
    var userID: String? {
            return user?.uid
    }
    
    //userprofile functions
    
    //updates username (modified in ProfileView)
    func updateUserProfile(userId: String, username: String) {
        let db = Firestore.firestore()
        //taken from firebase "data model" and "data types" firestore documentation
        db.collection("users").document(userId).updateData(["username": username])
    }
    
    //Below functions utilize completion so that outside files can call without trying and catching for a faulty return
    
    //fetches username from userID with help of helper function fetchUserData
        //got help writing function signature for fetchUsername and fetchUserData from Swift documentation
    func fetchUsername(completion: @escaping (String?) -> Void) {
            guard let userId = self.userID else {
                completion(nil)
                return
            }
            
            fetchUserData(userId: userId) { userData in
                completion(userData?["username"] as? String)
            }
    }
        
    
    //fetches user data from userID, ensuring that documents created with no userID (anonomously) complete with an error
    func fetchUserData(userId: String, completion: @escaping ([String: Any]?) -> Void) {
        //taken from Firestore "getting data" and "data model" documentation
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
    
    //creates an instance of a user as a document once they sign up. messages for error and indication of succesful user creation are implemented as well to see if signing in/up and out work correctly
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
    
    //function exclusively used within "ArticleView" for retrieval or username from userID so that when users click on an article the author name appears correctly
    func fetchUsernameFromID(userId: String, completion: @escaping (String) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(userId).getDocument { document, error in //retrieve document of the user from the Firestore user collection -> then pass for error handling
            if let document = document, document.exists, let username = document.data()?["username"] as? String {
                //send username if valid userID
                completion(username)
            } else {
                print("Document does not exist or username is missing")
                //send user name as "Unknown User" if userID DNE or is invalid
                completion("Unknown User")
            }
        }
    }

}

    

