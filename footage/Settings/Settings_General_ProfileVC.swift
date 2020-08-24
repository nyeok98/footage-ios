//
//  Settings_General_ProfileVC.swift
//  footage
//
//  Created by 녘 on 2020/07/24.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import Photos

class Settings_General_ProfileVC: UIViewController {
    var profileImage: UIImage?
    var photoAuth = PHPhotoLibrary.authorizationStatus()
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var profileView: UIImageView!
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func confirmButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func profileChangeButtonPressed(_ sender: UIButton) {
        switch photoAuth {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { (status) in
                self.photoAuth = status
                if status == .authorized {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "goToProfileGeneral", sender: sender)
                    }
                }
            }
        case .authorized: performSegue(withIdentifier: "goToProfileGeneral", sender: sender)
        default: alertPhotoAuthorization()
        }
    }
    @IBAction func nameChangeButtonPressed(_ sender: UIButton) {
        var userInput: String = ""
        let rename = UIAlertController.init(title: "이름 설정", message: "사용할 이름을 6자 이내로 입력해주세요.", preferredStyle: .alert)
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
            textField.smartInsertDeleteType = .no
            textField.delegate = self
        }
        rename.addAction(okAction)
        rename.addAction(cancelAction)
        
        
        self.present(rename, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImage = #imageLiteral(resourceName: "baseProfileImage")
        if let profileData = UserDefaults.standard.data(forKey: "profileImage") {
            profileImage = UIImage(data: profileData)!
        }
        if let userName = UserDefaults.standard.string(forKey: "userName") {
            nameLabel.text = userName
        }
        reloadProfileImage()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToProfileGeneral" {
            let destinationVC = segue.destination as! ProfileSelectionVC
            destinationVC.parentVC = self
        }
    }
    
    
    func reloadProfileImage() {
        profileView.layer.cornerRadius = profileView.bounds.width / 2.0
        profileView.image = profileImage
    }
    
    func alertPhotoAuthorization() {
        // UIApplication -openUrl: and UIApplicationOpenSettingsURLString
        let alert = UIAlertController(title: "사진을 불러올 수 없습니다", message: "소중한 기록을 위해 사진 접근을 허용해주세요.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: { (_) in
            alert.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "설정", style: .default, handler: { (_) in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension Settings_General_ProfileVC: UITextFieldDelegate {
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

