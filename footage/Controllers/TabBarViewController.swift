//
//  TabBarViewController.swift
//  footage
//
//  Created by 녘 on 2020/06/09.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        self.tabBar.tintColor = UIColor(named: "tabColor")
        self.tabBar.unselectedItemTintColor = UIColor(named: "untabColor")
        self.tabBar.clipsToBounds = true
    }

}
