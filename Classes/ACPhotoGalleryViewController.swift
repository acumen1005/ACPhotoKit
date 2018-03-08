//
//  ACPhotoGalleryViewController.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/3/2.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit
import Photos

class ACPhotoGalleryViewController: UIViewController {
    
    lazy var zoomImageView: ZoomImageView = {
        let width = Screen.width
        let zoomImageView = ZoomImageView(frame: CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height))
        return zoomImageView
    }()
    
    var asset: ACAsset
    
    init(asset: PHAsset) {
        self.asset = ACAsset(asset: asset)
        
        super.init(nibName: nil, bundle: nil)
        
        zoomImageView.renderImageView(asset: self.asset)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setup() {
        if #available(iOS 11.0, *) {
            self.zoomImageView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        self.view.addSubview(self.zoomImageView)
        
        self.zoomImageView.imageViewSingleTapped = { [weak self] in
            guard
                let strongSelf = self,
                let isHidden = strongSelf.navigationController?.isNavigationBarHidden else {
                    return
            }
            strongSelf.zoomImageView.backgroundColor = !isHidden ? UIColor.black : UIColor.white
            strongSelf.navigationController?.setNavigationBarHidden(!isHidden, animated: true)
        }
    }
}
