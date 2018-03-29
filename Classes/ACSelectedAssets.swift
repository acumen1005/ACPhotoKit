//
//  ACSelected.swift
//  ACPhotoPickerController
//
//  Created by 谷雷雷 on 2018/3/29.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit

final class ACSelectedAssets {
    
    private(set) var maxCount: Int
    private var container: [ACAsset] = []
    
    init(maxCount: Int) {
        self.maxCount = maxCount
    }
    
    @discardableResult
    func insert(asset: ACAsset) -> Bool {
        if container.count >= maxCount {
            return false
        }
        if container.contains(asset) {
            return false
        }
        container.insert(asset, at: 0)
        return true
    }
    
    @discardableResult
    func remove(asset: ACAsset) -> Bool {
        guard let index = container.index(of: asset) else {
            return false
        }
        container.remove(at: index)
        return true
    }
    
    @discardableResult
    func contains(asset: ACAsset) -> Bool {
        return container.contains(asset)
    }
}
