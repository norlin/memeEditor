//
//  TableViewController.swift
//  MemeEditor
//
//  Created by norlin on 27/08/15.
//  Copyright (c) 2015 norlin. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource {

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
        tableView.reloadData()
    }

    // TableView methods
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memesList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tableCell", forIndexPath: indexPath) as! TableCell
        
        let meme = memesList[indexPath.row]
        cell.memedImage.image = meme.memedImage
        cell.topText.text = meme.topText
        cell.bottomText.text = meme.bottomText
        
        return cell
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "showDetail"){
            let target = segue.destinationViewController as! DetailViewController
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPathForCell(cell) {
                    target.meme = memesList[indexPath.row]
                }
            }
        }
    }
}