//
//  ExpressionEditorViewController.swift
//  FaceIt
//
//  Created by Cory Steers on 12/5/17.
//  Copyright © 2017 Cory Steers. All rights reserved.
//

import UIKit

class ExpressionEditorViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var eyeControl: UISegmentedControl!
    @IBOutlet weak var mouthControl: UISegmentedControl!
    
    var name: String {
        return nameTextField?.text ?? ""
    }
    
    private let eyeChoices = [FacialExpression.Eyes.open, .closed, .squinting]
    private let mouthChoices = [FacialExpression.Mouth.frown,
         .smirk, .neutral, .grin, .smile]
    
    var expression: FacialExpression {
        return FacialExpression(eyes: eyeChoices[eyeControl?.selectedSegmentIndex ?? 0], mouth: mouthChoices[mouthControl?.selectedSegmentIndex ?? 0])
    }
    
    @IBAction func updateFace() {
//        print("\(name) = \(expression)")
        faceViewController?.expression = expression
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        presentingViewController?.dismiss(animated: true)
    }
    
    private var faceViewController: BlinkingFaceViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Embed Face" {
            faceViewController = segue.destination as? BlinkingFaceViewController
            faceViewController?.expression = expression
        }
    }
    
    private func squareUpPreferredSizeStarting(with size: CGSize) -> CGSize {
        let blinkingFaceViewIndexPath = IndexPath(row: 1, section: 0)
        
        var size = size
        size.height -= tableView.heightForRow(at: blinkingFaceViewIndexPath) // subtract height of row that blinking face view from total
        size.height += size.width // add width of blinking face view back so there's enough height for it to be a square image
        
        return size
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let popoverPresentationController = navigationController?.popoverPresentationController {
            if popoverPresentationController.arrowDirection != .unknown { // if popover arrow IS pointing at something (NOT unknown)
                navigationItem.leftBarButtonItem = nil // remove cancel button
            }
        }
//        var size = tableView.minimumSize(forSection: 0)
//        size.height -= tableView.heightForRow(at: IndexPath(row: 1, section: 0))
//        size.height += size.width
        let size = squareUpPreferredSizeStarting(with: tableView.minimumSize(forSection: 0))
        preferredContentSize = size
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return tableView.bounds.size.width
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UITableView {
    // warning: this forces a cell to be created for every row in that section
    // thus this only makes sense for smaller tables
    // it also does not account for any section headers or footers
    // it may well have other restrictions too :)
    
    func minimumSize(forSection section: Int) -> CGSize {
        var width: CGFloat = 0
        var height: CGFloat = 0
        for row in 0..<numberOfRows(inSection: section) {
            let indexPath = IndexPath(row: row, section: section)
            if let cell = cellForRow(at: indexPath) ?? dataSource?.tableView(self, cellForRowAt: indexPath) {
                let cellSize = cell.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
                width = max(width, cellSize.width)
                height += heightForRow(at: indexPath)
            }
        }
        return CGSize(width: width, height: height)
    }

    func heightForRow(at indexPath: IndexPath? = nil) -> CGFloat {
        if let indexPath = indexPath,
            let height = delegate?.tableView?(self, heightForRowAt: indexPath) {
            return height
        } else {
            return rowHeight
        }
    }
}
