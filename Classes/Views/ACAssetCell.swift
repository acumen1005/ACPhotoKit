//
//  ACAssetCell.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/2/24.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit

protocol ACAssetCellDelegate: class {
    func assetCell(assetCell: ACAssetCell, didSelectItemAt indexPath: IndexPath, selected isSelected: Bool)
}

class ACAssetCell: UICollectionViewCell {
    
    let ACAssetCellErrorDomain = "ACAssetCellErrorDomain"
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: self.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var selectButton: UIButton = {
        let button = UIButton(frame: CGRect(x: self.bounds.width - 32, y: 0, width: 32, height: 32))
        button.setImage(UIImage(named: "icon_picker_unselect"), for: .normal)
        button.setImage(UIImage(named: "icon_picker_select"), for: .selected)
        button.setImage(UIImage(named: "icon_picker_select"), for: .highlighted)
        button.addTarget(self, action: #selector(pickPhoto), for: .touchUpInside)
        return button
    }()
    
    weak var delegate: ACAssetCellDelegate?
    var indexPath: IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.imageView)
        self.addSubview(self.selectButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func render(image: UIImage, selected isSelected: Bool, at indexPath: IndexPath) {
        self.imageView.image = image
        self.selectButton.isSelected = isSelected
        self.indexPath = indexPath
    }
    
    func pickPhoto(_ button: UIButton) {
        assert(self.indexPath != nil, "\(ACAssetCellErrorDomain): indexPath is nil")
        if let delegate = delegate {
            delegate.assetCell(assetCell: self, didSelectItemAt: self.indexPath!, selected: !button.isSelected)
        }
    }
}
