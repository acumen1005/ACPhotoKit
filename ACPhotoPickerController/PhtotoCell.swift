//
//  PhtotoCell.swift
//  ACPhotoPickerController
//
//  Created by 谷雷雷 on 2018/4/2.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit

class PhtotoCell: UICollectionViewCell {
  
  @IBOutlet weak var photoImageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    
    photoImageView.contentMode = .scaleAspectFill
  }
  
  func render(image: UIImage) {
    self.photoImageView.image = image
  }
  
}
