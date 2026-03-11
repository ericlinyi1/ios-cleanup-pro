import Photos
#if canImport(UIKit)
import UIKit
#endif

/// Album and collection management module
/// Implements Issue #5: Move to Custom Collections & Album Management
public class AlbumManager {
    
    /// Create a new album in the Photos library
    /// - Parameters:
    ///   - name: Album name
    ///   - completion: Completion handler with album identifier or error
    public static func createAlbum(
        name: String,
        completion: @escaping (String?, Error?) -> Void
    ) {
        var albumPlaceholder: PHObjectPlaceholder?
        
        PHPhotoLibrary.shared().performChanges({
            let createRequest = PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
            albumPlaceholder = createRequest.placeholderForCreatedAssetCollection
        }, completionHandler: { success, error in
            if success, let identifier = albumPlaceholder?.localIdentifier {
                completion(identifier, nil)
            } else {
                completion(nil, error)
            }
        })
    }
    
    /// Add assets to an existing album
    /// - Parameters:
    ///   - assets: Array of PHAsset to add
    ///   - albumIdentifier: Local identifier of target album
    ///   - completion: Completion handler with success status
    public static func addAssets(
        _ assets: [PHAsset],
        toAlbum albumIdentifier: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        guard let album = PHAssetCollection.fetchAssetCollections(
            withLocalIdentifiers: [albumIdentifier],
            options: nil
        ).firstObject else {
            completion(false, NSError(
                domain: "AlbumManager",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Album not found"]
            ))
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            let addRequest = PHAssetCollectionChangeRequest(for: album)
            addRequest?.addAssets(assets as NSArray)
        }, completionHandler: completion)
    }
    
    /// Move assets to a new or existing album
    /// - Parameters:
    ///   - assets: Array of PHAsset to move
    ///   - albumName: Target album name (creates if not exists)
    ///   - completion: Completion handler with success status
    public static func moveAssets(
        _ assets: [PHAsset],
        toAlbumNamed albumName: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        // First, try to find existing album
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title == %@", albumName)
        let collections = PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .any,
            options: fetchOptions
        )
        
        if let existingAlbum = collections.firstObject {
            // Album exists, add assets directly
            addAssets(assets, toAlbum: existingAlbum.localIdentifier, completion: completion)
        } else {
            // Create new album first, then add assets
            createAlbum(name: albumName) { identifier, error in
                if let identifier = identifier {
                    addAssets(assets, toAlbum: identifier, completion: completion)
                } else {
                    completion(false, error)
                }
            }
        }
    }
    
    /// Fetch all user-created albums
    /// - Returns: PHFetchResult of user albums
    public static func fetchUserAlbums() -> PHFetchResult<PHAssetCollection> {
        return PHAssetCollection.fetchAssetCollections(
            with: .album,
            subtype: .albumRegular,
            options: nil
        )
    }
    
    /// Get album info
    /// - Parameter album: PHAssetCollection
    /// - Returns: Dictionary with album metadata
    public static func getAlbumInfo(_ album: PHAssetCollection) -> [String: Any] {
        let assetCount = PHAsset.fetchAssets(in: album, options: nil).count
        
        return [
            "title": album.localizedTitle ?? "Untitled",
            "identifier": album.localIdentifier,
            "count": assetCount,
            "type": album.assetCollectionType.rawValue,
            "subtype": album.assetCollectionSubtype.rawValue
        ]
    }
    
    /// Delete an album (does not delete assets inside)
    /// - Parameters:
    ///   - albumIdentifier: Local identifier of album to delete
    ///   - completion: Completion handler with success status
    public static func deleteAlbum(
        _ albumIdentifier: String,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        guard let album = PHAssetCollection.fetchAssetCollections(
            withLocalIdentifiers: [albumIdentifier],
            options: nil
        ).firstObject else {
            completion(false, NSError(
                domain: "AlbumManager",
                code: -2,
                userInfo: [NSLocalizedDescriptionKey: "Album not found"]
            ))
            return
        }
        
        PHPhotoLibrary.shared().performChanges({
            PHAssetCollectionChangeRequest.deleteAssetCollections([album] as NSArray)
        }, completionHandler: completion)
    }
}
