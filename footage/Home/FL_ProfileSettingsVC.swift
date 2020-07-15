//
//  FL_ProfileSettingsVC.swift
//  footage
//
//  Created by 녘 on 2020/07/13.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class FL_ProfileSettingsVC: UIViewController {
    var profileImage: UIImage?
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileView: UIImageView!
    @IBAction func profileChangeButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToProfileFL", sender: self)
    }
    @IBAction func nameChangeButtonPressed(_ sender: UIButton) {
        var userInput: String = ""
        let rename = UIAlertController.init(title: "이름 설정", message: "사용할 이름을 입력해주세요.", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "수정", style: .default) { (action) in
            userInput = rename.textFields![0].text!
            if (userInput.isEmpty) {
                return
            }
            UserDefaults.standard.setValue(userInput, forKey: "userName")
            self.nameLabel.text = userInput
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
            print(action)
        }
        rename.addTextField { (textField) in
            textField.placeholder = self.nameLabel.text
        }
        rename.addAction(okAction)
        rename.addAction(cancelAction)
        
        
        self.present(rename, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage = #imageLiteral(resourceName: "profile")
        if let profileData = UserDefaults.standard.data(forKey: "profileImage") {
            profileImage = UIImage(data: profileData)!
        }
        reloadProfileImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfileFL" {
            let destinationVC = segue.destination as! ProfileSelectionVC
            destinationVC.parentVC = self
            
        }
    }
    
    
    func reloadProfileImage() {
        profileView.layer.cornerRadius = profileView.bounds.width / 2.0
        profileView.image = profileImage
    }
}
