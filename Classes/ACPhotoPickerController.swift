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
    
    var images: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        self.view.addSubview(collectionView)
        
        PHPhotoLibrary.requestAuthorization { status in
            print("status = \(status)")
            switch status {
            case .authorized:
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
                    }
                }
            case .denied: break
            case .restricted: break
            case .notDetermined: break
            }
        }
        

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
