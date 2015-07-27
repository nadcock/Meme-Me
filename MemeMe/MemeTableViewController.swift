//
//  TableViewController.swift
//  Image Picker
//
//  Created by Nick Adcock on 7/20/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]!
    var selectedMeme: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewDidAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return memes.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell") as! TableViewCell
        let meme = memes[indexPath.row]

        cell.cellLabel.text = meme.top + "..." + meme.bottom
        cell.cellImage.image = meme.generateMeme()

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SegueSelectedMeme" {
            let destinationVC = segue.destinationViewController as! DetailViewController
            destinationVC.meme = memes[selectedMeme]
            destinationVC.memeIndex = selectedMeme
        } else if segue.identifier == "SegueAddMeme" {
            let navController = segue.destinationViewController as! UINavigationController
            let destinationVC = navController.childViewControllers[0] as! EditMemeViewController
            destinationVC.EditMode = false
        }
    }
    

    @IBAction func AddMeme(sender: UIBarButtonItem) {
        performSegueWithIdentifier("SegueAddMeme", sender: self)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedMeme = indexPath.row
        performSegueWithIdentifier("SegueSelectedMeme", sender: self)
    }
}
