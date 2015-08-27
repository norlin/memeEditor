//
//  DetailViewController.swift
//  MemeEditor
//
//  Created by norlin on 27/08/15.
//  Copyright (c) 2015 norlin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var memedImage: UIImageView!
    
    var meme: Meme?
    override func viewWillAppear(animated: Bool) {
        if let image = meme?.memedImage {
            memedImage.image = image
            let sharing = UIActivityViewController(activityItems: [image], applicationActivities: nil)
            presentViewController(sharing, animated: true, completion: nil)
        }
    }

}
