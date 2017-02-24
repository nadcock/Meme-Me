//
//  TableViewController.swift
//  Image Picker
//
//  Created by Nick Adcock on 7/20/15.
//  Copyright (c) 2015 Nick. All rights reserved.
//

import UIKit
import CoreData

class MemeTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Meme")
        let sortDescriptor = NSSortDescriptor(key: "dateCreated", ascending: false)
        request.sortDescriptors = [sortDescriptor]
        
        
        let frc = NSFetchedResultsController(fetchRequest: request,
                                             managedObjectContext: self.context,
                                             sectionNameKeyPath: nil,
                                             cacheName: nil)
        
        frc.delegate = self
        
        do {
            try frc.performFetch()
        } catch {
            fatalError("Failed to initialize FetchedResultsController: \(error)")
        }
        
        return frc
    }()
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if let sections = fetchedResultsController.sections {
            let currentSection = sections[section]
            if currentSection.numberOfObjects > 0 {
                self.tableView.backgroundView = nil
                return currentSection.numberOfObjects
            } else {
                let notificationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
                notificationLabel.textAlignment = .center
                notificationLabel.textColor = UIColor.lightGray
                notificationLabel.text = "Select \"+\" above to create a Meme"
                self.tableView.backgroundView = notificationLabel
                self.tableView.separatorStyle = .none
            }
        }
        
        return 0

    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemeCell", for: indexPath) as! TableViewCell
        let meme = fetchedResultsController.object(at: indexPath) as! Meme
        
        cell.cellLabel.text = meme.topString! + "..." + meme.bottomString!
        cell.cellImage.image = UIImage(data: meme.memeImage)
        
        return cell
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case NSFetchedResultsChangeType(rawValue: 0)!:
            break
        case NSFetchedResultsChangeType.update:
            let cell = tableView.cellForRow(at: indexPath!) as! TableViewCell
            let meme = fetchedResultsController.object(at: indexPath!) as! Meme
            cell.cellLabel.text = meme.topString! + "..." + meme.bottomString!
            cell.cellImage.image = UIImage(data: meme.memeImage)
            break
        case NSFetchedResultsChangeType.insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break
        case NSFetchedResultsChangeType.delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            break
        case NSFetchedResultsChangeType.move:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            break

        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueSelectedMeme" {
            let destinationVC = segue.destination as! DetailViewController
            destinationVC.meme = fetchedResultsController.object(at: tableView.indexPathForSelectedRow!) as? Meme
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
        performSegue(withIdentifier: "SegueSelectedMeme", sender: self)
    }
}
