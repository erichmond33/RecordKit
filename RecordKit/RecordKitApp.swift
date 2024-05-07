//
//  RecordKitApp.swift
//  RecordKit
//
//  Created by Eli Richmond on 5/3/24.
//

//import SwiftUI
//
//@main
//struct RecordKitApp: App {
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//    }
//}

import SwiftUI

@main
struct RecordKitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 300, height: 200) // Optional: Adjust the size as needed
                .onAppear {
                    setupFloatingToolbar()
                }
        }
        .commands {
            // Additional commands can be added here
        }
    }

    private func setupFloatingToolbar() {
        let windowController = WindowController()
        windowController.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true) // Bring the app to the foreground
    }
}

