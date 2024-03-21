//
//  FirebasedBackedMobileAppDelegate.swift
//  FirebasedBackedMobileApp
//
//  Created by Ethan Wong on 3/18/24.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
