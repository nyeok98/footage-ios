//
//  PasswordVC.swift
//  footage
//
//  Created by 녘 on 2020/07/26.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import LocalAuthentication
import UIKit

class PasswordVC: UIViewController {
    
    var numberTogether: String = ""
    var userPassword: String = ""
    
    @IBOutlet weak var firstDot: UIImageView!
    @IBOutlet weak var secondDot: UIImageView!
    @IBOutlet weak var thirdDot: UIImageView!
    @IBOutlet weak var fourthDot: UIImageView!
    
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
        userPassword = UserDefaults.standard.string(forKey: "Password")!
        let userState = UserDefaults.standard.string(forKey: "UserState")
        if userState == "hasBioId" { authenticateUser() }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        case 2:
            firstDot.image = UIImage(systemName: "circle.fill")
            secondDot.image = UIImage(systemName: "circle.fill")
            thirdDot.image = UIImage(systemName: "circle")
            fourthDot.image = UIImage(systemName: "circle")
        case 3:
            firstDot.image = UIImage(systemName: "circle.fill")
            secondDot.image = UIImage(systemName: "circle.fill")
            thirdDot.image = UIImage(systemName: "circle.fill")
            fourthDot.image = UIImage(systemName: "circle")
        case 4:
            firstDot.image = UIImage(systemName: "circle.fill")
            secondDot.image = UIImage(systemName: "circle.fill")
            thirdDot.image = UIImage(systemName: "circle.fill")
            fourthDot.image = UIImage(systemName: "circle.fill")
            
            if checkPassword(writtenPassword: numberTogether) {
                view.removeFromSuperview()
            } else {
                numberTogether = ""
                fillDots()
            }
            
        default :
            firstDot.image = UIImage(named:
                "circle")
            secondDot.image = UIImage(named:
                "circle")
            thirdDot.image = UIImage(named:
                "circle")
            fourthDot.image = UIImage(named:
                "circle")
            
        }
    }
    
    func checkPassword(writtenPassword: String) -> Bool {
        if writtenPassword == userPassword { return true }
        else { return false }
    }
    
}

extension PasswordVC {
    
    func authenticateUser() {
        let localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "Please use your Passcode"
        var authorizationError: NSError?
        let reason = "Authentication is required for you to continue"
        if localAuthenticationContext.canEvaluatePolicy(LAPolicy.deviceOwnerAuthentication, error: &authorizationError) {
            localAuthenticationContext.evaluatePolicy(LAPolicy.deviceOwnerAuthentication, localizedReason: reason) { (success, evaluationError) in
                if success { DispatchQueue.main.async { self.view.removeFromSuperview() }}
                else { print(evaluationError) } }
        } else { print("User has not enrolled into using Biometrics") }
    }
}
