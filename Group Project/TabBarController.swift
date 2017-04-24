//
//  TabBarController.swift
//  InterportMobileApp
//
//  Created by Terry Jean on 4/23/17.
//  Copyright © 2017 Florida International University. All rights reserved.
//

import Foundation

import UIKit

class TabBarController: UITabBarController
{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Stylize the navigation bars
        UINavigationBar.appearance().barTintColor = UIColor(red:0, green: 0.33, blue: 0.59, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.tabBar.hidden = true;
        
    }
}
