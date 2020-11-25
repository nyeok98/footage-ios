//
//  FL_NameColorVC.swift
//  footage
//
//  Created by 녘 on 2020/07/13.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class FL_NameColorVC: UIViewController {
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fifthLabel: UILabel!
    
    
    @IBAction func firstColorEditPressed(_ sender: UIButton) {
        giveAlert(labelname: firstLabel, hexCode: "#EADE4Cff")
    }
    @IBAction func secondColorEditPressed(_ sender: UIButton) {
        giveAlert(labelname: secondLabel, hexCode: "#F5A997ff")
    }
    @IBAction func thirdColorEditPressed(_ sender: UIButton) {
        giveAlert(labelname: thirdLabel, hexCode: "#F0E7CFff")
    }
    @IBAction func fourthColorEditPressed(_ sender: UIButton) {
        giveAlert(labelname: fourthLabel, hexCode: "#FF6B39ff")
    }
    @IBAction func fifthColorEditPressed(_ sender: UIButton) {
        giveAlert(labelname: fifthLabel, hexCode: "#206491ff")
    }
    @IBAction func confirmButton(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        guard let widgetUD = UserDefaults(suiteName: "group.footage") else { return }
        firstLabel.text = widgetUD.string(forKey: "#EADE4Cff")
        secondLabel.text = widgetUD.string(forKey: "#F5A997ff")
        thirdLabel.text = widgetUD.string(forKey: "#F0E7CFff")
        fourthLabel.text = widgetUD.string(forKey: "#FF6B39ff")
        fifthLabel.text = widgetUD.string(forKey: "#206491ff")
    }
    
    
    func giveAlert(labelname: UILabel, hexCode: String) {
        var userInput: String = ""
        let rename = UIAlertController.init(title: "카테고리 설정", message: "이름을 입력해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "수정", style: .default) { (action) in
            userInput = rename.textFields![0].text!
            if (userInput.isEmpty) {
                return
            }
            labelname.text = userInput
            UserDefaults(suiteName: "group.footage")?.setValue(labelname.text, forKey: hexCode)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            print(action)
        }
        rename.addTextField { (textField) in
            textField.placeholder = labelname.text
            textField.smartInsertDeleteType = .no
            textField.delegate = self
        }
        rename.addAction(okAction)
        rename.addAction(cancelAction)
        
        
        self.present(rename, animated: true, completion: nil)
    }
}



extension FL_NameColorVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text,
              let rangeOfTextToReplace = Range(range, in: textFieldText) else {
            return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 7
    }
}
