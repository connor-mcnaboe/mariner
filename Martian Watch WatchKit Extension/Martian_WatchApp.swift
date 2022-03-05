//
//  Martian_WatchApp.swift
//  Martian Watch WatchKit Extension
//
//  Created by Connor McNaboe on 2/19/22.
//

import SwiftUI

@main
struct Martian_WatchApp: App {
    let enviroment = AppEnvironment.bootstrap()
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView(container: enviroment.container)
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
