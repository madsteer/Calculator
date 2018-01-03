//
//  UrlViewMentionViewController.swift
//  Smashtag
//
//  Created by Cory Steers on 1/3/18.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import UIKit

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
    
    //    override func loadView() {
    //        super.loadView()
    //
    ////        let webConfiguration = WKWebViewConfiguration()
    ////        webView = WKWebView(frame: .zero, configuration: webConfiguration)
    //        webView = WKWebView()
    //        webView?.navigationDelegate = self
    //        view = webView
    //    }
    
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
                        //                        self.webView.allowsBackForwardNavigationGestures = true
                    }
                }
            }
        }
        //        spinner.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        //        if let identifier = segue.identifier {
        //            switch identifier {
        //            case "returnToDetail":
        //                  if  let seguedToMvc = segue.destination as? TweetTableViewController {
        //                    seguedToMvc
        //                }
        //            default: break
        //            }
        //        }
    }
    
}
