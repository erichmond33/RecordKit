import SwiftUI
import AVKit
import AVFoundation

struct ContentView: View {
    var body: some View {
        Text("Main app content goes here")
        // Add other views as needed
    }
}


//struct ContentView: View {
//    @StateObject private var screenRecorder = ScreenCapture()
//    @State private var player = AVPlayer()
//    @State private var isRecording = false
//    @State private var currentFilePath: String = ""
//
//    var body: some View {
//        VStack {
//            Button(isRecording ? "Stop Recording" : "Start Recording") {
//                toggleRecording()
//            }
//            .padding()
//
//            VideoPlayer(player: player)
//                .frame(width: 300, height: 200)
//                .onAppear {
//                    player.play()  // Try to play when view appears
//                }
//        }
//        .onAppear {
//            screenRecorder.setupCaptureSession()
//        }
//    }
//
//    /// Toggles the recording state and handles file operations.
//    private func toggleRecording() {
//        if isRecording {
//            // Stop recording
//            screenRecorder.stopRecording()
//            isRecording = false
//
//            // Wait for a bit before trying to play the video
//            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//                setupPlayer()
//            }
//        } else {
//            // Start recording
//            let filePath = generateFilePath()
//            currentFilePath = filePath
//            screenRecorder.startRecording(to: filePath)
//            isRecording = true
//        }
//    }
//
//    /// Sets up the player with the current file path.
//    private func setupPlayer() {
//        let fileURL = URL(fileURLWithPath: currentFilePath)
//        if FileManager.default.fileExists(atPath: currentFilePath) {
//            let playerItem = AVPlayerItem(url: fileURL)
//
//            player.replaceCurrentItem(with: playerItem)
//        } else {
//            print("File does not exist at the path: \(currentFilePath)")
//        }
//    }
//
//    /// Generates a file path for the video with a timestamp.
//    private func generateFilePath() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
//        let dateString = dateFormatter.string(from: Date())
//        let desktopPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first!
//        return "\(desktopPath)/recordedVideo_\(dateString).mov"
//    }
//}
//
//
//class ScreenCapture: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
//    private var captureSession: AVCaptureSession?
//    private var movieOutput: AVCaptureMovieFileOutput?
//    private var activeInput: AVCaptureScreenInput?
//    
//    func setupCaptureSession() {
//        let session = AVCaptureSession()
//        session.sessionPreset = .high
//        
//        if let screen = NSScreen.main {
//            if let displayID = screen.deviceDescription[NSDeviceDescriptionKey("NSScreenNumber")] as? CGDirectDisplayID {
//                let screenInput = AVCaptureScreenInput(displayID: displayID)
//                screenInput?.capturesCursor = false
//                
//                if let screenInput = screenInput, session.canAddInput(screenInput) {
//                    session.addInput(screenInput)
//                    activeInput = screenInput
//                } else {
//                    print("Failed to create AVCaptureScreenInput")
//                }
//            }
//        }
//        
//        let output = AVCaptureMovieFileOutput()
//        if session.canAddOutput(output) {
//            session.addOutput(output)
//            movieOutput = output
//        }
//        
//        captureSession = session
//    }
//    
//    func startRecording(to path: String) {
//        guard let captureSession = captureSession, !captureSession.isRunning else { return }
//        captureSession.startRunning()
//        
//        let outputFileURL = URL(fileURLWithPath: path)
//        movieOutput?.startRecording(to: outputFileURL, recordingDelegate: self)
//    }
//    
//    func stopRecording() {
//        movieOutput?.stopRecording()
//    }
//    
//    func fileOutput(_ output: AVCaptureFileOutput, didStartRecordingTo fileURL: URL, from connections: [AVCaptureConnection]) {
//        print("Recording started")
//    }
//    
//    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
//        print("Recording finished: \(error?.localizedDescription ?? "Success")")
//        captureSession?.stopRunning()
//    }
//}
