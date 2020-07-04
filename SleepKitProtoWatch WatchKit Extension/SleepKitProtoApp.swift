//
//  SleepKitProtoApp.swift
//  SleepKitProtoWatch WatchKit Extension
//
//  Created by 현 on 2020/07/02.
//  Copyright © 2020 현. All rights reserved.
//

import SwiftUI

@main
struct SleepKitProtoApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
