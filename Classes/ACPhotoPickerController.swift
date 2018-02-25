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
    
    fileprivate lazy var collectionView: UICollectionView = {
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
    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(collectionView)
        
        ACPhotoLibrary.shared.requestAuthorization {
            let assetCollectionResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumMyPhotoStream, options: nil)
            let assetCollection = assetCollectionResult.firstObject!
            ACAssetCollection.fetchAllAssets(InAssetCollection: assetCollection) { assets in
                for asset in assets {
                    ACAsset.requestImage(withAsset: asset, size: self.layout.itemSize, deliveryMode: .highQualityFormat, sync: true, completion: { (image, error) in
                        guard let image = image else {
                            return
                        }
                        self.images.append(image)
                    })
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    let lastItem = self.collectionView(self.collectionView, numberOfItemsInSection: 0) - 1
                    let indexPath = IndexPath(row: lastItem, section: 0)
                    self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationItem.rightBarButtonItem = cancelBarButtonItem
    }
    
    @objc func closePicker() {
        self.dismiss(animated: true) {
            
        }
    }
    
    @objc func popPicker() {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ACPhotoPickerController: UICollectionViewDelegate {
    
}

extension ACPhotoPickerController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ACAssetCell = collectionView.dequeueReusableCell(at: indexPath)
        let image = images[indexPath.row]
        cell.render(image: image)
        return cell
    }
}
