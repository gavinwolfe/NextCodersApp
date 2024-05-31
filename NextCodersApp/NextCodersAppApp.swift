//
//  NextCodersAppApp.swift
//  NextCodersApp
//
//  Created by Gavin Wolfe on 4/19/24.
//

import SwiftUI
import Firebase
@main
struct NextCodersAppApp: App {
    let persistenceController = PersistenceController.shared
    init () {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            if Auth.auth().currentUser?.isAnonymous == true {
                let defaults = UserDefaults.standard
                if let _ = defaults.string(forKey: "instructorMode") {
                    InstructorHub()
                } else if let _ = defaults.string(forKey: "parentMode") {
                    ParentHub()
                } else {
                    HomeHub()
                }
            } else {
                ContentView()
            }
        }
    }
}
