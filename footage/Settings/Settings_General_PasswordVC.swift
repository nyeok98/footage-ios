//
//  Settings_General_PasswordVC.swift
//  footage
//
//  Created by 녘 on 2020/07/26.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class Settings_General_PasswordVC: UIViewController {
    
    var numberTogether: String = ""
    var compareNumbers: String = ""
    var isQualified: Bool = false
    var generalVC: Settings_GeneralVC?
    var whereAreYouFrom: String = ""
    @IBOutlet weak var guideString: UILabel!
    
    @IBOutlet weak var firstDot: UIImageView!
    @IBOutlet weak var secondDot: UIImageView!
    @IBOutlet weak var thirdDot: UIImageView!
    @IBOutlet weak var fourthDot: UIImageView!
    
    @IBAction func backButton(_ sender: Any) {
        if whereAreYouFrom == "passcode" {
        if let cellObj =  generalVC?.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) {
            let switchView = cellObj.accessoryView as! UISwitch
            switchView.setOn(false, animated: true)
        }
        } else if whereAreYouFrom == "faceId" {
            if let cellObj =  generalVC?.tableView.cellForRow(at: IndexPath(row: 1, section: 0)) {
                let switchView = cellObj.accessoryView as! UISwitch
                switchView.setOn(false, animated: true)
            }
            if let cellObj =  generalVC?.tableView.cellForRow(at: IndexPath(row: 2, section: 0)) {
                let switchView = cellObj.accessoryView as! UISwitch
                switchView.setOn(false, animated: true)
            }
        }
        UserDefaults.standard.setValue("noPassword", forKey: "UserState")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func eraseButton(_ sender: Any) {
        if !numberTogether.isEmpty { numberTogether.removeLast() }
        fillDots()
    }
    @IBAction func number1Pressed(_ sender: Any) {
        numberTogether.append("1")
        fillDots()
    }
    @IBAction func number2Pressed(_ sender: Any) {
        numberTogether.append("2")
        fillDots()
    }
    @IBAction func number3Pressed(_ sender: Any) {
        numberTogether.append("3")
        fillDots()
    }
    @IBAction func number4Pressed(_ sender: Any) {
        numberTogether.append("4")
        fillDots()
    }
    @IBAction func number5Pressed(_ sender: Any) {
        numberTogether.append("5")
        fillDots()
    }
    @IBAction func number6Pressed(_ sender: Any) {
        numberTogether.append("6")
        fillDots()
    }
    @IBAction func number7Pressed(_ sender: Any) {
        numberTogether.append("7")
        fillDots()
    }
    @IBAction func number8Pressed(_ sender: Any) {
        numberTogether.append("8")
        fillDots()
    }
    @IBAction func number9Pressed(_ sender: Any) {
        numberTogether.append("9")
        fillDots()
    }
    @IBAction func number0Pressed(_ sender: Any) {
        numberTogether.append("0")
        fillDots()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstDot.image = UIImage(systemName: "circle")
        secondDot.image = UIImage(systemName: "circle")
        thirdDot.image = UIImage(systemName: "circle")
        fourthDot.image = UIImage(systemName: "circle")
    }
    
    func fillDots() {
        switch numberTogether.count {
        case 0:
            firstDot.image = UIImage(systemName: "circle")
            secondDot.image = UIImage(systemName: "circle")
            thirdDot.image = UIImage(systemName: "circle")
            fourthDot.image = UIImage(systemName: "circle")
        case 1:
            firstDot.image = UIImage(systemName: "circle.fill")
            secondDot.image = UIImage(systemName: "circle")
            thirdDot.image = UIImage(systemName: "circle")
            fourthDot.image = UIImage(systemName: "circle")
            isQualified = false
        case 2:
            firstDot.image = UIImage(systemName: "circle.fill")
            secondDot.image = UIImage(systemName: "circle.fill")
            thirdDot.image = UIImage(systemName: "circle")
            fourthDot.image = UIImage(systemName: "circle")
            isQualified = false
        case 3:
            firstDot.image = UIImage(systemName: "circle.fill")
            secondDot.image = UIImage(systemName: "circle.fill")
            thirdDot.image = UIImage(systemName: "circle.fill")
            fourthDot.image = UIImage(systemName: "circle")
            isQualified = false
        case 4:
            firstDot.image = UIImage(systemName: "circle.fill")
            secondDot.image = UIImage(systemName: "circle.fill")
            thirdDot.image = UIImage(systemName: "circle.fill")
            fourthDot.image = UIImage(systemName: "circle.fill")
            isQualified = false
            if compareNumbers.isEmpty {
                compareNumbers = numberTogether
                numberTogether = ""
                guideString.text = "비밀번호를 한 번 더 입력해주세요."
                fillDots()
            } else {
                if compareNumbers == numberTogether {
                    isQualified = true
                    complete()
                }
                else {
                    guideString.text = "비밀번호가 일치하지 않습니다."
                    numberTogether = ""
                    fillDots()
                }
            }
        default :
            firstDot.image = UIImage(systemName: "circle")
            secondDot.image = UIImage(systemName: "circle")
            thirdDot.image = UIImage(systemName: "circle")
            fourthDot.image = UIImage(systemName: "circle")
            
        }
    }
    
    func complete() {
        if isQualified {
            let youSureAlert = UIAlertController.init(title: "주의", message: "정말 비밀번호를 설정하시겠습니까?", preferredStyle:  .alert)
            let realOk =  UIAlertAction.init(title: "설정", style: .default) { (action) in
                UserDefaults.standard.set(self.numberTogether, forKey: "Password")
                self.dismiss(animated: true, completion: nil)
            }
            let actuallyNo = UIAlertAction.init(title: "취소", style: .cancel) { [self] (action) in
                self.numberTogether = ""
                self.isQualified = false
                self.fillDots()
            }
            youSureAlert.addAction(realOk)
            youSureAlert.addAction(actuallyNo)
            
            self.present(youSureAlert, animated: true, completion: nil)
        } else {
            let pleaseFill = UIAlertController.init(title: "주의", message: "비밀번호는 네자리가 되어야합니다.", preferredStyle:  .alert)
            let tryAgain = UIAlertAction.init(title: "확인", style: .cancel) { (action) in
                print(action)
            }
            pleaseFill.addAction(tryAgain)
            
            self.present(pleaseFill, animated: true, completion: nil)
        }
    }
}
