//
//  ACPhotoPickerController.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/2/24.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit
import Photos

class ACPhotoPickerController: UIViewController {

    fileprivate struct Constants {
        static let numberOfCell = 4
    }
    
    fileprivate lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        let width = (Screen.width - layout.sectionInset.right - layout.sectionInset.left - layout.minimumInteritemSpacing * CGFloat(Constants.numberOfCell - 1)) / CGFloat(Constants.numberOfCell)
        layout.itemSize = CGSize(width: width, height: width)
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = self.view.backgroundColor
        ACAssetCell.registerClass(collectionView)
        return collectionView
    }()
    
    fileprivate lazy var cancelBarButtonItem: UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(closePicker), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }()
    
    fileprivate lazy var backBarButtonItem: UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        button.setTitle("返回", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(popPicker), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }()
    
    lazy var animatedTransition: ACAnimatedTransition? = {
        return ACAnimatedTransition()
    }()
    
    fileprivate var currentIndexPath: IndexPath?
    var assets: [PHAsset] = []
    var images: [UIImage] = []
    var assetCollection: PHAssetCollection
    
    
    init(assetCollection: PHAssetCollection) {
        self.assetCollection = assetCollection
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(collectionView)
        
        ACPhotoLibrary.shared.requestAuthorization {
            ACAssetCollection.fetchAllAssets(InAssetCollection: self.assetCollection) { assets in
                DispatchQueue.main.async {
                    self.assets = assets
                    self.collectionView.reloadData()
                    let numberOfItems = max(self.collectionView.numberOfItems(inSection: 0) - 1, 0)
                    let indexPath = IndexPath(row: numberOfItems, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.delegate = nil
        
        self.navigationItem.rightBarButtonItem = cancelBarButtonItem
    }
    
    @objc func closePicker() {
        self.dismiss(animated: true) {
            
        }
    }
    
    @objc func popPicker() {
        self.navigationController?.delegate = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    func cellForItemAtCurrentIndexPath() -> UICollectionViewCell? {
        guard let indexPath = currentIndexPath else {
            return nil
        }
        return collectionView.cellForItem(at: indexPath)
    }
}

extension ACPhotoPickerController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        let photoGalleryVc = ACPhotoGalleryViewController(asset: assets[indexPath.row])
        
        self.navigationController?.delegate = self.animatedTransition
        self.navigationController?.pushViewController(photoGalleryVc, animated: true)
    }
}

extension ACPhotoPickerController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ACAssetCell = collectionView.dequeueReusableCell(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ACAssetCell else { return }
        let asset = self.assets[indexPath.row]
        
        ACAsset.requestImage(withAsset: asset,
                             size: CGSize(width: cell.bounds.width * 1.5, height: cell.bounds.height * 1.5),
                             deliveryMode: .opportunistic,
                             sync: false,
                             completion: { (image, error) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                cell.render(image: image)
            }
        })
    }
}
