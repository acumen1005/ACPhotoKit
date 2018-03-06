//
//  ACAnimatedTransition.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/3/2.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit

class ACAnimatedTransition: NSObject {

    var pushAnimator: ACAnimator?
    var popAnimator: ACAnimator?
    
    override init() {
        self.pushAnimator = ACAnimator(type: .push)
        self.popAnimator = ACAnimator(type: .pop)
    }
}

extension ACAnimatedTransition: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch operation {
        case .push: return self.pushAnimator
        case .pop: return self.popAnimator
        case .none: return nil
        }
    }
}
