//
//  ACInteractiveAnimatedTransition.swift
//  ACPhotoPickerController
//
//  Created by 谷雷雷 on 2018/4/2.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit

class ACInteractiveAnimatedTransition: NSObject {
    
    var popAnimator: ACInteractiveAnimator?
    
    
    override init() {
        self.popAnimator = ACInteractiveAnimator(type: .pop)
    }
}
