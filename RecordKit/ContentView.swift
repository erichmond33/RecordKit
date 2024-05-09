import SwiftUI
import AVKit
import AVFoundation
import Quartz

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
                    selectWindow()
                }

                Button("Select Area") {
                    selectArea()
                }
                
                Button("Record Full Screen") {
                    recordFullScreen()
                }
            }
            
            Button(isRecording ? "Stop Recording" : "Start Recording") {
                toggleRecording()
            }
            .padding()

            VideoPlayer(player: player)
                .frame(width: 300, height: 200)
                .onAppear {
                    player.play()  // Try to play when view appears
                }
        }
    }

    /// Toggles the recording state and handles file operations.
    private func toggleRecording() {
        if isRecording {
            // Stop recording
            screenRecorder.stopRecording()
            isRecording = false

            // Wait for a bit before trying to play the video
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                setupPlayer()
            }
        } else {
            // Start recording
            let filePath = generateFilePath()
            currentFilePath = filePath
            screenRecorder.startRecording(to: filePath)
            isRecording = true
        }
    }

    /// Sets up the player with the current file path.
    private func setupPlayer() {
        let fileURL = URL(fileURLWithPath: currentFilePath)
        if FileManager.default.fileExists(atPath: currentFilePath) {
            let playerItem = AVPlayerItem(url: fileURL)

            player.replaceCurrentItem(with: playerItem)
        } else {
            print("File does not exist at the path: \(currentFilePath)")
        }
    }

    /// Generates a file path for the video with a timestamp.
    private func generateFilePath() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = dateFormatter.string(from: Date())
        let desktopPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first!
        return "\(desktopPath)/recordedVideo_\(dateString).mov"
    }
    
    private func selectWindow() {
        let options = CGWindowListOption(arrayLiteral: .optionOnScreenOnly, .excludeDesktopElements)
        let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as NSArray? as? [[String: AnyObject]]
        guard let windows = windowList else { return }

        // Show a list of windows to the user (simplified for this example)
        let windowNames = windows.compactMap { $0["kCGWindowName"] as? String }.joined(separator: "\n")
        print("Available windows:\n\(windowNames)")

        // For this example, we'll select the first window
        if let firstWindow = windows.first,
           let boundsDict = firstWindow["kCGWindowBounds"] as? [String: CGFloat],
           let x = boundsDict["X"],
           let y = boundsDict["Y"],
           let width = boundsDict["Width"],
           let height = boundsDict["Height"] {
            
            let mainScreenHeight = NSScreen.main?.frame.height ?? 0
            selectedRect = CGRect(x: x, y: mainScreenHeight - y - height, width: width, height: height)
            screenRecorder.setupCaptureSession(rect: selectedRect)
        }
    }
    
    private func selectArea() {
        // A simple example to let the user draw a rectangle
        // In a real app, you would present a UI to let the user draw this
        selectedRect = CGRect(x: 100, y: 100, width: 300, height: 200)
        screenRecorder.setupCaptureSession(rect: selectedRect)
    }
    
    private func recordFullScreen() {
        // Capture the full screen
        if let screen = NSScreen.main {
            selectedRect = screen.frame
            screenRecorder.setupCaptureSession(rect: selectedRect)
        }
    }
}


class ScreenCapture: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    private var captureSession: AVCaptureSession?
    private var movieOutput: AVCaptureMovieFileOutput?
    private var activeInput: AVCaptureScreenInput?

    func setupCaptureSession(rect: CGRect? = nil) {
        let session = AVCaptureSession()
        session.sessionPreset = .high

        if let screen = NSScreen.main, let displayID = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID {
            guard let screenInput = AVCaptureScreenInput(displayID: displayID) else {
                print("Failed to create AVCaptureScreenInput")
                return
            }

            if let rect = rect {
                screenInput.cropRect = rect
            }
            screenInput.capturesCursor = false

            if session.canAddInput(screenInput) {
                session.addInput(screenInput)
                activeInput = screenInput
            } else {
                print("Failed to add AVCaptureScreenInput to session")
            }
        }

        let output = AVCaptureMovieFileOutput()
        if session.canAddOutput(output) {
            session.addOutput(output)
            movieOutput = output
        }

        captureSession = session
    }

    func startRecording(to path: String) {
        guard let captureSession = captureSession, !captureSession.isRunning else { return }
        captureSession.startRunning()

        let outputFileURL = URL(fileURLWithPath: path)
        movieOutput?.startRecording(to: outputFileURL, recordingDelegate: self)
    }

    func stopRecording() {
        movieOutput?.stopRecording()
    }

    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
        print("Recording started")
    }

    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        print("Recording finished: \(error?.localizedDescription ?? "Success")")
        captureSession?.stopRunning()
    }
}
