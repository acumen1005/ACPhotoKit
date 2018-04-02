//
//  ACPhotoGalleryViewController.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/3/2.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit
import Photos

protocol ACPhotoGalleryDelegate: class {
    func photoGallery(photoGallery: ACPhotoGalleryViewController, didSelectItemAt indexPath: IndexPath)
}

class ACPhotoGalleryViewController: UIViewController {
    
    fileprivate lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets.zero
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: Screen.width, height: Screen.height)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: self.layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = self.view.backgroundColor
        collectionView.isPagingEnabled = true
        ACGalleryCell.registerClass(collectionView)
        return collectionView
    }()
    
    var assets: [ACAsset]
    var currentIndexPath: IndexPath
    
    var delegate: ACPhotoGalleryDelegate?

    init(assets: [PHAsset], current indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        self.assets = assets.map({ asset -> ACAsset in
            return ACAsset(asset: asset)
        })
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        if #available(iOS 11, *) {
            self.collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            self.automaticallyAdjustsScrollViewInsets = false
        }
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setup() {
        self.view.addSubview(self.collectionView)
        
        UICollectionViewCell.registerClass(self.collectionView)
        
        self.collectionView.scrollToItem(at: self.currentIndexPath, at: .centeredHorizontally, animated: false)
    }
}

extension ACPhotoGalleryViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = self.collectionView.indexPathsForVisibleItems.first, let delegate = delegate {
            delegate.photoGallery(photoGallery: self, didSelectItemAt: indexPath)
        }
    }
}

extension ACPhotoGalleryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension ACPhotoGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ACGalleryCell = collectionView.dequeueReusableCell(at: indexPath)
        cell.zoomImageView.zoomDelegate = self
        cell.render(asset: self.assets[indexPath.row], singleTapped: {
            guard let isHidden = self.navigationController?.isNavigationBarHidden else {
                return
            }
            self.navigationController?.setNavigationBarHidden(!isHidden, animated: true)
        })
        return cell
    }
}

extension ACPhotoGalleryViewController: ZoomImageViewDelegate {
    func zoomImageView(_ zoomImageView: ZoomImageView, didPopViewController isPop: Bool) {
        self.navigationController?.popViewController(animated: true)
    }
}
