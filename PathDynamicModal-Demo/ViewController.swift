//
//  ViewController.swift
//  PathDynamicModal-Demo
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
        let view = UIView(frame: CGRectMake(0, 0, 240.0, 320.0))
        view.backgroundColor = UIColor.redColor()
        view.layer.cornerRadius = 5.0
        let window = UIApplication.sharedApplication().delegate?.window??
        PathDynamicModal.show(contentView: view, inView: window!)
    }
}

