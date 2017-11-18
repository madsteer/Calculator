//
//  URLMentionViewController.swift
//  Smashtag
//
//  Created by Cory Steers on 11/14/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import WebKit

class URLMentionViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView! {
        didSet {
            if let urlString = urlString {
                webView.delegate = self
                self.title = URL(string: urlString)?.host
                webView.scalesPageToFit = true
                updateUI()
            }
        }
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func updateUI() {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                spinner.startAnimating()
                DispatchQueue.global(qos: .userInitiated).async {
                    let request = URLRequest(url: url)
                    DispatchQueue.main.async {
                        self.webView.loadRequest(request)
                        self.spinner.stopAnimating()
                    }
                }
            }
        }
    }
}
