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
    
    private var image: UIImage? {
        get { return imageView.image }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
        }
    }
    //    var urlContents: Data? { didSet{ updateUI() } }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//    private func updateUI() {
//        if let urlContents = urlContents {
//            imageView.image = UIImage(data: urlContents)
//        }
//    }
}
