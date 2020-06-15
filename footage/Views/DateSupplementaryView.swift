/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Supplementary view for bading an item
*/

import UIKit

class DateSupplementaryView: UICollectionReusableView {

    static let reuseIdentifier = "badge-reuse-identifier"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

//    override var frame: CGRect { 이런식으로 하는 이유는?
//        didSet {
//            configureBorder()
//        }
//    }
//    override var bounds: CGRect {
//        didSet {
//            configureBorder()
//        }
//    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

extension DateSupplementaryView {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.textColor = .black
        backgroundColor = .clear
        configureBorder()
    }
    func configureBorder() {
//        let radius = bounds.width / 2.0
//        layer.cornerRadius = radius
//        layer.borderColor = UIColor.black.cgColor
//        layer.borderWidth = 1.0
    }
}
