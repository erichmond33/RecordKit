////
////  FloatingToolbar.swift
////  RecordKit
////
////  Created by Eli Richmond on 5/7/24.
////
//
//import Foundation
//import SwiftUI
//
//struct FloatingToolbar: View {
//    // States to track hover status for each button
//    @State private var isHoveringFullScreen = false
//    @State private var isHoveringWindow = false
//    @State private var isHoveringCustom = false
//    @State private var isHoveringVStack = false
//
//    var body: some View {
//        HStack(spacing: 10) {
//            Button(action: {
//                print("Capture Full Screen")
//                // Add functionality to capture full screen
//            }) {
//                VStack() {
//                    Image(systemName: "macwindow")
//                        .font(.system(size: 30))
//                    Text("hello")
//                        .frame(width: 60)
//                }
//                .padding(5)
//                .background(isHoveringVStack ? Color.blue : Color.clear)
//                .cornerRadius(10)
//                .onHover { hover in
//                    withAnimation(.linear(duration: 1)) {
//                        isHoveringVStack = hover
//                    }
//                }
//            }
//            .buttonStyle(.plain)
//            .onHover { over in
//                isHoveringFullScreen = over
//            }
//            
//            Button(action: {
//                print("Capture Window")
//                // Add functionality to capture a window
//            }) {
//                Text("Window")
//            }
//            .popover(isPresented: $isHoveringWindow) {
//                Text("Capture a specific window")
//                    .padding()
//                    .frame(width: 160)
//            }
//            .onHover { over in
//                isHoveringWindow = over
//            }
//            
//            Button(action: {
//                print("Capture Custom")
//                // Add functionality to capture a custom portion
//            }) {
//                Text("Custom Portion")
//            }
//            .popover(isPresented: $isHoveringCustom) {
//                Text("Capture a custom area of the screen")
//                    .padding()
//                    .frame(width: 160)
//            }
//            .onHover { over in
//                isHoveringCustom = over
//            }
//        }
//        .padding(15)
//        .background(Color.gray.opacity(0.8))
//        .cornerRadius(25)
//        .shadow(radius: 10)
//    }
//}
//
import Foundation
import SwiftUI

struct FloatingToolbar: View {
    // States to track hover status for each button
    @State private var isHoveringFullScreen = false
    @State private var isHoveringWindow = false
    @State private var isHoveringCustom = false

    // Common UI Settings
    let buttonPadding: CGFloat = 5
    let cornerRadius: CGFloat = 10
    let hoverAnimation: Animation = .snappy(duration: 0.75)

    var body: some View {
        HStack(spacing: 20) {
            // Button 1: Capture Full Screen
            Button(action: {
                print("Capture Full Screen")
            }) {
                buttonContent(title: "Full Screen", icon: "menubar.dock.rectangle", isHovered: $isHoveringFullScreen)
            }.buttonStyle(.plain)

            // Button 2: Capture Window
            Button(action: {
                print("Capture Window")
            }) {
                buttonContent(title: "Window", icon: "rectangle.inset.filled", isHovered: $isHoveringWindow)
            }.buttonStyle(.plain)

            // Button 3: Capture Custom
            Button(action: {
                print("Capture Custom")
            }) {
                buttonContent(title: "Custom", icon: "rectangle.dashed", isHovered: $isHoveringCustom)
            }.buttonStyle(.plain)
        }
        .padding()
        .background(Color.gray.opacity(0.8))
        .cornerRadius(25)
        .shadow(radius: 10)
    }

    @ViewBuilder
    private func buttonContent(title: String, icon: String, isHovered: Binding<Bool>) -> some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 45))
            Text(title)
                .font(.system(size: 12))
                .frame(width: 70)
        }
        .padding(buttonPadding)
        .background(isHovered.wrappedValue ? Color.blue : Color.clear)
        .cornerRadius(cornerRadius)
        .onHover { hover in
            withAnimation(hoverAnimation) {
                isHovered.wrappedValue = hover
            }
        }
    }
}
