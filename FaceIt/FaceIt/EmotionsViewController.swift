//
//  EmotionsViewController.swift
//  FaceIt
//
//  Created by Cory Steers on 6/11/17.
//  Copyright © 2017 Cory Steers. All rights reserved.
//

import UIKit

extension EmotionsViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }
}

class EmotionsViewController: VCLLoggingViewController {

    fileprivate var collapseDetailViewController = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
            
            destinationViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            destinationViewController.navigationItem.leftItemsSupplementBackButton = true
        }
        
        /*
         instead of
         if let faceViewController = destinationViewController as? FaceViewController {
             if let identifier = segue.identifier {
                     if let expression = emotionalFaces[identifier] {
                         <code here>
                     }
             }
         }
         ... do the following
         */
        if let faceViewController = destinationViewController as? FaceViewController,
            let identifier = segue.identifier,
            let expression = emotionalFaces[identifier] {
            faceViewController.expression = expression
            faceViewController.navigationItem.title = (sender as? UIButton)?.currentTitle
        }
    }

    private let emotionalFaces: Dictionary<String, FacialExpression> = [
        "sad": FacialExpression(eyes: .closed, mouth: .frown),
        "happy": FacialExpression(eyes: .open, mouth: .smile),
        "worried": FacialExpression(eyes: .open, mouth: .smirk)
    ]
}
