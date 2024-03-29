//
//  FL_LetsStartVC.swift
//  footage
//
//  Created by 녘 on 2020/07/13.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import MapKit

class FL_LetsStartVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func startButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.set("noPassword", forKey: "UserState")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController else { return }
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        keyWindow?.rootViewController = tabBarController
    }
}
