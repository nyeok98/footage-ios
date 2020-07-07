//
//  PhotoCell.swift
//  footage
//
//  Created by Wootae on 6/23/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    var imageView = UIImageView()
    static let reuseIdentifier = "photo-cell-reuse-identifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    func addImage(with image: UIImage?) {
        contentView.addSubview(imageView)
        imageView.frame = contentView.frame
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
    }

}
