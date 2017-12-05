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

class EmotionsViewController: UITableViewController {

    fileprivate var collapseDetailViewController = true

    private var emotionalFaces: [(name:String, expression: FacialExpression)]  = [
        ("sad", FacialExpression(eyes: .closed, mouth: .frown)),
        ("happy", FacialExpression(eyes: .open, mouth: .smile)),
        ("worried", FacialExpression(eyes: .open, mouth: .smirk))
    ]

//    override func viewDidLoad() {
//        super.viewDidLoad()
//        splitViewController?.delegate = self
//    }
    
    // MARK: UITableViewDataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emotionalFaces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Emotion Cell", for: indexPath)
        cell.textLabel?.text = emotionalFaces[indexPath.row].name
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
            
            destinationViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            destinationViewController.navigationItem.leftItemsSupplementBackButton = true
        }
        
        if let faceViewController = destinationViewController as? FaceViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
//            let identifier = segue.identifier,
//            let expression = emotionalFaces[identifier] {
            faceViewController.expression = emotionalFaces[indexPath.row].expression
            faceViewController.navigationItem.title = emotionalFaces[indexPath.row].name
        }
    }
}
