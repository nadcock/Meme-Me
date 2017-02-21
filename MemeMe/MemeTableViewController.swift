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

        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell") as! TableViewCell
        let meme = memes[indexPath.row]

        cell.cellLabel.text = meme.top + "..." + meme.bottom
        cell.cellImage.image = meme.generateMeme()

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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMeme = indexPath.row
        performSegue(withIdentifier: "SegueSelectedMeme", sender: self)
    }
}
