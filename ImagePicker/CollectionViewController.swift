//
//  CollectionViewController.swift
//  MemeEditor
//
//  Created by norlin on 27/08/15.
//  Copyright (c) 2015 norlin. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var memesList: [Meme]!
    
    func getMemes() -> [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memesList
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        memesList = getMemes()
        collectionView?.reloadData()
    }
    
    // CollectionView methods
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memesList.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as! CollectionCell
        
        let meme = memesList[indexPath.row]
        cell.memedImage.image = meme.memedImage
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetail"){
            let target = segue.destinationViewController as! DetailViewController
            if let cell = sender as? UICollectionViewCell {
                if let indexPath = collectionView?.indexPathForCell(cell) {
                    target.meme = memesList[indexPath.row]
                }
            }
        }
    }

}