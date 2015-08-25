//
//  MemeClass.swift
//  ImagePicker
//
//  Created by norlin on 19/08/15.
//  Copyright (c) 2015 norlin. All rights reserved.
//

import Foundation
import UIKit
class Meme {
    var topText: String
    var bottomText: String
    var image: UIImage
    var memedImage: UIImage!
    var view: UIView
    
    init (top: String, bottom: String, image: UIImage, view: UIView) {
        self.topText = top
        self.bottomText = bottom
        self.image = image
        self.view = view
        self.memedImage = self.processImage()
    }
    
    private func processImage() -> UIImage {
        // make a screenshot;
        // BTW, is it really a good way to combine text + image???
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()       

        return memedImage
    }
}