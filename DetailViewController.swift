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
    
    @IBOutlet var bottomToolbar: UIToolbar!
    @IBOutlet var memeImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        

        let editButton = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailViewController.edit))
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let deleteButton = UIBarButtonItem(title: "Delete", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DetailViewController.deleteButton))

        
        bottomToolbar.items?.append(editButton)
        bottomToolbar.items?.append(flexSpace)
        bottomToolbar.items?.append(deleteButton)
        
        guard let meme = meme else {
            let alertController = UIAlertController(title: "Meme not found", message: "That meme could not be found!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                _ = self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) {}
            return
        }
        
        memeImage.image = UIImage(data: meme.memeImage)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let meme = meme else {
            let alertController = UIAlertController(title: "Meme not found", message: "That meme could not be found!", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { action in
                _ = self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true) {}
            return
        }
        
        memeImage.image = UIImage(data: meme.memeImage)
    }
    
    //called when edit button pressed
    func edit() {
        performSegue(withIdentifier: "SegueEditMeme", sender: self)
    }
    
    //called when delete button pressed
    func deleteButton () {

        let deleteConfirm = UIAlertController(title: "Confirm Delete", message: "Are you sure you want to permanently delete this meme?", preferredStyle: UIAlertControllerStyle.actionSheet)
        deleteConfirm.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
            self.delete()
        }))
        deleteConfirm.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction!) in
        }))
        
        present(deleteConfirm, animated: true, completion: nil)
    }
    
    //deletes meme from meme array and then returns to previous view
    func delete() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.persistentContainer.viewContext.delete(meme!)
        appDelegate.saveContext()
        _ = navigationController?.popViewController(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueEditMeme" {
            let navController = segue.destination as! UINavigationController
            let destinationVC = navController.childViewControllers[0] as! EditMemeViewController
            destinationVC.EditMode = true
            destinationVC.meme = meme!
        }
    }
}
