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

extension UITableViewCell {
    class func registerClass(_ tableView: UITableView) {
        tableView.register(self.classForCoder(), forCellReuseIdentifier: self.className)
    }
}

extension UICollectionViewCell {
    class func registerClass(_ collectionView: UICollectionView) {
        collectionView.register(self.classForCoder(), forCellWithReuseIdentifier: self.className)
    }
}

extension UITableView {
    
    func dequeueReusableCell<T>() -> T {
        return self.dequeueReusableCell(withIdentifier: "\(T.self)") as! T
    }
}

extension UICollectionView {
    
    func dequeueReusableCell<T>(at indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withReuseIdentifier: "\(T.self)", for: indexPath) as! T
    }
}

extension UIAlertController {
    
    static func show(title: String,
                     message: String,
                     confirmTitle: String,
                     cancelTitle: String,
                     confirm: @escaping ((UIAlertAction) -> Void),
                     cancel: @escaping ((UIAlertAction) -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default, handler: confirm)
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: cancel)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
}
