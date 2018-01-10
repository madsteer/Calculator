//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Cory Steers on 11/16/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

extension ImageViewController : UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        autoZoomed = false
    }
}

class ImageViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            spinner?.startAnimating()
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 2.0
            scrollView.contentSize = imageView.frame.size
            scrollView.addSubview(imageView)
        }
        
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var imageView = UIImageView()
    fileprivate var autoZoomed = true
    
    private var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
            autoZoomed = true
            zoomScaleToFit()
        }
    }
    
    private func zoomScaleToFit() {
        if let sv = scrollView,
            image != nil && autoZoomed && imageView.bounds.size.width > 0 && scrollView.bounds.size.width > 0 {
            
            let widthRatio = scrollView.bounds.size.width / imageView.bounds.size.width
            let heightRatio = scrollView.bounds.size.height / imageView.bounds.size.height
            sv.zoomScale = (widthRatio > heightRatio) ? widthRatio : heightRatio
            sv.contentOffset = CGPoint(x: (imageView.frame.size.width - sv.frame.size.width) / 2,
                                       y: (imageView.frame.size.height - sv.frame.size.height) / 2)
            
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        zoomScaleToFit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addReturnHome()
    }
}
