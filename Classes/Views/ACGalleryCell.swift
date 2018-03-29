//
//  ACGalleryCell.swift
//  ACPhotoPickerController
//
//  Created by 谷雷雷 on 2018/3/28.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit

class ACGalleryCell: UICollectionViewCell {
    
    private var zoomImageViewIsBlack = false
    
    lazy var zoomImageView: ZoomImageView = {
        let width = Screen.width
        let zoomImageView = ZoomImageView(frame: CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height))
        return zoomImageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.addSubview(self.zoomImageView)
        
        if #available(iOS 11, *) {
            self.zoomImageView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    func render(asset: ACAsset, singleTapped: @escaping (() -> Void)) {
        self.zoomImageView.renderImageView(asset: asset)
        self.zoomImageView.imageViewSingleTapped = { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.zoomImageViewIsBlack = !strongSelf.zoomImageViewIsBlack
            self?.zoomImageView.backgroundColor = strongSelf.zoomImageViewIsBlack ? UIColor.black : UIColor.white
            singleTapped()
        }
        
    }
}
