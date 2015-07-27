//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Nick on 7/23/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var meme: Meme?
    var memeIndex: Int?
    
    @IBOutlet var bottomToolbar: UIToolbar!
    @IBOutlet var memeImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "edit")
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        var deleteButton = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.Plain, target: self, action: "deleteButton")
        
        bottomToolbar.items?.append(editButton)
        bottomToolbar.items?.append(flexSpace)
        bottomToolbar.items?.append(deleteButton)
        
        memeImage.image = meme?.generateMeme()

        // Do any additional setup after loading the view.
    }
    
    //called when edit button pressed
    func edit() {
        performSegueWithIdentifier("SegueEditMeme", sender: self)
    }
    
    //called when delete button pressed
    func deleteButton () {
        var deleteConfirm = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to permanently delete this meme?", preferredStyle: UIAlertControllerStyle.ActionSheet)
        deleteConfirm.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
            self.delete()
        }))
        deleteConfirm.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (action: UIAlertAction!) in
        }))
        
        presentViewController(deleteConfirm, animated: true, completion: nil)
    }
    
    //deletes meme from meme array and then returns to previous view
    func delete() {
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.removeAtIndex(memeIndex!)
        navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SegueEditMeme" {
            let navController = segue.destinationViewController as! UINavigationController
            let destinationVC = navController.childViewControllers[0] as! EditMemeViewController
            destinationVC.EditMode = true
            destinationVC.memeIndex = memeIndex
        }
    }
}
