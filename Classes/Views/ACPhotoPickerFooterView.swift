//
//  ACPhotoPickerFooterView.swift
//  ACPhotoPickerController
//
//  Created by 谷雷雷 on 2018/3/29.
//  Copyright © 2018年 acumen. All rights reserved.
//

import UIKit

class ACPhotoPickerFooterView: UIVisualEffectView {

    private lazy var topLine: UIView = {
        let line = UIView(frame: CGRect(x: 0, y: 0, width: Screen.width, height: 0.5))
        line.backgroundColor = UIColor.lightGray
        return line
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton(frame: CGRect(x: Screen.width - 60 - 8, y: 8, width: 60, height: 30))
        button.setTitle("完成", for: .normal)
        button.setTitleColor(UIColor.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(done), for: .touchUpInside)
        return button
    }()
    
    var doneClosure: (() -> Void)?
    
    override init(effect: UIVisualEffect?) {
        super.init(effect: effect)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        self.contentView.addSubview(self.topLine)
        self.contentView.addSubview(self.doneButton)
    }
    
    func done() {
        if let closure = doneClosure {
            closure()
        }
    }
}
