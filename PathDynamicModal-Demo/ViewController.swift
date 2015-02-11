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
        self.fillNavigationBar(color: UIColor(red: 252.0/255.0, green: 0, blue: 0, alpha: 1.0))
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let view = ModalView.instantiateFromNib()
        let window = UIApplication.sharedApplication().delegate?.window??
        let modal = PathDynamicModal.show(modalView: view, inView: window!)
        view.closeButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        view.bottomButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
    }
    
    private func fillNavigationBar(#color: UIColor) {
        if let nav = self.navigationController {
            nav.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
            nav.navigationBar.shadowImage = UIImage()
            for view in nav.navigationBar.subviews {
                if view.isKindOfClass(NSClassFromString("_UINavigationBarBackground")) {
                    if view.isKindOfClass(UIView) {
                        (view as UIView).backgroundColor = color
                    }
                }
            }
        }
    }
}

