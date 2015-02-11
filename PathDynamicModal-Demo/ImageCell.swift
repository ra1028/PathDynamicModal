//
//  ImageCell.swift
//  PathDynamicModal-Demo
//
//  Created by Ryo Aoyama on 2/12/15.
//  Copyright (c) 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

class ImageCell: UITableViewCell {
    @IBOutlet private var sideImageView: UIImageView!
    @IBOutlet private var titleLabel: UILabel!
    
    var sideImage: UIImage? {
        set {
            self.sideImageView.image = newValue
        }
        get {
            return self.sideImageView.image
        }
    }
    
    var title: String? {
        set {
            self.titleLabel.text = newValue
        }
        get {
            return self.titleLabel.text
        }
    }
}