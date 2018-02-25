//
//  ACPhotoLibrary.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/2/25.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit
import Photos

class ACPhotoLibrary: NSObject {
    
    static let shared = ACPhotoLibrary()
    
    func requestAuthorization(authorized closure: @escaping (() -> Void)) {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                closure()
            case .denied, .restricted:
                self.showDenidMessage()
            case .notDetermined:
                print("notDetermined")
                break
            }
        }
    }
    
    private func showDenidMessage() {
        UIAlertController.show(title: "提示",
                               message: "请到手机系统的设置>隐私>照片中允许xx访问",
                               confirmTitle: "好的",
                               cancelTitle: "算了",
                               confirm: { action in
                                
        }, cancel: { action in
            
        })
    }
}

