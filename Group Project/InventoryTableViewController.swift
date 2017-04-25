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
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Rows \(filteredItems.count)")
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
        
        filteredItems = modelInstance.itemList.filter({
            (item) -> Bool in
            let serialNumber: String = String(item.valueForKey("serialNumber")!)
            let range = serialNumber.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            print(range)
            return range != nil
        })
        
        searchActive = filteredItems.count > 0;
        
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("inventoryCell", forIndexPath: indexPath)
        
        var serialNumber:String?
        var location:String?
        
        if searchActive
        {
            let filteredItem = filteredItems[indexPath.row]
            serialNumber = String(filteredItem.valueForKey("serialNumber")!)
            location =  String(filteredItem.valueForKey("location")!)

            print("Stil active")
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