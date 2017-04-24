//
//  HomeViewController.swift
//  Group Project
//
//  Created by Justin Joerg on 4/9/17.
//  Copyright © 2017 Florida International University. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UITableViewController {
   
    var managedObjectContext: NSManagedObjectContext? = nil
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
        managedObjectContext = appDelegate.managedObjectContext
        let report = NSEntityDescription.insertNewObjectForEntityForName("Item", inManagedObjectContext: managedObjectContext!)
        
        report.setValue("0000", forKey: "serialNumber")
        report.setValue("AAAA", forKey: "partNumber")
        report.setValue("Warehouse 10", forKey: "location")
        report.setValue(2, forKey: "quantity")
        */
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
