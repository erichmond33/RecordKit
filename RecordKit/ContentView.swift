//import SwiftUI
//import AVFoundation
//
//struct ContentView: View {
//    @StateObject private var videoPlayerViewModel = VideoPlayerViewModel()
//
//    var body: some View {
//        VStack {
//            VideoPlayerView(player: videoPlayerViewModel.player)
//                .frame(height: 300)
//                .onAppear {
//                    videoPlayerViewModel.setupPlayer()
//                }
//            ThumbnailsView(thumbnails: videoPlayerViewModel.thumbnails) { index in
//                videoPlayerViewModel.seekToTime(index: index)
//            }
//            .frame(height: 100)
//        }
//    }
//}
//
//struct VideoPlayerView: NSViewRepresentable {
//    var player: AVPlayer
//
//    func makeNSView(context: Context) -> NSView {
//        let view = NSView()
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = view.bounds
//        view.layer = playerLayer
//        view.layer?.masksToBounds = true
//        return view
//    }
//
//    func updateNSView(_ nsView: NSView, context: Context) {}
//}
//
//struct ThumbnailsView: View {
//    let thumbnails: [NSImage]
//    let onThumbnailTap: (Int) -> Void
//
//    var body: some View {
//        ScrollView(.horizontal) {
//            HStack {
//                ForEach(thumbnails.indices, id: \.self) { index in
//                    Image(nsImage: thumbnails[index])
//                        .resizable()
//                        .frame(width: 100, height: 56)
//                        .onTapGesture {
//                            onThumbnailTap(index)
//                        }
//                }
//            }
//        }
//    }
//}
//
//class VideoPlayerViewModel: ObservableObject {
//    @Published var player = AVPlayer()
//    @Published var thumbnails: [NSImage] = []
//
//    func setupPlayer() {
//        let videoURL = URL(fileURLWithPath: "/Users/erichmond_33/Desktop/recordedVideo.mp4")
//        player = AVPlayer(url: videoURL)
//        generateThumbnails(from: videoURL)
//    }
//
//    private func generateThumbnails(from url: URL) {
//        let asset = AVAsset(url: url)
//        let assetImageGenerator = AVAssetImageGenerator(asset: asset)
//        assetImageGenerator.appliesPreferredTrackTransform = true
//
//        let duration = CMTimeGetSeconds(asset.duration)
//        let times = stride(from: 0, to: duration, by: 1).map { CMTimeMakeWithSeconds($0, preferredTimescale: 600) }
//
//        thumbnails = times.compactMap { time in
//            do {
//                let cgImage = try assetImageGenerator.copyCGImage(at: time, actualTime: nil)
//                return NSImage(cgImage: cgImage, size: NSSize(width: 100, height: 56))
//            } catch {
//                print(error)
//                return nil
//            }
//        }
//    }
//
//    func seekToTime(index: Int) {
//        let time = CMTimeMakeWithSeconds(Float64(index), preferredTimescale: 600)
//        player.seek(to: time)
//    }
//}
//



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

            VideoPlayer(player: player)
                .frame(width: 400, height: 200)
                .onAppear {
                    player.play()
                }
        }
    }
}
