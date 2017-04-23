//
//  AddReportViewController.swift
//  Group Project
//
//  Created by Justin Joerg on 4/16/17.
//  Copyright © 2017 Florida International University. All rights reserved.
//

import UIKit
import CoreData

class AddNewReportController: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet var reportNameTextField: UITextField!
    @IBOutlet var partNumberTextField: UITextField!
    var myNewReports = Model.sharedInstance
    var managedObjectContext: NSManagedObjectContext? = nil
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var found = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        navigationItem.backBarButtonItem = editButtonItem()
    }
    
    @IBAction func saveNewReport(sender: AnyObject) {
        
        if reportNameTextField.text != "" && partNumberTextField.text != "" {
            let manageRequest = NSFetchRequest(entityName: "Item")
            manageRequest.returnsObjectsAsFaults = false
            let context = appDelegate.managedObjectContext
            
            do {
                let results = try context.executeFetchRequest(manageRequest)
                for result in results as! [NSManagedObject] {
                    if result.valueForKey("partNumber") as? String == partNumberTextField.text {
                       found = true
                    }
                    
                }
                if found == true {
                    managedObjectContext = appDelegate.managedObjectContext
                    let report = NSEntityDescription.insertNewObjectForEntityForName("Reports", inManagedObjectContext: managedObjectContext!)
                    
                    report.setValue(reportNameTextField.text, forKey: "report")
                    report.setValue(partNumberTextField.text, forKey: "predicate")
                    
                    do {
                        try managedObjectContext!.save()
                        print("SAVE")
                        found = false
                        
                    } catch {
                        print("Did not save")
                        found = false
                    }
                    
                } else {
                    let alert = UIAlertController(title: "Part number not found", message: "Try again", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    partNumberTextField.text = ""
                    
                }
                
            } catch {
                print("Did not work")
            }

            
        } else {
            let alert = UIAlertController(title: "Please enter a report name and part number", message: "Try Again", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            reportNameTextField.text = ""
            partNumberTextField.text = ""
        }

    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func viewDidLoad() {
        //places the first contact into the text fields at start of app
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}