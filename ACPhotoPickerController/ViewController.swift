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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    }
    
}

