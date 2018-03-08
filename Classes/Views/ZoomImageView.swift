//
//  ZoomImageView.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/3/8.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit
import Photos

final class ZoomImageView: UIScrollView {
    
    let DefaultMaximumZoomScale: CGFloat = 2.0
    
    var imageView: UIImageView = UIImageView(frame: CGRect.zero)
    var isMaximumZoomScale: Bool {
        return (self.maximumZoomScale - self.zoomScale) < CGFloat(0.001)
    }
    
    var imageViewSingleTapped: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initialize() {
        self.backgroundColor = UIColor.clear
        self.alwaysBounceVertical = true
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.maximumZoomScale = 2.0
        self.addSubview(imageView)
        self.delegate = self
        
        let singleTap = UITapGestureRecognizer()
        singleTap.numberOfTapsRequired = 1
        singleTap.addTarget(self, action: #selector(singleTapped))
        self.addGestureRecognizer(singleTap)
        let doubleTap = UITapGestureRecognizer()
        doubleTap.numberOfTapsRequired = 2
        doubleTap.addTarget(self, action: #selector(doubleTapped))
        self.addGestureRecognizer(doubleTap)
        singleTap.require(toFail: doubleTap)
    }
    
    func renderImageView(asset: ACAsset) {
        
        asset.requestImage(size: PHImageManagerMaximumSize, deliveryMode: .highQualityFormat, sync: false) { (image, error) in
            guard let size = image?.size else {
                return
            }
            self.imageView.image = image
            
            var scaleRadio: CGFloat = 2
            if size.width < size.height {
                scaleRadio = self.frame.width * size.height / (size.width * self.frame.height)
            } else {
                scaleRadio = self.frame.height * size.width / (self.frame.width * size.height)
            }
            self.maximumZoomScale = scaleRadio > self.DefaultMaximumZoomScale ? scaleRadio : self.DefaultMaximumZoomScale
            
            let newSize = ZoomImageView.resize(origin: size, width: Screen.width)
            self.imageView.frame = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            self.setImageViewCenter(scrollView: self)
        }
    }
    
    func zoomRect(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        
        zoomRect.size.height = frame.height / scale
        zoomRect.size.width = frame.width / scale
        
        zoomRect.origin.x = center.x - (zoomRect.size.width / CGFloat(2))
        zoomRect.origin.y = center.y - (zoomRect.size.height / CGFloat(2))
        
        return zoomRect
    }
    
    func singleTapped(_ tapGestureRecoginzer: UITapGestureRecognizer) {
        if let closure = imageViewSingleTapped {
            closure()
        }
    }
    
    func doubleTapped(_ tapGestureRecoginzer: UITapGestureRecognizer) {
        var point = tapGestureRecoginzer.location(in: tapGestureRecoginzer.view)
        point.x = self.imageView.frame.midX
        let rect = self.zoomRect(scale: isMaximumZoomScale ? 1 : self.maximumZoomScale, center: point)
        self.zoom(to: rect, animated: true)
    }
    
    func setImageViewCenter(scrollView: UIScrollView) {
        var centerX = scrollView.center.x
        var centerY = scrollView.center.y
        
        centerX = scrollView.contentSize.width > scrollView.frame.width ? scrollView.contentSize.width / 2.0 : centerX
        centerY = scrollView.contentSize.height > scrollView.frame.height ? scrollView.contentSize.height / 2.0 : centerY
        
        imageView.center = CGPoint(x: centerX, y: centerY)
    }
}

extension ZoomImageView {
    static func resize(origin size: CGSize, height: CGFloat) -> CGSize {
        var size = size
        if size.height == 0 || size.width == 0 {
            size = CGSize(width: 100, height: 100)
        }
        let scale = height / size.height
        let newWidth = size.width * scale
        return CGSize(width: newWidth, height: height)
    }
    
    static func resize(origin size: CGSize, width: CGFloat) -> CGSize {
        var size = size
        if size.height == 0 || size.width == 0 {
            size = CGSize(width: 100, height: 100)
        }
        let scale = width / size.width
        let newHeight = size.height * scale
        return CGSize(width: width, height: newHeight)
    }
    
    static func resize(origin size: CGSize) -> CGSize {
        let size = CGSize.zero
        if (size.width / size.height) > (Screen.width / Screen.height) {
            let screenWidth = Screen.width
            return CGSize(width: screenWidth, height: screenWidth * size.height / size.width)
        } else {
            let screenHeight = Screen.height
            return CGSize(width: Screen.width, height: screenHeight)
        }
    }
}

extension ZoomImageView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        self.setImageViewCenter(scrollView: scrollView)
    }
}

