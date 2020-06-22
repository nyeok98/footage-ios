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
    }
    
    func configure(with image: UIImage?) {
        configure()
        self.imageView.image = image
    }
}
