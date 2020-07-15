//
//  FL_LetsStartVC.swift
//  footage
//
//  Created by 녘 on 2020/07/13.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class FL_LetsStartVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.set(true, forKey: "launchedBefore")
        let tabBarController = self.storyboard?.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
        UIApplication.shared.keyWindow?.rootViewController = tabBarController
    }
}
