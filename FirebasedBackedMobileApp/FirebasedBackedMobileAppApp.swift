//
//  FirebasedBackedMobileAppApp.swift
//  FirebasedBackedMobileApp
//
//  Created by Ethan Wong on 3/18/24.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth



@main
struct FirebaseBackedMobileApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate


  var body: some Scene {
    WindowGroup {
      NavigationView {
        HomepageView()
        .environmentObject(FirebaseBackedMobileAppAuth())
        .environmentObject(FirebaseBackedMobileAppArticle())
      }
    }
  }
}
