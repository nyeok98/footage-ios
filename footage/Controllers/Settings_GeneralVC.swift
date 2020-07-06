//
//  Settings_GeneralVC.swift
//  footage
//
//  Created by 녘 on 2020/07/06.
//  Copyright © 2020 DreamPizza. All rights reserved.
//
import UIKit

class Settings_GeneralVC: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(SettingsCell.self, forCellReuseIdentifier: "cellId")
        
        tableView.separatorColor = UIColor.white
        
        
    }
    
    
}

extension Settings_GeneralVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! SettingsCell
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
