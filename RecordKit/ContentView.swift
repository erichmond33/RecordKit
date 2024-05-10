import SwiftUI
import AVKit

struct ContentView: View {
    @StateObject private var screenRecorder = ScreenCapture()
    @State private var player = AVPlayer()
    @State private var isRecording = false
    @State private var currentFilePath: String = ""
    @State private var selectedRect: CGRect?

    var body: some View {
        VStack {
            HStack {
                Button("Select Window") {
                    ScreenRecorderHelper.selectWindow(screenRecorder: screenRecorder, selectedRect: &selectedRect)
                }

                Button("Select Area") {
                    ScreenRecorderHelper.selectArea(screenRecorder: screenRecorder, selectedRect: &selectedRect)
                }

                Button("Record Full Screen") {
                    ScreenRecorderHelper.recordFullScreen(screenRecorder: screenRecorder, selectedRect: &selectedRect)
                }
            }

            Button(isRecording ? "Stop Recording" : "Start Recording") {
                ScreenRecorderHelper.toggleRecording(
                    screenRecorder: screenRecorder,
                    isRecording: &isRecording,
                    currentFilePath: currentFilePath,
                    player: player
                ) { newFilePath in
                    currentFilePath = newFilePath
                }
            }
            .padding()

            if !currentFilePath.isEmpty {
                VideoPlayerWithCursorOverlay(player: player, mousePositions: screenRecorder.mousePositions)
                    .frame(width: 700, height: 500)
                    .onAppear {
                        player.play()
                    }
            } else {
                Text("No video to display")
            }
        }
    }
}
