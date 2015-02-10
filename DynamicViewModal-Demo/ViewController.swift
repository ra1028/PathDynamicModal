//
//  ViewController.swift
//  DynamicViewModal-Demo
//
//  Created by Ryo Aoyama on 2/9/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let view = UIView(frame: CGRectMake(0, 0, 230.0, 260.0))
        view.backgroundColor = UIColor.redColor()
        let window = UIApplication.sharedApplication().delegate?.window??
        DynamicViewModal.show(contentView: view, inView: window!)
    }
}

