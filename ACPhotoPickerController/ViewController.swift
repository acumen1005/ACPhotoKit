//
//  ViewController.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/2/24.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit

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
        let collectionsVC = ACAssetCollectionsViewController(nibName: nil, bundle: nil)
        let pickerVc = ACPhotoPickerController(nibName: nil, bundle: nil)
        let nav = UINavigationController(rootViewController: pickerVc)
        var vcs = nav.viewControllers
        vcs.insert(collectionsVC, at: 0)
        nav.setViewControllers(vcs, animated: true)
        self.navigationController?.present(nav, animated: true, completion: {
            
        })
    }
    
}

