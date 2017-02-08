//
//  MainVC.swift
//  Mirela's Wishes
//
//  Created by Luis  Costa on 07/02/17.
//  Copyright © 2017 Luis  Costa. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    // Local vars
    var fetchedController: NSFetchedResultsController<Gift>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tryToFetch()
    }
    
    // Attempt to fetch
    func tryToFetch() {
        // Request
        let fetchRequest: NSFetchRequest<Gift> = Gift.fetchRequest()
        // sortDescriptors
        let titleDescriptor = NSSortDescriptor(key: "title", ascending: false)
        // TODO: 1.1The rest of sort descriptors
        
        fetchRequest.sortDescriptors = [titleDescriptor]
        
        // Associate the controller
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context,
                                                    sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        self.fetchedController = controller
        
        // perform fetch
        do {
            try self.fetchedController.performFetch()
        } catch {
            // Handle the error
            let error = error as NSError
            print(error.debugDescription)
        }
    }
    
    
    
    /*
    Controller Functions
    */
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        
        case .delete:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .fade)
            }
        
        case .insert:
            if let index = newIndexPath {
                tableView.insertRows(at: [index], with: .fade)
            }
            
        case .move:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .fade)
            }
            
            if let index = newIndexPath {
                tableView.insertRows(at: [index], with: .fade)
            }
            
        case .update:
            // Need to define cellForRowUpdate
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! GiftCell
                configCell(cell: cell, indexPath: indexPath as NSIndexPath)
            }
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        // Notifies tableview
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    /*
    UITableViewDataSource Protocols
    */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var result = 0
        
        if let sectionsInfo = fetchedController.sections {
            result = sectionsInfo[section].numberOfObjects
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GiftCell", for: indexPath) as! GiftCell
        // pass to Configure cell
        configCell(cell: cell, indexPath: indexPath as NSIndexPath)
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var result = 0
        
        if let sectionsInfo = fetchedController.sections {
            result = sectionsInfo.count
        }
        return result
    }
    
    
    // Get the Item  and config the cell
    func configCell(cell: GiftCell, indexPath: NSIndexPath) {
        // We already did the fetch so will get the item
        let gift = fetchedController.object(at: indexPath as IndexPath) as Gift
        
        // Update cell information
        cell.updateCell(gift: gift)
    }
    
}

