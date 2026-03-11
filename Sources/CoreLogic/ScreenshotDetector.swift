import Photos
#if canImport(UIKit)
import UIKit
#endif

/// Screenshot detection and bulk management module
/// Implements Issue #4: Bulk Screenshot Identification & Cleanup
public class ScreenshotDetector {
    
    /// Fetch all screenshots from the photo library
    /// - Returns: PHFetchResult containing all screenshot assets
    public static func fetchScreenshots() -> PHFetchResult<PHAsset> {
        let fetchOptions = PHFetchOptions()
        
        // Filter for images only
        fetchOptions.predicate = NSPredicate(
            format: "(mediaType == %d) AND (mediaSubtype & %d) != 0",
            PHAssetMediaType.image.rawValue,
            PHAssetMediaSubtype.photoScreenshot.rawValue
        )
        
        // Sort by creation date (newest first)
        fetchOptions.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        
        return PHAsset.fetchAssets(with: .image, options: fetchOptions)
    }
    
    /// Group screenshots by date
    /// - Parameter assets: PHFetchResult of screenshot assets
    /// - Returns: Dictionary with date keys and asset arrays
    public static func groupByDate(_ assets: PHFetchResult<PHAsset>) -> [String: [PHAsset]] {
        var grouped: [String: [PHAsset]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        assets.enumerateObjects { asset, _, _ in
            if let creationDate = asset.creationDate {
                let dateKey = dateFormatter.string(from: creationDate)
                if grouped[dateKey] == nil {
                    grouped[dateKey] = []
                }
                grouped[dateKey]?.append(asset)
            }
        }
        
        return grouped
    }
    
    /// Bulk delete screenshots
    /// - Parameter assets: Array of PHAsset to delete
    /// - Parameter completion: Completion handler with success status
    public static func bulkDelete(
        _ assets: [PHAsset],
        completion: @escaping (Bool, Error?) -> Void
    ) {
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.deleteAssets(assets as NSArray)
        }, completionHandler: completion)
    }
    
    /// Get total storage used by screenshots
    /// - Parameter assets: PHFetchResult of screenshot assets
    /// - Returns: Total size in bytes
    public static func calculateTotalSize(_ assets: PHFetchResult<PHAsset>) -> Int64 {
        var totalSize: Int64 = 0
        
        assets.enumerateObjects { asset, _, _ in
            let resources = PHAssetResource.assetResources(for: asset)
            for resource in resources {
                if let size = resource.value(forKey: "fileSize") as? Int64 {
                    totalSize += size
                }
            }
        }
        
        return totalSize
    }
    
    /// Format byte size to human-readable string
    /// - Parameter bytes: Size in bytes
    /// - Returns: Formatted string (e.g., "12.5 MB")
    public static func formatSize(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useMB, .useGB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
}
