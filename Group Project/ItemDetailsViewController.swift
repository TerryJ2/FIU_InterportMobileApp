//
//  ItemDetailsViewController.swift
//  Group Project
//
//  Created by Andres Diaz on 4/16/17.
//  Copyright © 2017 Florida International University. All rights reserved.
//

import UIKit

class ItemDetailsViewController: UIViewController, UITextFieldDelegate {
    
    let myModel: Model = Model.sharedInstance
    
    var itemBarcode: String?
    var itemSerialNumber: String?
    var itemLocation: String?
    var itemAmount: Int?
    
    @IBOutlet var partNum: UITextField!
    
    @IBOutlet var serialNum: UITextField!
    
    
    @IBOutlet var location: UITextField!
    
    
    @IBOutlet var quantityNum: UITextField!
    
    
    
    @IBOutlet var stepper: UIStepper!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //TJ
        partNum.text = itemBarcode ?? ""
        serialNum.text = itemSerialNumber ?? ""
        location.text = itemLocation ?? ""
        quantityNum.text = itemAmount?.description ?? "0"
        stepper.value = Double(itemAmount!) ?? 0
        
        stepper.autorepeat = true
        stepper.minimumValue = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func stepperPressed(sender: UIStepper) {
        
        quantityNum.text = Int(sender.value).description
    }
    
    
    @IBAction func savePressed(sender: AnyObject) {
        
        
        
        let partNumber: String = self.partNum.text!
        let serialNumber: String = self.serialNum.text!
        let loc: String = self.location.text!
        let qtyNum: Int = Int(self.quantityNum.text!)!
        
        if (myModel.save(partNumber, serialNum: serialNumber, location: loc, qty: qtyNum))
        {
            let alert = UIAlertController(title: "Item Saved", message: "Item successfully added!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: {
                action in
                self.performSegueWithIdentifier("unwindToScanner", sender: self)
            }))
            self.presentViewController(alert, animated: true, completion: nil)

        }
        
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
