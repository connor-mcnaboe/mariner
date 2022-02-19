//
//  Martian_WatchApp.swift
//  Martian Watch WatchKit Extension
//
//  Created by Connor McNaboe on 2/19/22.
//

import SwiftUI

@main
struct Martian_WatchApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
