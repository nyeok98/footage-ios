/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Simple example of a self-sizing supplementary title view
*/

import UIKit

class SectionHeader: UICollectionReusableView {
    let label = UILabel()
    static let reuseIdentifier = "section-supplementary-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(footstepNumber: Int) {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        label.font = UIFont(name: "NanumBarunpenRegular", size: 25)
        label.text = "# " + String(footstepNumber)
        let inset = CGFloat(10)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset)
        ])
        
    }
}
