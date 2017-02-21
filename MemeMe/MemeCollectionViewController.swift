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
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return memes.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        collectionView?.reloadData()
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MemeCell", for: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        
        cell.backgroundImage.image = meme.generateMeme()
    
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueSelectedMeme" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.meme = memes[selectedMeme]
            destinationVC.memeIndex = selectedMeme
        } else if segue.identifier == "SegueAddMeme" {
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.childViewControllers[0] as! EditMemeViewController
            destinationVC.EditMode = false
        }
    }
    
    @IBAction func AddMeme(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "SegueAddMeme", sender: self)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedMeme = indexPath.row
        performSegue(withIdentifier: "SegueSelectedMeme", sender: self)
    }
}
