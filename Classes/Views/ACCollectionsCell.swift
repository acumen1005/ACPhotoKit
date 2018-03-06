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
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14)
        return label
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
        self.addSubview(self.titleLabel)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: self.titleLabel, attribute: .left, relatedBy: .equal, toItem: self.coverImageView, attribute: .right, multiplier: 1.0, constant: 16))
    }
    
    func render(collection: ACAssetCollection) {
        if let asset = collection.coverAsset {
            asset.requestImage(size: self.coverImageView.bounds.size, deliveryMode: .highQualityFormat, sync: true, completion: { (image, error) in
                self.coverImageView.image = image
            })
        }
        self.titleLabel.text = (collection.title ?? "") + "(\(collection.assetsCount))"
    }
}
