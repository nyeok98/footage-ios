//
//  SettingsCell.swift
//  footage
//
//  Created by 녘 on 2020/07/06.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let cellView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.4
        view.layer.shadowOffset = .init(width: 3, height: 0)
        view.layer.shadowRadius = 10
        return view
    }()
    
    let dayLabel: UILabel = {
        let label = UILabel()
        label.text = "Day 1"
        label.textColor = UIColor.white
        label.font = UIFont.init(name: "NanumParunpenRegular", size: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupView() {
        addSubview(cellView)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
//
//        dayLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
//        dayLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        dayLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
//        dayLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true

    }
}
