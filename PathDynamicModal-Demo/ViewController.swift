//
//  ViewController.swift
//  PathDynamicModal-Demo
//
//  Created by Ryo Aoyama on 2/9/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var titleAndImages: [(String, UIImage)]! = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    private func configure() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: UIFont.boldSystemFontOfSize(20.0), NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.tableView.registerNib(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: "imageCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.fillNavigationBar(color: UIColor(red: 252.0/255.0, green: 0, blue: 0, alpha: 1.0))
        
        for i in 1...16 {
            let imageName = "SampleImage\(i)"
            let image = UIImage(named: "\(imageName).jpg")!
            self.titleAndImages.append((imageName, image))
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
    
    @IBAction func helloButton(sender: UIButton) {
        let view = ModalView.instantiateFromNib()
        let window = UIApplication.sharedApplication().delegate?.window??
        let modal = PathDynamicModal()
        modal.showMagnitude = 200.0
        modal.closeMagnitude = 130.0
        view.closeButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        view.bottomButtonHandler = {[weak modal] in
            modal?.closeWithLeansRandom()
            return
        }
        modal.show(modalView: view, inView: window!)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let view = ImageModalView.instantiateFromNib()
        view.image = self.titleAndImages[indexPath.item].1
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titleAndImages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("imageCell", forIndexPath: indexPath) as ImageCell
        let titleAndImage = self.titleAndImages[indexPath.item]
        cell.title = titleAndImage.0
        cell.sideImage = titleAndImage.1
        return cell
    }
}