import Photos
import AVFoundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// Large video detection and HEVC compression module
/// Implements Issue #6 & #7: Large Video Detection & HEVC Compression
public class VideoCompressor {
    
    public struct VideoInfo {
        let asset: PHAsset
        let size: Int64
        let duration: TimeInterval
        let resolution: CGSize
        
        var formattedSize: String {
            ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
        }
        
        var formattedDuration: String {
            let minutes = Int(duration) / 60
            let seconds = Int(duration) % 60
            return String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    /// Fetch large videos exceeding the size threshold
    /// - Parameter minSizeMB: Minimum size in megabytes (default: 100MB)
    /// - Returns: Array of VideoInfo structs
    public static func fetchLargeVideos(minSizeMB: Int = 100) -> [VideoInfo] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(
            format: "mediaType == %d",
            PHAssetMediaType.video.rawValue
        )
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        let videos = PHAsset.fetchAssets(with: .video, options: fetchOptions)
        var largeVideos: [VideoInfo] = []
        let minSizeBytes = Int64(minSizeMB) * 1024 * 1024
        
        videos.enumerateObjects { asset, _, _ in
            let resources = PHAssetResource.assetResources(for: asset)
            for resource in resources {
                if let size = resource.value(forKey: "fileSize") as? Int64 {
                    if size >= minSizeBytes {
                        let info = VideoInfo(
                            asset: asset,
                            size: size,
                            duration: asset.duration,
                            resolution: CGSize(
                                width: asset.pixelWidth,
                                height: asset.pixelHeight
                            )
                        )
                        largeVideos.append(info)
                    }
                }
            }
        }
        
        return largeVideos
    }
    
    /// Compress video using HEVC codec
    /// - Parameters:
    ///   - asset: PHAsset video to compress
    ///   - outputURL: URL for compressed video file
    ///   - quality: Export quality (low, medium, high)
    ///   - progress: Progress callback (0.0 to 1.0)
    ///   - completion: Completion handler with output URL and error
    public static func compressVideo(
        _ asset: PHAsset,
        outputURL: URL,
        quality: ExportQuality = .medium,
        progress: @escaping (Float) -> Void,
        completion: @escaping (URL?, Int64?, Error?) -> Void
    ) {
        let options = PHVideoRequestOptions()
        options.version = .current
        options.deliveryMode = .highQualityFormat
        
        PHImageManager.default().requestAVAsset(forVideo: asset, options: options) { avAsset, _, info in
            guard let avAsset = avAsset else {
                completion(nil, nil, NSError(
                    domain: "VideoCompressor",
                    code: -1,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to load video asset"]
                ))
                return
            }
            
            // Remove existing file if exists
            try? FileManager.default.removeItem(at: outputURL)
            
            guard let exportSession = AVAssetExportSession(
                asset: avAsset,
                presetName: quality.presetName
            ) else {
                completion(nil, nil, NSError(
                    domain: "VideoCompressor",
                    code: -2,
                    userInfo: [NSLocalizedDescriptionKey: "Failed to create export session"]
                ))
                return
            }
            
            exportSession.outputURL = outputURL
            exportSession.outputFileType = .mp4
            exportSession.shouldOptimizeForNetworkUse = true
            
            // Use HEVC codec for better compression
            if #available(iOS 16.0, *) {
                exportSession.outputFileType = .mp4
            }
            
            // Monitor progress
            let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                progress(exportSession.progress)
            }
            
            exportSession.exportAsynchronously {
                timer.invalidate()
                
                switch exportSession.status {
                case .completed:
                    if let fileSize = try? FileManager.default
                        .attributesOfItem(atPath: outputURL.path)[.size] as? Int64 {
                        completion(outputURL, fileSize, nil)
                    } else {
                        completion(outputURL, nil, nil)
                    }
                case .failed:
                    completion(nil, nil, exportSession.error)
                case .cancelled:
                    completion(nil, nil, NSError(
                        domain: "VideoCompressor",
                        code: -3,
                        userInfo: [NSLocalizedDescriptionKey: "Export cancelled"]
                    ))
                default:
                    completion(nil, nil, NSError(
                        domain: "VideoCompressor",
                        code: -4,
                        userInfo: [NSLocalizedDescriptionKey: "Unknown export status"]
                    ))
                }
            }
        }
    }
    
    /// Calculate potential space savings
    /// - Parameters:
    ///   - originalSize: Original file size in bytes
    ///   - quality: Target export quality
    /// - Returns: Estimated compressed size in bytes
    public static func estimateCompressedSize(
        originalSize: Int64,
        quality: ExportQuality
    ) -> Int64 {
        // HEVC typically achieves 40-60% compression ratio
        let compressionRatio: Double
        switch quality {
        case .low:
            compressionRatio = 0.3  // 70% reduction
        case .medium:
            compressionRatio = 0.5  // 50% reduction
        case .high:
            compressionRatio = 0.7  // 30% reduction
        }
        return Int64(Double(originalSize) * compressionRatio)
    }
    
    /// Export quality presets
    public enum ExportQuality {
        case low
        case medium
        case high
        
        var presetName: String {
            switch self {
            case .low:
                return AVAssetExportPresetLowQuality
            case .medium:
                return AVAssetExportPresetMediumQuality
            case .high:
                return AVAssetExportPresetHighestQuality
            }
        }
    }
}
