//
//  InventoryTableViewController.swift
//  InterportMobileApp
//
//  Created by Terry Jean on 4/22/17.
//  Copyright © 2017 Florida International University. All rights reserved.
//

import Foundation
import UIKit

class InventoryTableViewController: UITableViewController
{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var modelInstance = Model.sharedInstance
    var itemList = Model.sharedInstance.items
    
    override func viewDidLoad() {
        super.viewDidLoad()
        modelInstance.loadDB();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData();
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelInstance.itemList.count;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inventoryCell", forIndexPath: indexPath)
        
        let item = modelInstance.getItemByIndex(indexPath.row)
        
        cell.textLabel?.text = item?.serialNumber;
        cell.detailTextLabel?.text = item?.location;
        
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "inventoryItemDetail"
        {
            let detailScene = segue.destinationViewController as! ItemDetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let item = modelInstance.getItemByIndex(indexPath!.row)
            
            detailScene.itemLocation = item?.location
            detailScene.itemAmount = item?.qty
            detailScene.itemBarcode = item?.partNumber
            detailScene.itemSerialNumber = item?.serialNumber
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}