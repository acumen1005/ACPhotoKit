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
        var frame = self.view.bounds
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: self.layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: Screen.tabBarHeight, right: 0)
        collectionView.scrollIndicatorInsets = collectionView.contentInset
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
    
    fileprivate lazy var photoPickerFooterView: ACPhotoPickerFooterView = {
        let footerViewHeight: CGFloat = 49 + 34
        let blurEffectView = UIBlurEffect(style: UIBlurEffectStyle.extraLight)
        let footerView = ACPhotoPickerFooterView(effect: blurEffectView)
        footerView.frame = CGRect(x: 0, y: Screen.height - footerViewHeight, width: Screen.width, height: footerViewHeight)
        return footerView
    }()
    
    lazy var animatedTransition: ACAnimatedTransition? = {
        return ACAnimatedTransition()
    }()
    
    fileprivate var selectedAssets = ACSelectedAssets(maxCount: 9)
    fileprivate var currentIndexPath: IndexPath?
    var assets: [PHAsset] = []
    var images: [UIImage] = []
    var assetCollection: PHAssetCollection
    
    var tmp = 0
    
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
        
        self.view.addSubview(self.collectionView)
        self.view.addSubview(self.photoPickerFooterView)
        
        self.photoPickerFooterView.doneClosure = { [weak self] in
            self?.dismiss(animated: true, completion: {
                
            })
        }
        
        ACPhotoLibrary.shared.requestAuthorization {
            ACAssetCollection.fetchAllAssets(InAssetCollection: self.assetCollection) { assets in
                DispatchQueue.main.async {
                    self.assets = assets
                    self.collectionView.reloadData()
                    let numberOfItems = max(self.collectionView.numberOfItems(inSection: 0) - 1, 0)
                    let indexPath = IndexPath(row: numberOfItems, section: 0)
                    if numberOfItems != 0 {
                        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: false)
                    }
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
        return self.collectionView.cellForItem(at: indexPath)
    }
}

extension ACPhotoPickerController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        let photoGalleryVc = ACPhotoGalleryViewController(assets: assets, current: indexPath)
        photoGalleryVc.delegate = self
        
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
        cell.delegate = self
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
                cell.render(image: image, selected: self.selectedAssets.contains(asset: ACAsset(asset: asset)), at: indexPath)
            }
        })
    }
}

extension ACPhotoPickerController: ACAssetCellDelegate {
    func assetCell(assetCell: ACAssetCell, didSelectItemAt indexPath: IndexPath, selected isSelected: Bool) {
        let asset = self.assets[indexPath.row]
        if !isSelected {
            if self.selectedAssets.remove(asset: ACAsset(asset: asset)) {
                assetCell.selectButton.isSelected = isSelected
            }
        } else {
            if self.selectedAssets.insert(asset: ACAsset(asset: asset)) {
                assetCell.selectButton.isSelected = isSelected
            } else {
                print("最多添加 \(self.selectedAssets.maxCount) 张图片")
            }
        }
    }
}

extension ACPhotoPickerController: ACPhotoGalleryDelegate {
    func photoGallery(photoGallery: ACPhotoGalleryViewController, didSelectItemAt indexPath: IndexPath) {
        self.currentIndexPath = indexPath
        self.collectionView.scrollToItem(at: indexPath, at: .centeredVertically, animated: false)
        self.collectionView.layoutIfNeeded()
    }
}
