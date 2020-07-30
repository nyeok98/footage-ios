//
//  PopUpCard.swift
//  footage
//
//  Created by 녘 on 2020/07/23.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class PopUpCard: UIView {
    
    @IBOutlet weak var badgeBoxView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var badgeImageView: UIImageView!
    @IBAction func confirmButton(_ sender: Any) {
        self.removeFromSuperview()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PopUpCard", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
