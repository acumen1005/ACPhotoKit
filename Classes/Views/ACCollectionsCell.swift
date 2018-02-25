//
//  ACCollectionsCell.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/2/25.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit

class ACCollectionsCell: UITableViewCell {

    lazy var coverImageView: UIImageView = {
        let height = 60
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: height, height: height))
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.accessoryType = .disclosureIndicator
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.addSubview(self.coverImageView)
    }
    
    func render(collection: ACAssetCollection) {
        if let asset = collection.coverAsset {
            asset.requestImage(size: self.coverImageView.bounds.size, deliveryMode: .highQualityFormat, sync: true, completion: { (image, error) in
                self.coverImageView.image = image
            })
        }
    }
}
