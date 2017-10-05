//
//  TwoDimensionalGraphingViewController.swift
//  Calculator
//
//  Created by Cory Steers on 7/10/17.
//  Copyright © 2017 Cory Steers. All rights reserved.
//

import UIKit

class TwoDimensionalGraphingViewController: UIViewController, GraphViewDataSourceFunction {
    
    
    @IBOutlet weak var twoDimensionalGraphingView: TwoDimensionalGraphingView! {
        didSet {
            twoDimensionalGraphingView.dataSourceFunction = self
            
            let pinchHandler = #selector(TwoDimensionalGraphingView.changeScale(byReactingTo:))
            let pinchRecognizer = UIPinchGestureRecognizer(target: twoDimensionalGraphingView, action: pinchHandler)
            twoDimensionalGraphingView.addGestureRecognizer(pinchRecognizer)
            
            let doubleTapHandler = #selector(moveGraphFocus(byReactingTo:))
            let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: doubleTapHandler)
            doubleTapRecognizer.numberOfTapsRequired = 2
            twoDimensionalGraphingView.addGestureRecognizer(doubleTapRecognizer)

            let singleTapHandler = #selector(resetGraph(byReactingTo:))
            let singleTapRecognizer = UITapGestureRecognizer(target: self, action: singleTapHandler)
            singleTapRecognizer.numberOfTapsRequired = 1
            singleTapRecognizer.require(toFail: doubleTapRecognizer)
            twoDimensionalGraphingView.addGestureRecognizer(singleTapRecognizer)
            
            let panHandler = #selector(panGraphFocus(byReactingTo:))
            let panRecognizer = UIPanGestureRecognizer(target: self, action: panHandler)
            panRecognizer.minimumNumberOfTouches = 1
            panRecognizer.maximumNumberOfTouches = 1
            twoDimensionalGraphingView.addGestureRecognizer(panRecognizer)
            
//            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(increaseHappiness))
//            swipeUpRecognizer.direction = .up
//            faceView.addGestureRecognizer(swipeUpRecognizer)

//            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(decreaseHappiness))
//            swipeDownRecognizer.direction = .down
//            faceView.addGestureRecognizer(swipeDownRecognizer)
            
            updateUI()
        }
    }
    
//    var calculatorBrain = CalculatorBrain()
    
    var graphDescription: String? = nil
    var graphResult: Double? = nil
    
    var twoDimenionalGraphingModel = TwoDimensionalGraphingModel(graphStart: GraphStart(x: 187.5, y: 333.5), rectStart: RectangleStart(x: 0, y: 146), scale: 50.0) {
        didSet { updateUI() }
    }
    
    private func updateUI() {
        twoDimensionalGraphingView?.scale = CGFloat(twoDimenionalGraphingModel.scale)
        let start = twoDimenionalGraphingModel.graphStart
        twoDimensionalGraphingView?.setGraphStart(x: start.x, y: start.y)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // not sure I need this ...
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findNewGraphCenter(tapLocation location: CGPoint) -> CGPoint {
        let xOffset = CGFloat(twoDimenionalGraphingModel.graphStart.x) - location.x
        let yOffset = CGFloat(twoDimenionalGraphingModel.graphStart.y) - location.y
        let newGraphCenter = CGPoint(x: CGFloat(twoDimenionalGraphingModel.graphStart.x) + xOffset,
                                     y: CGFloat(twoDimenionalGraphingModel.graphStart.y) + yOffset)
        return newGraphCenter
    }

    func moveGraphFocus(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let newGraphCenter = findNewGraphCenter(tapLocation: tapRecognizer.location(in: twoDimensionalGraphingView))
            twoDimenionalGraphingModel = rebuildModel(center: newGraphCenter)
        }
    }
    
    func resetGraph(byReactingTo tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == .ended {
            let center = twoDimensionalGraphingView?.findGraphCenter()
            twoDimenionalGraphingModel = rebuildModel(center: center!)
        }
    }
    
    var panXstart: CGFloat?
    var panYstart: CGFloat?
    
    func panGraphFocus(byReactingTo panRecognizer: UIPanGestureRecognizer) {
        switch panRecognizer.state {
        case .began:
            let point = panRecognizer.location(in: twoDimensionalGraphingView)
            panXstart = point.x
            panYstart = point.y
        case .ended:
            let panEndLocation = panRecognizer.location(in: twoDimensionalGraphingView)
            guard let xStart = panXstart else { return }
            guard let yStart = panYstart else { return }
            
            let panXdelta = xStart - panEndLocation.x
            let panYdelta = yStart - panEndLocation.y
            let oldGraphCenter = twoDimenionalGraphingModel.graphStart
            let newGraphCenter = CGPoint(x: (CGFloat(oldGraphCenter.x) - panXdelta), y: (CGFloat(oldGraphCenter.y) - panYdelta))
            twoDimenionalGraphingModel = rebuildModel(center: newGraphCenter)
            
            panXstart = nil
            panYstart = nil
        default:
            break
        }
    }
    
    internal func calculateYforX(sender: TwoDimensionalGraphingView, x: CGFloat) -> CGFloat? {
//        brain.variableValues["M"] = Double(x)
//        return CGFloat(calculatorBrain.result)
        return CGFloat(graphResult ?? 0.0)
    }

    private func rebuildModel(center: CGPoint) -> TwoDimensionalGraphingModel {
        let tempModel = twoDimenionalGraphingModel
        let start = GraphStart(x: Float(center.x), y: Float(center.y))
        return TwoDimensionalGraphingModel(graphStart: start, rectStart: tempModel.rectStart, scale: 50.0, memory: tempModel.memory, log: tempModel.log)
    }
}
