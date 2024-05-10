import AVKit
import SwiftUI

struct VideoPlayerWithCursorOverlay: NSViewRepresentable {
    var player: AVPlayer
    var mousePositions: [CGPoint]

    func makeNSView(context: Context) -> NSView {
        return PlayerView(player: player, mousePositions: mousePositions)
    }

    func updateNSView(_ nsView: NSView, context: Context) {}
}

class PlayerView: NSView {
    private var player: AVPlayer
    private var playerLayer: AVPlayerLayer
    private var mousePositions: [CGPoint]
    private var nominalFrameRate: Double = 0.0

    init(player: AVPlayer, mousePositions: [CGPoint]) {
        self.player = player
        self.playerLayer = AVPlayerLayer(player: player)
        self.mousePositions = mousePositions
        super.init(frame: .zero)
        self.wantsLayer = true
        layer?.addSublayer(playerLayer)

        loadNominalFrameRate()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layout() {
        super.layout()
        playerLayer.frame = bounds
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        guard let currentItem = player.currentItem else { return }
        
        let currentTime = currentItem.currentTime()
        let frameIndex = Int(CMTimeGetSeconds(currentTime) * nominalFrameRate)
        
        if frameIndex < mousePositions.count {
            let cursorPosition = mousePositions[frameIndex]
            let cursorRect = CGRect(x: cursorPosition.x, y: cursorPosition.y, width: 35, height: 35) // Customize cursor size
            
            // Draw cursor
            let cursorPath = NSBezierPath(ovalIn: cursorRect)
            NSColor.black.setFill() // Customize cursor color
            cursorPath.fill()
        }
    }

    private func loadNominalFrameRate() {
        guard let currentItem = player.currentItem else { return }
        let videoTracks = currentItem.asset.tracks(withMediaType: .video)
        guard let videoTrack = videoTracks.first else { return }
        
        videoTrack.loadValuesAsynchronously(forKeys: ["nominalFrameRate"]) { [weak self] in
            guard let self = self else { return }
            var error: NSError? = nil
            let status = videoTrack.statusOfValue(forKey: "nominalFrameRate", error: &error)
            if status == .loaded {
                DispatchQueue.main.async {
                    self.nominalFrameRate = Double(videoTrack.nominalFrameRate)
                }
            } else {
                print("Failed to load nominal frame rate: \(String(describing: error))")
            }
        }
    }
}
