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

    lazy var imageView: UIImageView = {
        let width = Screen.width
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: Screen.width, height: Screen.height))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
//    fileprivate lazy var backBarButtonItem: UIBarButtonItem = {
//        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
//        button.setTitle("返回", for: .normal)
//        button.setTitleColor(UIColor.blue, for: .normal)
//        button.addTarget(self, action: #selector(popPicker), for: .touchUpInside)
//        let barButtonItem = UIBarButtonItem(customView: button)
//        return barButtonItem
//    }()
    
    var asset: ACAsset
    
    init(asset: PHAsset) {
        self.asset = ACAsset(asset: asset)
        
        super.init(nibName: nil, bundle: nil)
        
        DispatchQueue.global().async {
            self.asset.requestImage(size: PHImageManagerMaximumSize, deliveryMode: .highQualityFormat, sync: true) { [weak self] (image, error) in
                guard let `self` = self else { return }
                
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
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
        self.view.addSubview(self.imageView)
    }
}
