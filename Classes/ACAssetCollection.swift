//
//  ACAssetCollection.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/2/24.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit
import Photos

class ACAssetCollection: NSObject {

    var assetCollection: PHAssetCollection
    
    var coverAsset: ACAsset? {
        guard let asset = assets.last else {
            return nil
        }
        return ACAsset(asset: asset)
    }
    
    var title: String? {
        return assetCollection.localizedTitle
    }
    
    var assetsCount: Int {
        return self.assets.count
    }
    
    var assets: [PHAsset] = []
    
    
    
    init(collection: PHAssetCollection) {
        assetCollection = collection
        super.init()
        ACAssetCollection.fetchAllAssets(InAssetCollection: collection) { assets in
            self.assets = assets
        }
    }
    
    /*
     case smartAlbumGeneric
     
     case smartAlbumPanoramas
     
     case smartAlbumVideos
     
     case smartAlbumFavorites
     
     case smartAlbumTimelapses
     
     case smartAlbumAllHidden
     
     case smartAlbumRecentlyAdded
     
     case smartAlbumBursts
     
     case smartAlbumSlomoVideos
     
     case smartAlbumUserLibrary
     */
    
    class var allCollections: [PHAssetCollection] {
        let allCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        var collections: [PHAssetCollection] = []
        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        let favoriteCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        let recentCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: nil)
        let genericCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumGeneric, options: nil)
        let panoramasCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumPanoramas, options: nil)

        assetCollections.enumerateObjects { (assetCollection, index, stop) in
            collections.append(assetCollection)
        }
        favoriteCollections.enumerateObjects { (assetCollection, index, stop) in
            collections.append(assetCollection)
        }
        recentCollections.enumerateObjects { (assetCollection, index, stop) in
            collections.append(assetCollection)
        }
        genericCollections.enumerateObjects { (assetCollection, index, stop) in
            collections.append(assetCollection)
        }
        panoramasCollections.enumerateObjects { (assetCollection, index, stop) in
            collections.append(assetCollection)
        }
        allCollections.enumerateObjects { (collection, index, stop) in
            guard let assetCollection = collection as? PHAssetCollection else { return }
            collections.append(assetCollection)
        }
        
        return collections
    }
    
    class func fetchAllAssets(InAssetCollection assetCollection: PHAssetCollection, completion: @escaping (([PHAsset]) -> Void)) {
        var assets = [PHAsset]()
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        let assetsFetchResults = PHAsset.fetchAssets(in: assetCollection, options: options)
        
        if (assetsFetchResults.count == 0) {
            completion(assets)
            return
        }
        
        assetsFetchResults.enumerateObjects { (asset, index, stop) in
            assets.append(asset)
            
            if index == (assetsFetchResults.count - 1) {
                completion(assets)
            }
        }
    }
}
