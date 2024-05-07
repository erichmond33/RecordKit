//
//  WindowController.swift
//  RecordKit
//
//  Created by Eli Richmond on 5/7/24.
//

import Foundation
import Cocoa
import SwiftUI

class WindowController: NSWindowController {
     init() {
        let screenRect = NSScreen.main?.visibleFrame ?? NSRect(x: 0, y: 0, width: 1000, height: 800) // Fallback in case there is no screen
        let windowWidth: CGFloat = 300
        let windowHeight: CGFloat = 50
        
        // Calculating the horizontal center and 10% from the bottom
        let xPos = screenRect.midX - windowWidth / 2
        let yPos = screenRect.minY + screenRect.height * 0.1

        let window = NSWindow(
            contentRect: NSRect(x: xPos, y: yPos, width: windowWidth, height: windowHeight),
            styleMask: [.borderless],
            backing: .buffered, defer: false)
        window.isOpaque = false
        window.hasShadow = true
        window.backgroundColor = NSColor.clear
        window.level = .floating
        super.init(window: window)
        window.contentView = NSHostingView(rootView: FloatingToolbar())
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
