import Foundation
import Cocoa
import SwiftUI

class WindowController: NSWindowController {
    
    init() {
        let screen: NSScreen
        if let keyWindow = NSApp.keyWindow {
            screen = keyWindow.screen ?? NSScreen.main ?? NSScreen()
        } else {
            screen = NSScreen.main ?? NSScreen()
        }
        
        let screenRect = screen.visibleFrame
        let windowWidth: CGFloat = 400
        let windowHeight: CGFloat = 100
        let xPos = screenRect.midX - windowWidth / 2
        let yPos = screenRect.minY + screenRect.height * 0.1
        
        let window = NSWindow(
            contentRect: NSRect(x: xPos, y: yPos, width: windowWidth, height: windowHeight),
            styleMask: [.nonactivatingPanel], // Changed to borderless
            backing: .buffered, defer: false)
        
        window.level = .floating
        
        // Set window properties for transparency and no shadow
        window.isOpaque = false
        window.backgroundColor = NSColor.white.withAlphaComponent(0.0)
        window.hasShadow = true
        window.isMovableByWindowBackground = true
        window.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        super.init(window: window)
        
        // Create and configure the container view
        let containerView = NSView(frame: window.contentView!.bounds)
        containerView.autoresizingMask = [.width, .height]
        
        // Create and configure the visual effect view
        let visualEffectView = NSVisualEffectView(frame: containerView.bounds)
        visualEffectView.autoresizingMask = [.width, .height]
        visualEffectView.material = .hudWindow
        visualEffectView.blendingMode = .behindWindow
        visualEffectView.state = .active
        visualEffectView.wantsLayer = true
        visualEffectView.layer?.cornerRadius = 12
        visualEffectView.layer?.masksToBounds = true
        visualEffectView.layer?.borderWidth = 1 // Border width
        visualEffectView.layer?.borderColor = NSColor.darkGray.cgColor
        
        // Add the hosting view for SwiftUI
        let hostingView = NSHostingView(rootView: ContentView())
        hostingView.wantsLayer = true
        hostingView.layer?.cornerRadius = 12
        hostingView.frame = visualEffectView.bounds
        
        // Add subviews to the container view
        containerView.addSubview(visualEffectView)
        containerView.addSubview(hostingView)
        
        window.contentView = containerView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
