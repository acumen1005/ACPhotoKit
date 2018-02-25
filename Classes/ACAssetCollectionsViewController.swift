//
//  ACAssetCollectionsViewController.swift
//  ACPhotoPickerController
//
//  Created by acumen on 2018/2/25.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit

class ACAssetCollectionsViewController: UIViewController {

    fileprivate lazy var tableView: UITableView = {
        let tableView = UITableView(frame: self.view.bounds)
        tableView.rowHeight = 60
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    fileprivate lazy var cancelBarButtonItem: UIBarButtonItem = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.addTarget(self, action: #selector(closePicker), for: .touchUpInside)
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }()
    
    var collections = [ACAssetCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        ACCollectionsCell.registerClass(tableView)
        
        collections = ACAssetCollection.allCollections.map { assetCollection -> ACAssetCollection in
            return ACAssetCollection(collection: assetCollection)
        }
        print(collections)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.view.addSubview(tableView)
        
        self.navigationItem.rightBarButtonItem = cancelBarButtonItem
    }
    
    @objc func closePicker() {
        self.dismiss(animated: true) {
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ACAssetCollectionsViewController: UITableViewDelegate {
    
}

extension ACAssetCollectionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: ACCollectionsCell = tableView.dequeueReusableCell()
        cell.render(collection: collections[indexPath.row])
        return cell
    }
}
