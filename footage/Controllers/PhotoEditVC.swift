//
//  PhotoEditVC.swift
//  footage
//
//  Created by Wootae on 6/22/20.
//  Copyright © 2020 DreamPizza. All rights reserved.
//

import UIKit
import Photos
import PhotosUI

class PhotoEditVC: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var profileView = UIView() // container for the selected portion
    var imageView = UIImageView()
    var parentVC: UIViewController?
    var statsVC: StatsViewController?
    var imageAsset: PHAsset?
    @IBOutlet weak var confirmButton: UIButton!
    @IBAction func confirmPressed(_ sender: UIButton) {
        statsVC?.profileImage = captureSelectedRegion()
        statsVC?.reloadProfileImage()
        self.dismiss(animated: false) {
            self.parentVC!.dismiss(animated: false) { }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.frame = view.frame
        imageView.frame = scrollView.frame
        imageView.contentMode = .scaleAspectFit
        imageView.image = loadImage(asset: imageAsset)
        setupScrollView()
        scrollView.addSubview(imageView)
        view.bringSubviewToFront(confirmButton)
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

        
    private func loadImage(asset: PHAsset?) -> UIImage? {
        guard let asset = asset else { return nil }
        var toReturn: UIImage?
        let photoSize = CGSize(width: 1200, height: 800)
        let options = PHImageRequestOptions()
//        options.deliveryMode = .highQualityFormat
//        options.resizeMode = .none
        options.isSynchronous = true
        PHImageManager.default().requestImage(for: asset, targetSize: photoSize, contentMode: .aspectFit, options: options) { (image, info) in
            toReturn = image
        }
        return toReturn
    }
    
    
    // USE CENTER FOR CIRCLE!!
    func captureSelectedRegion() -> UIImage {
//        //let profilePosition = CGPoint(x: view.bounds.width / 2 - 100, y: view.bounds.height / 2 - 100)
//        let profilePosition = CGPoint(x: 0, y: 0)
//        //let profileSize = CGSize(width: 200, height: 200)
//        let profileSize = CGSize(width: view.bounds.width, height: view.bounds.height)
//        profileView.bounds = CGRect(origin: profilePosition, size: profileSize)
//        profileView.addSubview(imageView)
//        view.addSubview(profileView)
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, UIScreen.main.scale)
        //view.drawHierarchy(in: CGRect(origin: profilePosition, size: profileSize), afterScreenUpdates: true)
        view.drawHierarchy(in: imageView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = image {
            return image
        }
        return UIImage()
    }
}
