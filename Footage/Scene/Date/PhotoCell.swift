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
    var selectedMark = UIImageView(image: #imageLiteral(resourceName: "monthFive"))
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
    
    func select() {
        alpha = 0.8
        selectedMark.frame = CGRect(x: bounds.maxX - 25, y: bounds.maxY - 25, width: 20, height: 20)
        addSubview(selectedMark)
    }
    
    func deselect() {
        alpha = 1.0
        selectedMark.removeFromSuperview()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        deselect()
    }

}
