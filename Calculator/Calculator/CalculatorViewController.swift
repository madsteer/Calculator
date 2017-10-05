//
//  ViewController.swift
//  Calculator
//
//  Created by Cory Steers on 4/28/17.
//  Copyright © 2017 Cory Steers. All rights reserved.
//

import UIKit

extension CalculatorViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return collapseDetailViewController
    }
}
class CalculatorViewController: UIViewController {
    fileprivate var collapseDetailViewController = true
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var logDisplay: UILabel!
    
    var userIsTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        brain.addUnaryOperation(named: "✅") { [ weak self = self ] in
            brain.addUnaryOperation(named: "√") {
//            self?.display.textColor = UIColor.green // requires the "weak" above
            return sqrt($0)
        }
        
        splitViewController?.delegate = self
    }
    
    var decimalPointPressed = false
    
    @IBOutlet weak var graphButton: UIButton! {
        didSet {
            graphButton.setTitle("💤", for: .disabled)
            graphButton.setTitle("📈", for: .normal)
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        let digit = sender.currentTitle!
        if !decimalPointPressed  || !digit.contains(".") {
            if userIsTyping {
                let textCurrentlyInDisplay = display.text!
                display.text = textCurrentlyInDisplay + digit
            } else {
                if !brain.resultIsPending {
                    brain.description = " "
                }
                updateLogDisplay()
                display.text = digit
                userIsTyping = true
            }
            if digit.contains(".") {
                decimalPointPressed = true
            }
        }
        // print("\(brain)") // if brain implements CustomStringConvertible protocol
    }
    
    @IBAction func clearDisplay(_ sender: UIButton) {
        display.text = "0"
        decimalPointPressed = false
        userIsTyping = false
        brain.clearPendingBinaryOperation()
        updateLogDisplay()
    }
    
    func updateLogDisplay() {
        logDisplay.text = brain.description
    }
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    private var graphIsPossible: Bool { return !brain.resultIsPending }
    
    @IBAction func performOperation(_ sender: UIButton) {
        if userIsTyping {
            brain.setOperand(displayValue)
            userIsTyping = false
            decimalPointPressed = false
        }
        
        brain.performOperation(sender.currentTitle!)
        updateLogDisplay()
        // print("brain is \(brain)") // uncomment this if CalculatorBrain implements CustomStringConvertible protocol
        displayValue = brain.result
        graphButton.isEnabled = graphIsPossible
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
            
            destinationViewController.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
            destinationViewController.navigationItem.leftItemsSupplementBackButton = true
        }
        
        if let identifier = segue.identifier {
            switch identifier {
            case "Show Graph":
                if let graphViewController = destinationViewController as? TwoDimensionalGraphingViewController {
                    graphViewController.navigationItem.title = brain.description
                    graphViewController.graphDescription = brain.description
                    graphViewController.graphResult = brain.result
                }
            default: break
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        switch identifier {
        case "Show Graph":
            return !brain.resultIsPending
        default:
            return false
        }
    }
}

