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
}

func signInUser(email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
        //error management
        print("There was an issue")
    }
}

func signUpUser(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
        //error management
        print("There was an issue")
        // Handle successful account creation
        // For instance, navigate to the sign-in page or directly to the main content of your app
    }
}
