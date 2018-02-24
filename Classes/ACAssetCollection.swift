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

    var assetCollection: PHAssetCollection!
    
    var allCollections: [PHAssetCollection] {
        var collections: [PHAssetCollection] = []
        let assetCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        let favoriteCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumFavorites, options: nil)
        let recentCollections = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumRecentlyAdded, options: nil)
        
        assetCollections.enumerateObjects { (assetCollection, index, stop) in
            collections.append(assetCollection)
        }
        favoriteCollections.enumerateObjects { (assetCollection, index, stop) in
            collections.append(assetCollection)
        }
        recentCollections.enumerateObjects { (assetCollection, index, stop) in
            collections.append(assetCollection)
        }
        
        return collections
    }
    
    class func fetchAllAssets(InAssetCollection assetCollection: PHAssetCollection, completion: @escaping (([PHAsset]) -> Void)) {
        var assets = [PHAsset]()
        let options = PHFetchOptions()
        options.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
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
