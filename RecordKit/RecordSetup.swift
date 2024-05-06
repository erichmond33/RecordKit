//
//  RecordSetup.swift
//  RecordKit
//
//  Created by Eli Richmond on 5/3/24.
//
//
//import Foundation
//import ReplayKit
//
//class ViewController: NSViewController {
//    
//    private var screenRecorder: RPScreenRecorder?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        // Request screen recording permissions
//        RPScreenRecorder.shared().startRecording()
//    }
//    
//    private func startRecording() {
//        screenRecorder = RPScreenRecorder.shared()
//        screenRecorder?.startRecording { (error) in
//            if let error = error {
//                // Handle error
//                return
//            }
//            
//            // Recording started successfully
//        }
//    }
//    
//    // Other methods to stop and save the recording
//}
//
//import Foundation
//import ReplayKit
//import AVFoundation
//
//@objc class ViewController: NSViewController, RPScreenRecorderDelegate {
//    private var screenRecorder: RPScreenRecorder?
//    private var assetWriter: AVAssetWriter?
//    private var assetWriterInput: AVAssetWriterInput?
//    private var timer: Timer?
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        requestScreenRecordingPermission()
//    }
//    
//    private func requestScreenRecordingPermission() {
//        RPScreenRecorder.shared().isMicrophoneEnabled = false
//        RPScreenRecorder.shared().startRecording(handler: { (error) in
//            guard error == nil else {
//                print("Recording failed with error: \(error!.localizedDescription)")
//                return
//            }
//            self.startRecording()
//        })
//    }
//    
//    private func setupAssetWriter() {
//        do {
//            assetWriter = try AVAssetWriter(outputURL: outputURL() ?? URL(fileURLWithPath: "/default/output/path.mp4"), fileType: .mp4)
//            let outputSettings = [AVVideoCodecKey: AVVideoCodecType.h264] as [String: Any]
//            assetWriterInput = AVAssetWriterInput(mediaType: .video, outputSettings: outputSettings)
//            assetWriterInput?.expectsMediaDataInRealTime = true
//            assetWriter?.add(assetWriterInput!)
//        } catch {
//            print("Failed to create asset writer: \(error.localizedDescription)")
//            return
//        }
//    }
//
//    private func startRecording() {
//        screenRecorder = RPScreenRecorder.shared()
//        screenRecorder?.delegate = self
//        screenRecorder?.startCapture(handler: { (sampleBuffer, bufferType, error) in
//            guard error == nil else {
//                print("Capture failed with error: \(error!.localizedDescription)")
//                return
//            }
//            if CMSampleBufferDataIsReady(sampleBuffer) {
//                if self.assetWriterInput?.isReadyForMoreMediaData == true {
//                    self.assetWriterInput?.append(sampleBuffer)
//                }
//            }
//        }, completionHandler: { (error) in
//            guard error == nil else {
//                print("Capture completion failed with error: \(error!.localizedDescription)")
//                return
//            }
//            self.assetWriter?.startWriting()
//            self.assetWriter?.startSession(atSourceTime: .zero)
//            self.timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { (_) in
//                self.stopRecording()
//            })
//        })
//    }
//    
//    private func stopRecording() {
//        screenRecorder?.stopCapture(handler: { (error) in
//            guard error == nil else {
//                print("Stop capture failed with error: \(error!.localizedDescription)")
//                return
//            }
//            self.assetWriterInput?.markAsFinished()
//            self.assetWriter?.finishWriting {      // The video file is now available at the outputURL()
//                // You can use this URL to display the video in SwiftUI
//            }
//        })
//    }
//
//    public func outputURL() -> URL? {
//        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
//        let outputURL = URL(fileURLWithPath: documentsPath).appendingPathComponent("recording.mp4")
//        return outputURL
//    }
//}

import ReplayKit
import Foundation

class ScreenRecorder {
    let recorder = RPScreenRecorder.shared()
    let temporaryDirectory = FileManager.default.temporaryDirectory

    func startRecording(enableMicorphone: Bool = false,completion: @escaping (Error?)->()){
        let recorder = RPScreenRecorder.shared()
        // Micorphone Option
        recorder.isMicrophoneEnabled = false
        // Starting Recording
        recorder.startRecording(handler: completion)
    }

    func stopRecording()async throws->URL{
        // File will be stored in Temporary Directory
        // Video Name
        let name = UUID().uuidString + ".mov"
        let url = FileManager.default.temporaryDirectory .appendingPathComponent (name)
        let recorder = RPScreenRecorder.shared()
        try await recorder.stopRecording(withOutput: url)
        return url
    }
}
