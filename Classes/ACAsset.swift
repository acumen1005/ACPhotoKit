//
//  ACAsset.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/2/24.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit
import Photos

class ACAsset: NSObject {
    
    fileprivate var asset: PHAsset?
    
    init(asset: PHAsset) {
        self.asset = asset
        super.init()
    }
    
    init(localIdentifier: String) {
        self.asset = ACAsset.fetchResult(withLocalIdentifier: localIdentifier).firstObject
        super.init()
    }
    
    class func fetchResult(withLocalIdentifier localIdentifier: String) -> PHFetchResult<PHAsset> {
        return PHAsset.fetchAssets(withBurstIdentifier: localIdentifier, options: nil)
    }
    
    class func requestImage(withAsset asset: PHAsset,
                            size: CGSize,
                            deliveryMode: PHImageRequestOptionsDeliveryMode,
                            sync: Bool,
                            completion: @escaping ((UIImage?, NSError?) -> Void)) {
        let requestOptions = PHImageRequestOptions()
        requestOptions.deliveryMode = deliveryMode
        requestOptions.isSynchronous = sync
        
        PHImageManager.default().requestImage(for: asset,
                                              targetSize: size,
                                              contentMode: .default,
                                              options: requestOptions) { (image, info) in
            completion(image, nil)
        }
    }
    
    func requestImage(size: CGSize,
                      deliveryMode: PHImageRequestOptionsDeliveryMode,
                      sync: Bool,
                      completion: @escaping ((UIImage?, NSError?) -> Void)) {
        guard let asset = self.asset else {
            let error = NSError(domain: "ACAsset", code: -1, userInfo: nil)
            completion(nil, error)
            return
        }
        
        ACAsset.requestImage(withAsset: asset,
                             size: size,
                             deliveryMode: deliveryMode,
                             sync: sync,
                             completion: completion)
    }
}
