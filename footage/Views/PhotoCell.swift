/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Generic text cell
*/

import UIKit

class PhotoCell: UICollectionViewCell {
    let label = UILabel()
    var imageView = UIImageView()
    static let reuseIdentifier = "photo-cell-reuse-identifier"

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }

}

extension PhotoCell {
    func configure() {
        contentView.addSubview(imageView)
        imageView.frame = contentView.frame
        
        //let inset = CGFloat(10)
//        NSLayoutConstraint.activate([
//            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: inset),
//            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -inset),
//            label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: inset),
//            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -inset)
//            ])
    }
    
    func configure(with image: UIImage?) {
        configure()
        self.imageView.image = image
    }
}
