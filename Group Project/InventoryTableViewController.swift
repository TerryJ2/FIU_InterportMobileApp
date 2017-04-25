//
//  InventoryTableViewController.swift
//  InterportMobileApp
//
//  Created by Terry Jean on 4/22/17.
//  Copyright © 2017 Florida International University. All rights reserved.
//

import Foundation
import UIKit

class InventoryTableViewController: UITableViewController, UISearchBarDelegate
{
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    var modelInstance = Model.sharedInstance
    var itemList = Model.sharedInstance.items
    var filteredItems: AnyObject = []
    
    @IBOutlet weak var searchBar: UISearchBar!
    var searchActive: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self;
        
        //Load the database
        modelInstance.loadDB();
        
        self.tableView.reloadData();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchActive ? filteredItems.count : modelInstance.itemList.count;
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        //Filters for items that contain anything from the search text
        filteredItems = modelInstance.itemList.filter({
            (item) -> Bool in
            let serialNumber: String = String(item.valueForKey("serialNumber")!)
            let range = serialNumber.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range != nil
        })
        
        searchActive = filteredItems.count > 0;
        
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inventoryCell", forIndexPath: indexPath)
        
        var serialNumber:String?
        var location:String?
        
        //While a search is currently active, only show elements
        //from the filtered list else show all of the items
        if searchActive
        {
            let filteredItem = filteredItems[indexPath.row]
            serialNumber = String(filteredItem.valueForKey("serialNumber")!)
            location =  String(filteredItem.valueForKey("location")!)
        }else
        {
            let item = modelInstance.getItemByIndex(indexPath.row)
            serialNumber = item?.serialNumber
            location = item?.location
        }

        cell.textLabel?.text = serialNumber
        cell.detailTextLabel?.text = location
        
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        //Sets up the item details for the ItemDetailsViewController by grabbing
        //the current item from the index
        if segue.identifier == "inventoryItemDetail"
        {
            let detailScene = segue.destinationViewController as! ItemDetailsViewController
            let indexPath = self.tableView.indexPathForSelectedRow
            let item = modelInstance.getItemByIndex(indexPath!.row)
            
            detailScene.item = item
            detailScene.itemIndex = indexPath!.row
            detailScene.hideAmount = true
            detailScene.hideDeleteButton = false
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue)
    {
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
}