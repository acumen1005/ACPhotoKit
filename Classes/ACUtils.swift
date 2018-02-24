//
//  ACUtils.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/2/24.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit

extension UIView {
    
    class var className: String {
        return "\(self.classForCoder())"
    }
    
}

extension UICollectionViewCell {
    class func registerClass(_ collectionView: UICollectionView) {
        collectionView.register(self.classForCoder(), forCellWithReuseIdentifier: self.className)
    }
}

extension UICollectionView {
    
    func dequeueReusableCell<T>(at indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath) as! T
    }
}
