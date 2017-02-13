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
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    // Local vars
    var fetchedController: NSFetchedResultsController<Gift>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let navBar = self.navigationController?.navigationBar {
            let color = UIColor(colorLiteralRed: 63/255, green: 25/255, blue: 1/255, alpha: 1)
            navBar.titleTextAttributes = [NSForegroundColorAttributeName: color]
        }
        
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        }
        
        // Running testData func
        //testData()
        // attempt to fetch
        tryToFetch()
    }
    
    // Attempt to fetch
    func tryToFetch() {
        // Request
        let fetchRequest: NSFetchRequest<Gift> = Gift.fetchRequest()
        // sortDescriptors
        var sortDescriptor: NSSortDescriptor!
        
        // switch in segments
        let index = segmentControl.selectedSegmentIndex
        
        switch index {
        case 0:
            sortDescriptor = NSSortDescriptor(key: "created", ascending: false)
            
        case 1:
            sortDescriptor = NSSortDescriptor(key: "price", ascending: false)
            
        case 2:
            sortDescriptor = NSSortDescriptor(key: "importance", ascending: false)
            
        default:
            break
        }
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Associate the controller
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest,
            managedObjectContext: context,sectionNameKeyPath: nil, cacheName: nil)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gift = fetchedController.object(at: indexPath)
        
        performSegue(withIdentifier: "GiftEditVC", sender: gift)
    }
    
    
    
    
    
    // Get the Item  and config the cell
    func configCell(cell: GiftCell, indexPath: NSIndexPath) {
        // We already did the fetch so will get the item
        let gift = fetchedController.object(at: indexPath as IndexPath) as Gift
        
        // Update cell information
        cell.updateCell(gift: gift)
    }
    
    // Function to prepare Segue to edit gift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GiftEditVC" {
            if let destination = segue.destination as? GiftDetailsVC {
                let gift = sender as? Gift
                destination.gift = gift
            }
        }
    }
    
    /* 
    Actions
    */
    @IBAction func segmentTapped(_ sender: Any) {
        
        // fetch
        tryToFetch()
        tableView.reloadData()
    }
    
    
    // Function to test data
    func testData() {
        
        let gift1 = Gift(context: context)
        gift1.title = "Mala Guess"
        gift1.price = 150
        gift1.details = "Preciso uma de cor azul"
        gift1.importance = 5
        gift1.sentSMS = false
        
        let gift2 = Gift(context: context)
        gift2.title = "iMac 27\""
        gift2.price = 2400
        gift2.details = "O meu desktop favorito. fica a matar na minha secretária"
        gift2.importance = 3
        gift2.sentSMS = true
        
        
        let gift3 = Gift(context: context)
        gift3.title = "Nike Running Pink"
        gift3.price = 100
        gift3.details = "Preciso de uns novos porque não gosto dos que o meu namorado me ofereceu"
        gift1.importance = 9
        gift1.sentSMS = true
        
        ad.saveContext()
    }
    
}

