//
//  Settings_GeneralVC.swift
//  footage
//
//  Created by 녘 on 2020/07/06.
//  Copyright © 2020 DreamPizza. All rights reserved.
//
import UIKit

class Settings_GeneralVC: UIViewController {
    
    let cellIdentifier = "generalCell"
    let cellContent = ["내 정보","암호잠금", "FaceID", "푸시 알림"]
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = UIColor.white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! Settings_General_PasswordVC
        destinationVC.generalVC = self
        if let sender = sender as? UISwitch {
            if sender.tag == 1 {
                destinationVC.whereAreYouFrom = "passcode"
            } else if sender.tag == 2 {
                destinationVC.whereAreYouFrom = "faceId"
            }
        }
    }
}

extension Settings_GeneralVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if indexPath.row == 0 {
            cell.accessoryType = .disclosureIndicator; cell.selectionStyle = .default
        } else {
            let switchView = UISwitch(frame: .zero)
            if indexPath.row == 1 && (UserDefaults.standard.string(forKey: "UserState") == "hasPassword" || UserDefaults.standard.string(forKey: "UserState") == "hasBioId") {
                switchView.setOn(true, animated: true)
            } else if indexPath.row == 2 && UserDefaults.standard.string(forKey: "UserState") == "hasBioId" {
                switchView.setOn(true, animated: true)
            } else if indexPath.row == 3 {
                switchView.setOn(true, animated: true)
            } else { switchView.setOn(false, animated: true) }
            switchView.tag = indexPath.row // for detect which row switch Changed
            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchView
            cell.selectionStyle = .none
        }
        
        cell.textLabel!.text = cellContent[indexPath.row]
        cell.textLabel?.font = UIFont(name: "NanumBarunpen", size: 20)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {
            performSegue(withIdentifier: "goToGeneralProfileSettings", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        
        if sender.tag == 1 && sender.isOn { // remove password
            performSegue(withIdentifier: "goToPasswordSettings", sender: sender)
        } else if sender.tag == 1 && !sender.isOn {
            let youSureAlert = UIAlertController.init(title: "주의", message: "정말 비밀번호를 삭제하시겠습니까?", preferredStyle:  .alert)
            let realOk =  UIAlertAction.init(title: "삭제", style: .default) { (action) in
                if let cellObj =  self.tableView.cellForRow(at: IndexPath(row: sender.tag+1, section: 0)) {
                    let switchView = cellObj.accessoryView as! UISwitch
                    switchView.setOn(false, animated: true)
                }
                UserDefaults.standard.setValue("noPassword", forKey: "UserState")
            }
            let actuallyNo = UIAlertAction.init(title: "취소", style: .cancel) { (action) in
                if let cellObj =  self.tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0)) {
                    let switchView = cellObj.accessoryView as! UISwitch
                    switchView.setOn(true, animated: true)
                }
            }
            youSureAlert.addAction(realOk)
            youSureAlert.addAction(actuallyNo)
            
            self.present(youSureAlert, animated: true, completion: nil)
        }
        
        if sender.tag == 2 && sender.isOn { // turn on bio id
            if let cellObj =  self.tableView.cellForRow(at: IndexPath(row: sender.tag-1, section: 0)) {
                let switchView = cellObj.accessoryView as! UISwitch
                if switchView.isOn {
                    UserDefaults.standard.setValue("hasBioId", forKey: "UserState")
                }
                else if !switchView.isOn {
                    switchView.setOn(true, animated: true)
                    performSegue(withIdentifier: "goToPasswordSettings", sender: sender)
                }
            }
            
        } else if sender.tag == 2 && !sender.isOn { // turn on password
            UserDefaults.standard.setValue("hasPassword", forKey: "UserState")
        }
    }
    
}
