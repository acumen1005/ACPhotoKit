//
//  Animator.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/3/6.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit

class ACAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    enum TransitionType {
        case push
        case pop
    }
    
    var type: TransitionType
    
    init(type: TransitionType) {
        self.type = type
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        switch type {
        case .push: pushAnimateTransition(transitionContext)
        case .pop: popAnimateTransition(transitionContext)
        }
    }
    
    
    
    func resize(imageSize: CGSize) -> CGSize {
        if imageSize.width <= 0 || imageSize.height <= 0 {
            return CGSize.zero
        }
        let scale = Screen.width / imageSize.width
        return CGSize(width: Screen.width, height: imageSize.height * scale)
    }
    
    func pushAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let fromVc = transitionContext.viewController(forKey: .from) as? ACPhotoPickerController,
            let toVc = transitionContext.viewController(forKey: .to) as? ACPhotoGalleryViewController,
            let cell = fromVc.cellForItemAtCurrentIndexPath() as? ACAssetCell else {
                return
        }
        // 转场过渡容器 view
        let containerView = transitionContext.containerView
        
        // fromVC
        containerView.addSubview(fromVc.view)
        
        // toVC
        containerView.addSubview(toVc.view)
        toVc.view.isHidden = true
        
        let bgView = UIView(frame: containerView.bounds)
        bgView.backgroundColor = UIColor.white
        bgView.alpha = 1
        containerView.addSubview(bgView)
        
        let transitionImageView = UIImageView(image: cell.imageView.image)
        transitionImageView.frame = cell.imageView.convert(cell.imageView.bounds, to: containerView)
        containerView.addSubview(transitionImageView)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.55, initialSpringVelocity: 1.0 / 0.55, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            let imageSize = self.resize(imageSize: cell.imageView.image?.size ?? CGSize.zero)
            transitionImageView.frame = CGRect(x: 0, y: (Screen.height - imageSize.height) * 0.5, width: imageSize.width, height: imageSize.height)
            
        }, completion: { finish in
            
            toVc.view.isHidden = false
            
            bgView.removeFromSuperview()
            transitionImageView.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
        })
    }
    
    func popAnimateTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        guard
            let toVc = transitionContext.viewController(forKey: .to) as? ACPhotoPickerController,
            let cell = toVc.cellForItemAtCurrentIndexPath() as? ACAssetCell else {
                return
        }
        
        // 转场过渡容器 view
        let containerView = transitionContext.containerView
        
        // toVC
        containerView.addSubview(toVc.view)
        
        let bgView = UIView(frame: containerView.bounds)
        bgView.backgroundColor = UIColor.white
        bgView.alpha = 1
        containerView.addSubview(bgView)
        
        let imageSize = self.resize(imageSize: cell.imageView.image?.size ?? CGSize.zero)
        let transitionImageView = UIImageView(image: cell.imageView.image)
        transitionImageView.contentMode = cell.imageView.contentMode
        transitionImageView.clipsToBounds = true
        transitionImageView.frame = CGRect(x: 0, y: (Screen.height - imageSize.height) * 0.5, width: imageSize.width, height: imageSize.height)
        containerView.addSubview(transitionImageView)
        
        let offsetY = toVc.collectionView.contentOffset.y + 64
        
        UIView.animate(withDuration: 0.3, animations: {
            
            var frame = cell.frame
            frame.origin.y = frame.origin.y + 64 - offsetY
            transitionImageView.frame = frame
            bgView.alpha = 0
            
        }, completion: { finish in
            
            bgView.removeFromSuperview()
            transitionImageView.removeFromSuperview()
            
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
    
}
