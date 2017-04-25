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
    var hideDeleteButton: Bool = false
    var hideAmount: Bool = false
    var item: Item?
    var itemIndex: Int?
    
    @IBOutlet weak var deleteItemBtn: UIButton!
    @IBOutlet var partNum: UITextField!
    @IBOutlet var serialNum: UITextField!
    @IBOutlet var location: UITextField!
    @IBOutlet var quantityNum: UITextField!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Inserts the ui controls data when viewing the item detail
        //from the inventory list
        partNum.text = itemBarcode ?? item?.partNumber ?? ""
        serialNum.text = item?.serialNumber ?? ""
        location.text = item?.location ?? ""
        quantityNum.text = item?.qty.description ?? "0"
        stepper.value = Double((item?.qty)!) ?? 0
        
        //Hide these elements when viewing the item detail from the
        //inventory list
        deleteItemBtn.hidden = hideDeleteButton
        quantityNum.hidden = hideAmount
        stepper.hidden = hideAmount
        quantityLabel.hidden = hideAmount
        
        stepper.autorepeat = true
        stepper.minimumValue = 0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func deletePressed(sender: UIButton) {
        
        let alert = UIAlertController(title: "Delete Item", message: "Are you sure you want to delete this item?", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: nil))
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: {
            (action: UIAlertAction!) in self.deleteItem()
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func deleteItem()
    {
         let result = Model.sharedInstance.deleteItem(serialNum.text!)
         if result
         {
            Model.sharedInstance.itemList.removeAtIndex(itemIndex!)
            Model.sharedInstance.loadDB();
         }
        self.performSegueWithIdentifier("unwindToScanner", sender: self)
    }
    
    
    
    @IBAction func stepperPressed(sender: UIStepper) {
        quantityNum.text = Int(sender.value).description
    }
    
    
    @IBAction func savePressed(sender: AnyObject) {
    
        let partNumber: String = self.partNum.text!
        let serialNumber: String = self.serialNum.text!
        let loc: String = self.location.text!
        let qtyNum: Int = Int(self.quantityNum.text!)!
        
        //The following will either update the item if the View Controller was passed an item else
        //it will create and save the item to the database
        var result = false;
        var alertMessage = "Item successfully updated"
        var alertTitle = "Item Saved"
        
        if item != nil
        {
            result = Model.sharedInstance.updateItem((item?.serialNumber)!, updatedSerialNumber: serialNumber, updatedPartNumber: partNumber, updatedLocation: loc)
            
            alertTitle = "Item update"
            alertMessage = "Item successfully updated!"
            
        }else{
            result = myModel.save(partNumber, serialNum: serialNumber, location: loc, qty: qtyNum)
        }
        
        if (result)
        {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
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
