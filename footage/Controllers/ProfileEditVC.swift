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

class ProfileEditVC: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    var profileView = UIView() // container for the selected portion
    var parentVC: ProfileSelectionVC?
    var statsVC: DateViewController?
    var imageAsset: PHAsset?
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBAction func confirmPressed(_ sender: UIButton) {
        statsVC?.profileImage = captureSelectedRegion()
        UserDefaults.standard.setValue(statsVC?.profileImage.pngData(), forKey: "profileImage")
        statsVC?.reloadProfileImage()
        self.dismiss(animated: false) { }
        self.parentVC!.dismiss(animated: false) { }
        parentVC?.cacheManager.stopCachingImagesForAllAssets()
    }
    
    @IBAction func backPressed(_ sender: UIButton) {self.dismiss(animated: true){}}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //scrollView.frame = view.frame
        imageView.image = loadImage(asset: imageAsset)
        setupScrollView()
        
        let overlay = createOverlay(frame: view.frame,
                                    xOffset: view.frame.midX,
                                    yOffset: view.frame.midY,
                                    radius: 150.0)
        overlay.isUserInteractionEnabled = false
        view.addSubview(overlay)
        
        //view.bringSubviewToFront(scrollView)
        view.bringSubviewToFront(confirmButton)
        view.bringSubviewToFront(backButton)
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
        //let profilePosition = CGPoint(x: view.bounds.width / 2 - 100, y: view.bounds.height / 2 - 100)
//        let profilePosition = CGPoint(x: 0, y: 0)
        //let profileSize = CGSize(width: 200, height: 200)
//        let profileSize = CGSize(width: view.bounds.width, height: view.bounds.height)
//        profileView.bounds = CGRect(origin: profilePosition, size: profileSize)
//        profileView.addSubview(imageView)
//        view.addSubview(profileView)
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
        //view.drawHierarchy(in: CGRect(origin: profilePosition, size: profileSize), afterScreenUpdates: true)
        view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let image = image {
            return cropToBounds(image: image, width: 10, height: 10)
        }
        return UIImage()
    }
    
    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage { // TODO: leave only necessary parts

        let cgimage = image.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgimage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            cgwidth = contextSize.width * 4/5
            cgheight = contextSize.width * 4/5
            posX = contextSize.width / 2 - (cgwidth/2)
            posY = contextSize.height / 2 - (cgwidth/2)
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgimage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)

        return image
    }
    
    func createOverlay(frame: CGRect,
                       xOffset: CGFloat,
                       yOffset: CGFloat,
                       radius: CGFloat) -> UIView {
        // Step 1
        let overlayView = UIView(frame: frame)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        // Step 2
        let path = CGMutablePath()
        path.addArc(center: CGPoint(x: xOffset, y: yOffset),
                    radius: radius,
                    startAngle: 0.0,
                    endAngle: 2.0 * .pi,
                    clockwise: false)
        path.addRect(CGRect(origin: .zero, size: overlayView.frame.size))
        // Step 3
        let maskLayer = CAShapeLayer()
        maskLayer.backgroundColor = UIColor.black.cgColor
        maskLayer.path = path
        maskLayer.fillRule = .evenOdd
        // Step 4
        overlayView.layer.mask = maskLayer
        overlayView.clipsToBounds = true

        return overlayView
    }
    
    
}
