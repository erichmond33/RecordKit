import AVFoundation

class VideoProcessor {
    static func addZoomEffects(to inputPath: String, outputPath: String, clickLocations: [(timestamp: CMTime, location: CGPoint)], completion: @escaping (Bool) -> Void) {
        let asset = AVAsset(url: URL(fileURLWithPath: inputPath))
        let composition = AVMutableComposition()
        
        guard let videoTrack = asset.tracks(withMediaType: .video).first else {
            completion(false)
            return
        }

        let videoComposition = AVMutableVideoComposition(asset: asset) { request in
            let currentTime = request.compositionTime
            let click = clickLocations.first { CMTimeCompare($0.timestamp, currentTime) == 0 }
            
            var transform = CGAffineTransform.identity
            if let click = click {
                let zoomRect = CGRect(x: click.location.x - 50, y: click.location.y - 50, width: 100, height: 100)
                let scale = CGAffineTransform(scaleX: 2, y: 2)
                let translate = CGAffineTransform(translationX: -zoomRect.origin.x, y: -zoomRect.origin.y)
                transform = scale.concatenating(translate)
            }
            
            let outputImage = request.sourceImage.transformed(by: transform)
            request.finish(with: outputImage, context: nil)
        }

        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)!
        exporter.videoComposition = videoComposition
        exporter.outputURL = URL(fileURLWithPath: outputPath)
        exporter.outputFileType = .mp4
        
        exporter.exportAsynchronously {
            completion(exporter.status == .completed)
        }
    }
}
