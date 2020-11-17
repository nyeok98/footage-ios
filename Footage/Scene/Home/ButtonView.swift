//
//  ButtonView.swift
//  Footage
//
//  Created by user on 2020/11/15.
//  Copyright © 2020 EL.Co. All rights reserved.
//

import UIKit

@IBDesignable
class ButtonView: UIView {
    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var indicator: UIImageView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var buttonStackView: UIStackView!
    
    weak var delegate: ButtonViewContainer?
    var otherColors = ["#EADE4Cff", "#F5A997ff", "#F0E7CFff", "#FF6B39ff", "#206491ff"]
    // loadSavedColors에서 mainColor 찾은 후 해당 String은 지워져 4개로 운영됨
    var mainColor: String = ""
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadSavedColors()
    }
    
    func loadSavedColors() {
        if let lastSelectedColor = UserDefaults.standard.string(forKey: "selectedColor") {
            mainColor = lastSelectedColor
        } else {
            mainColor = "#EADE4Cff"
            UserDefaults.standard.set(mainColor, forKey: "selectedColor")
        }
        otherColors = otherColors.filter { $0 != mainColor }
        
        guard let selectedCategory = UserDefaults.standard.string(forKey: mainColor) else { return }
        mainLabel.text = "\"" + selectedCategory + "\""
        for index in 0...3 {
            guard let button = buttonStackView.arrangedSubviews[index] as? UIButton else { break }
            button.setImage(UIImage(named: otherColors[index]), for: .normal)
        }
        mainImage.image = UIImage(named: mainColor)
    }
    
    private func animateColorChange() {
        UIView.animate(withDuration: 0.3) {
            self.indicator.frame.origin.y -= 10
            self.mainLabel.frame.origin.y -= 10
        }
        UIView.animate(withDuration: 1) {
            self.indicator.frame.origin.y += 10
            self.mainLabel.frame.origin.y += 10
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        let buttonIndex = sender.tag
        let prevColor = mainColor
        mainColor = otherColors[buttonIndex]
        UserDefaults.standard.setValue(mainColor, forKey: "selectedColor")
        otherColors[buttonIndex] = prevColor
        guard let button = buttonStackView.arrangedSubviews[buttonIndex] as? UIButton else { return }
        button.setImage(UIImage(named: prevColor), for: .normal)
        mainImage.image = UIImage(named: mainColor)
        animateColorChange()
        delegate?.mainColorDidChange(hex: mainColor)
    }
}

protocol ButtonViewContainer: NSObject {
    func mainColorDidChange(hex: String)
}
