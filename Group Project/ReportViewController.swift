//
//  ReportViewController.swift
//  Group Project
//
//  Created by Justin Joerg on 4/11/17.
//  Copyright © 2017 Florida International University. All rights reserved.
//

import UIKit
import CoreData

class ReportViewController: UITableViewController, UINavigationControllerDelegate, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    var myReports = Model.sharedInstance
    var managedObjectContext: NSManagedObjectContext? = nil
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        navigationItem.leftBarButtonItem = editButtonItem()
    }
    
     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
     }
     
     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
     }
     
     override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
     let object = self.fetchedResultsController.objectAtIndexPath(indexPath) as! NSManagedObject
     self.configureCell(cell, withObject: object)
     return cell
     }
     
     func configureCell(cell: UITableViewCell, withObject object: NSManagedObject) {
        cell.textLabel!.text = object.valueForKey("report")!.description
        cell.detailTextLabel!.text = object.valueForKey("predicate")!.description
     }
    
    //FETCHED RESULTS CONTROLLER
   var fetchedResultsController: NSFetchedResultsController {
        let context = appDelegate.managedObjectContext
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Reports", inManagedObjectContext: context)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "report", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: "Reports")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            //print("Unresolved error \(error), \(error.userInfo)")
            //abort()
            print("ERROR")        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController: NSFetchedResultsController? = nil
    
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert:
            self.tableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete:
            self.tableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default:
            return
        }
    }
    
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            self.configureCell(tableView.cellForRowAtIndexPath(indexPath!)!, withObject: anObject as! NSManagedObject)
        case .Move:
            tableView.moveRowAtIndexPath(indexPath!, toIndexPath: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }
    
    //FETCHED RESULTS CONTROLLER END
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ShowDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = self.fetchedResultsController.objectAtIndexPath(indexPath)
                let controller = segue.destinationViewController as! DetailReportViewController
                controller.managedObjectContext = self.managedObjectContext
                controller.strPredicate = (object.valueForKey("predicate")?.description)!
                controller.strReport = (object.valueForKey("report")?.description)!
                
            }
            
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        //places the first contact into the text fields at start of app
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    
        tableView.rowHeight = UITableViewAutomaticDimension

       /* let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        let context = appDelegate!.managedObjectContext
        let newRecord = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: context)
        newRecord.setValue("002", forKey: "partNumber")
        newRecord.setValue("002-002", forKey: "serialNumber")
        newRecord.setValue("row 2", forKey: "location")
        newRecord.setValue(1, forKey: "quantity")
        
        do {
            try context.save()
            print("SAVED")
            
        } catch {
            print("ERROR")
        } */
        
     /*
        let context = appDelegate.managedObjectContext
       let manageRequest = NSFetchRequest(entityName: "Item")
        manageRequest.returnsObjectsAsFaults = false
        do {
            let results = try context.executeFetchRequest(manageRequest)
            
            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let partNum = result.valueForKey("partNumber") as? String {
                        print(partNum)
                    }
                    
                }
                
            } else {
                print("no results")
            }
            
        } catch {
            print("could not fetch")
        } */
        
        
       /*  let context = appDelegate.managedObjectContext
         let manageRequest = NSFetchRequest(entityName: "Reports")
         manageRequest.returnsObjectsAsFaults = false
         do {
         let results = try context.executeFetchRequest(manageRequest)
         
         if results.count > 0 {
         for result in results as! [NSManagedObject] {
         if let partNum = result.valueForKey("predicate") as? String {
         print(partNum)
         }
         
         }
         
         } else {
         print("no results")
         }
         
         } catch {
         print("could not fetch")
         } */
        
        /*let appDelegate = UIApplication.sharedApplication().delegate as? AppDelegate
        //let context = appDelegate?.managedObjectContext
        let managedContext = appDelegate!.persistentStoreCoordinator
        let newRecord = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: managedContext)
        //managedObjectContext?.setValue("002", forKey: "partNumber")
        //managedObjectContext?.setValue("002-000", forKey: "serialNumber")
        //managedObjectContext?.setValue("row 2", forKey: "location")
        //managedObjectContext?.setValue("1", forKey: "quantity")
        newRecord.setValue("000", forKey: "partNumber")
        newRecord.setValue("000-000", forKey: "serialNumber")
        newRecord.setValue("row 0", forKey: "location")
        newRecord.setValue(1, forKey: "quantity")
        
        
        do {
            //try managedObjectContext?.save()
            try managedContext.save()
            print("SAVED")
            
        } catch {
            print("ERROR")
        } */
        
       /* let manageRequest = NSFetchRequest(entityName: "Item")
        manageRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedObjectContext?.executeFetchRequest(manageRequest)
            
            if results?.count > 0 {
                for result in results as! [NSManagedObject] {
                    if let partNum = result.valueForKey("partNumber") as? String {
                        print(partNum)
                    }

                }
                
            } else {
                print("no results")
            }
            
        } catch {
            print("could not fetch")
        } */
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
