//
//  Model.swift
//  Group Project
//
//  Created by Justin Joerg on 4/11/17.
//  Copyright © 2017 Florida International University. All rights reserved.
//

import UIKit
import CoreData

struct Item{
    var location: String
    var partNumber: String
    var qty: Int
    var serialNumber: String
}

final class Model {
    static let sharedInstance = Model()
    
    var reports = ["Master", "Report"]
    var items = ""
    var itemList: [NSManagedObject] = []
    var reportList: [NSManagedObject] = []
    
    private init(){
        
    }
    
    func save(partNum: String, serialNum: String, location: String, qty: Int) -> Bool {
    
        guard let appDelegate =
            UIApplication.sharedApplication().delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext = appDelegate.managedObjectContext
        // 2
        let entity =
            NSEntityDescription.entityForName("Item", inManagedObjectContext: managedContext)!
        
        let item = NSManagedObject(entity: entity,
                                     insertIntoManagedObjectContext: managedContext)
        
        // 3
        item.setValue(partNum, forKeyPath: "partNumber")
        item.setValue(serialNum, forKey: "serialNumber")
        item.setValue(location, forKey: "location")
        item.setValue(qty, forKey: "quantity")
        
        
        // 4
        do {
            try managedContext.save()
            itemList.append(item)
            return true
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func getItemByIndex(idx: Int) -> Item?
    {
        if idx > itemList.count
        {
            return nil
        }
        
        
        let item = itemList[idx]
        
        let pNumber: String = String(item.valueForKey("partNumber")!)
        let sNumber: String = String(item.valueForKey("serialNumber")!)
        let loc: String = String(item.valueForKey("location")!)
        let quantityNum: Int = Int(String(item.valueForKey("quantity")!))!
        
        return Item(location: loc, partNumber: pNumber, qty: quantityNum, serialNumber: sNumber)
       
    }
    
    func loadDB() -> Bool {
        guard let appDelegate =
            UIApplication.sharedApplication().delegate as? AppDelegate else {
                return false
        }
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest =  NSFetchRequest(entityName: "Item")
        
        do {
            itemList = try managedContext.executeFetchRequest(fetchRequest) as! [NSManagedObject]
            return true
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
            return false
        }
    }
    
   /* func addNewReport(newReport: String) -> String {
        reports.append(newReport)
        return newReport
        
    } */

    func addNewReport(newRecord: String) -> NSManagedObject {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let newRecord = NSEntityDescription.insertNewObjectForEntityForName("Reports", inManagedObjectContext: context)
        reportList.append(newRecord)
        return newRecord
    }
    
    
}
