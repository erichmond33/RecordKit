// ContentView.swift
import SwiftUI
import AVKit
import ReplayKit
import ScriptingBridge

//struct ContentView: View {
//    @State private var isRecording = false
//    @State private var videoURL: URL?
//
//    let quickTime = SBApplication(bundleIdentifier: "com.apple.QuickTimePlayerX")
//
//    var body: some View {
//        VStack {
//            Button(action: {
//                if !isRecording {
//                    self.startRecording()
//                } else {
//                    Task {
//                        await self.stopRecording()
//                    }
//                }
//            }) {
//                Text(isRecording ? "Stop Recording" : "Start Recording")
//            }
//
//            if let videoURL = videoURL {
//                VideoPlayer(player: AVPlayer(url: videoURL))
//                    .frame(height: 300)
//            }
//        }
//    }
//
//    func startRecording() {
//        if let quickTime = quickTime {
//            let document = quickTime.class(forScriptingClass: "screen_recording")?.alloc() as? SBObject
//            if let document = document {
//                document.setValue(true, forKey: "entireScreen")
//                document.setValue(true, forKey: "recording")
//                isRecording = true
//            }
//        }
//    }
//
//    func stopRecording() async {
//        if let quickTime = quickTime {
//            let document = quickTime.class(forScriptingClass: "screen_recording")?.alloc() as? SBObject
//            if let document = document {
//                document.setValue(false, forKey: "recording")
//                isRecording = false
//                if let url = document.value(forKey: "outputFile") as? URL {
//                    videoURL = url
//                }
//            }
//        }
//    }
//}

struct ContentView: View {
    @State private var isRecording = false
    @State private var videoURL: URL?

    let screenRecorder = ScreenRecorder()

    var body: some View {
        VStack {
            Button(action: {
                if !isRecording {
                    self.startRecording()
                } else {
                    Task {
                        await self.stopRecording()
                    }
                }
            }) {
                Text(isRecording ? "Stop Recording" : "Start Recording")
            }

            if let videoURL = videoURL {
                VideoPlayer(player: AVPlayer(url: videoURL))
                    .frame(height: 300)
            }
        }
    }

    func startRecording() {
        screenRecorder.startRecording { error in
            if let error = error {
                print("Error starting recording: \(error.localizedDescription)")
            } else {
                print("Recording started successfully")
                self.isRecording = true
            }
        }
    }

    func stopRecording() async {
        do {
            let url = try await screenRecorder.stopRecording()
            self.videoURL = url
            self.isRecording = false
        } catch {
            print("Error stopping recording: \(error.localizedDescription)")
        }
    }

    class ScreenRecorder {
        let recorder = RPScreenRecorder.shared()

        func startRecording(enableMicrophone: Bool = false, completion: @escaping (Error?) -> ()) {
            recorder.isMicrophoneEnabled = enableMicrophone
            recorder.startRecording(handler: completion)
        }

        func stopRecording() async throws -> URL {
            let url = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mov")
            try await recorder.stopRecording(withOutput: url)
            return url
        }
    }
}

#Preview {
    ContentView()
}

//struct ContentView: View {
//    @State var text = "New texttt"
//    @State var image = NSImage()
//    @State var videoURL: URL?
//    let recorder = RPScreenRecorder.shared()
//
//    var body: some View {
//        NavigationView {
//            VStack(alignment: .center) {
//                Button("Basic Button") {
//                    text = "Start Recording"
//                    recorder.startRecording()
//                }
//                Button("Stop Recording") {
//                    text = "Stop Recording"
//                    recorder.stopRecording { (previewViewController, error) in
//                        if let error = error {
//                            print("Error: \(error)")
//                        }
//                        if let previewViewController = previewViewController {
//                            previewViewController.previewControllerDelegate = self
//                            self.present(previewViewController, animated: true, completion: nil)
//                        }
//                    }
//                }
//                Spacer()
//            }
//            .padding()
//            .frame(width: nil)
//            .navigationTitle("Hello World")
//
//            VStack(alignment: .center) {
//                Text(text)
//                // Show the video
//                if let videoURL = videoURL {
//                    VideoPlayerView(videoURL: videoURL)
//                }
//            }
//        }
//    }
//}
//
//struct VideoPlayerView: View {
//    var videoURL: URL
//
//    var body: some View {
//        VideoPlayer(player: AVPlayer(url: videoURL))
//            .edgesIgnoringSafeArea(.all)
//    }
//}

//     func screenShotWindow() -> Bool {
//         // Use "/usr/sbin/screencapture", arguments: ["-cw"])
//         let task = Process()
//         task.launchPath = "/usr/sbin/screencapture"
//         task.arguments = ["-cw"]
//         task.launch()
//         task.waitUntilExit()
//         return task.terminationStatus == 0
//     }

//     func getImageFromClipboard() -> NSImage {
//         let pasteboard = NSPasteboard.general
//         guard pasteboard.canReadObject(forClasses: [NSImage.self], options: nil) else {
//             return NSImage()
//         }
//         guard let image = NSImage(pasteboard: pasteboard) else {
//             return NSImage()
//         }
//         return image
//     }
// }
