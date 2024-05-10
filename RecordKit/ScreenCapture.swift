import AVKit
import AVFoundation
import Cocoa

class ScreenCapture: NSObject, ObservableObject, AVCaptureFileOutputRecordingDelegate {
    private var captureSession: AVCaptureSession?
    private var movieOutput: AVCaptureMovieFileOutput?
    private var activeInput: AVCaptureScreenInput?
    
    @Published var clickLocations: [(timestamp: CMTime, location: CGPoint)] = []
    private var eventMonitor: Any?

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
        
        // Start capturing mouse positions
        startMouseTracking()
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
        
        // Stop capturing mouse positions
        stopMouseTracking()
    }

    private func startMouseTracking() {
        print("Starting mouse tracking...")
        eventMonitor = NSEvent.addGlobalMonitorForEvents(matching: .leftMouseDown) { event in
            guard let isRecording = self.movieOutput?.isRecording, isRecording else {
                print("Not recording at the moment of click")
                return
            }
            let timestamp = CMTime(seconds: CACurrentMediaTime(), preferredTimescale: 1000)
            self.clickLocations.append((timestamp, event.locationInWindow))
            print("Click detected at \(timestamp), location: \(event.locationInWindow)")
        }
    }


    private func stopMouseTracking() {
        if let eventMonitor = eventMonitor {
            NSEvent.removeMonitor(eventMonitor)
        }
        print(self.clickLocations)
    }
}
