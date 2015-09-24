//
//  ImageModalView.swift
//  PathDynamicModal-Demo
//
//  Created by Ryo Aoyama on 2/12/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

class ImageModalView: UIView {
    var bottomButtonHandler: (() -> Void)?
    var closeButtonHandler: (() -> Void)?
    var image: UIImage? {
        set {
            self.imageView.image = newValue
        }
        get {
            return self.imageView.image
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var closeButton: UIButton!
    @IBOutlet private var contentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configure()
    }
    
    private func configure() {
        self.contentView.layer.cornerRadius = 5.0
        self.closeButton.layer.cornerRadius = CGRectGetHeight(self.closeButton.bounds) / 2.0
        self.closeButton.layer.shadowColor = UIColor.blackColor().CGColor
        self.closeButton.layer.shadowOffset = CGSizeZero
        self.closeButton.layer.shadowOpacity = 0.3
        self.closeButton.layer.shadowRadius = 2.0
    }
    
    class func instantiateFromNib() -> ImageModalView {
        let view = UINib(nibName: "ImageModalView", bundle: nil).instantiateWithOwner(nil, options: nil).first as! ImageModalView
        
        return view
    }
    
    @IBAction func handleCloseButton(sender: UIButton) {
        self.closeButtonHandler?()
    }
    
    @IBAction func handleBottomButton(sender: UIButton) {
        self.bottomButtonHandler?()
    }
}