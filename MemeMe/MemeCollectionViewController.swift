//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Nick Adcock on 7/21/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class MemeCollectionViewController: UICollectionViewController {

    var memes: [Meme]!
    var selectedMeme: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Register cell classes
        collectionView!.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return memes.count
    }
    
    override func viewDidAppear(animated: Bool) {
        let object = UIApplication.sharedApplication().delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        
        cell.backgroundImage.image = meme.generateMeme()
    
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        selectedMeme = indexPath.row
        performSegueWithIdentifier("SegueSelectedMeme", sender: self)
    }
}
