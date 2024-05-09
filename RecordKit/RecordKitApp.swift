//
//  RecordKitApp.swift
//  RecordKit
//
//  Created by Eli Richmond on 5/3/24.
//

import SwiftUI

@main
struct RecordKitApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

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

        // Hide the main app window
        if let window = NSApplication.shared.windows.first {
            window.orderOut(nil)
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Optional: Perform additional setup here
    }
}
