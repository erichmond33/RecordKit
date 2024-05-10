import SwiftUI
import AVKit
import AVFoundation
import Quartz

class ScreenRecorderHelper {
    static func toggleRecording(screenRecorder: ScreenCapture, isRecording: inout Bool, currentFilePath: String, player: AVPlayer, completion: @escaping (String) -> Void) {
        if isRecording {
            screenRecorder.stopRecording()
            isRecording = false

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                setupPlayer(player: player, currentFilePath: currentFilePath)
            }
        } else {
            let filePath = generateFilePath()
            screenRecorder.startRecording(to: filePath)
            isRecording = true
            completion(filePath)
        }
    }

    static func setupPlayer(player: AVPlayer, currentFilePath: String) {
        let fileURL = URL(fileURLWithPath: currentFilePath)
        if FileManager.default.fileExists(atPath: currentFilePath) {
            let playerItem = AVPlayerItem(url: fileURL)
            player.replaceCurrentItem(with: playerItem)
        } else {
            print("File does not exist at the path: \(currentFilePath)")
        }
    }

    static func generateFilePath() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = dateFormatter.string(from: Date())
        let desktopPath = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true).first!
        return "\(desktopPath)/recordedVideo_\(dateString).mov"
    }

    static func selectWindow(screenRecorder: ScreenCapture, selectedRect: inout CGRect?) {
        let options = CGWindowListOption(arrayLiteral: .optionOnScreenOnly, .excludeDesktopElements)
        let windowList = CGWindowListCopyWindowInfo(options, kCGNullWindowID) as NSArray? as? [[String: AnyObject]]
        guard let windows = windowList else { return }

        let windowNames = windows.compactMap { $0["kCGWindowName"] as? String }.joined(separator: "\n")
        print("Available windows:\n\(windowNames)")

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

    static func selectArea(screenRecorder: ScreenCapture, selectedRect: inout CGRect?) {
        selectedRect = CGRect(x: 100, y: 100, width: 300, height: 200)
        screenRecorder.setupCaptureSession(rect: selectedRect)
    }

    static func recordFullScreen(screenRecorder: ScreenCapture, selectedRect: inout CGRect?) {
        if let screen = NSScreen.main {
            selectedRect = screen.frame
            screenRecorder.setupCaptureSession(rect: selectedRect)
        }
    }
}
