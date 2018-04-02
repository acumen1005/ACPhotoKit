//
//  ViewController.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/2/24.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: [ACAsset] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let width = (Screen.width - 2 * 4 - 2 * 4) / 3
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumLineSpacing = 4
        layout.minimumInteritemSpacing = 4
        layout.itemSize = CGSize(width: width, height: width)
        
        collectionView.register(UINib(nibName: "\(PhtotoCell.className)", bundle: nil),
                                forCellWithReuseIdentifier: "\(PhtotoCell.className)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func openPhotoPicker(_ sender: Any) {
        let assetCollection = ACAssetCollection.allCollections.first!
        
        let collectionsVC = ACAssetCollectionsViewController(nibName: nil, bundle: nil)
        let pickerVc = ACPhotoPickerController(assetCollection: assetCollection)
        let nav = UINavigationController(rootViewController: pickerVc)
        var vcs = nav.viewControllers
        vcs.insert(collectionsVC, at: 0)
        nav.setViewControllers(vcs, animated: true)
        self.navigationController?.present(nav, animated: true, completion: {
            
        })
        
        pickerVc.doneAction = { assets in
            self.dataSource = assets
            self.collectionView.reloadData()
        }
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PhtotoCell = collectionView.dequeueReusableCell(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let asset = dataSource[indexPath.row]
        let width = (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize.width * 1.5
        let size = CGSize(width: width, height: width)
        asset.requestImage(size: size, deliveryMode: .highQualityFormat, sync: true) { (image, error) in
            if let image = image {
                (cell as! PhtotoCell).render(image: image)
            }
        }
    }
}

