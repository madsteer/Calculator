//
//  TwoDimenionGraphingView.swift
//  Calculator
//
//  Created by Cory Steers on 7/10/17.
//  Copyright © 2017 Cory Steers. All rights reserved.
//

import UIKit

protocol GraphViewDataSourceFunction: class {
    func calculateYforX(sender: TwoDimensionalGraphingView, x: CGFloat) -> CGFloat?
}

@IBDesignable
class TwoDimensionalGraphingView: UIView {
    
    private struct Constants {
        static let xIncrementSize: CGFloat = 1
        static let graphColor = UIColor.black
        static let contentScaleFactor = CGFloat(3)
    }

    weak var dataSourceFunction:GraphViewDataSourceFunction?

    private var drawer = AxesDrawer(color: Constants.graphColor, contentScaleFactor: Constants.contentScaleFactor)
    
    @IBInspectable
    var scale: CGFloat = 50.0 { didSet{ setNeedsDisplay() } }
    
    private var graphSize: CGFloat = 375 { didSet{ setNeedsDisplay() } }

    private var graphStart = CGPoint(x: 187.5, y: 333.5) { didSet{ setNeedsDisplay() } }

    private var rectStart = CGPoint (x: 0, y: 146) { didSet{ setNeedsDisplay() } }

    private var graphRectangle =  CGRect(origin: CGPoint(x: 0, y: 146), size: CGSize(width: 375, height: 375)) { didSet{ setNeedsDisplay() } }
    
    private func isVerticalOrientation() -> Bool {
        return bounds.size.width < bounds.size.height
    }
    
//    private func pathForGraphRegion() -> UIBezierPath {
//        let path = UIBezierPath(rect: graphRectangle)
//        return path
//    }
    
    func findGraphSize() -> CGFloat {
        return min(bounds.size.width, bounds.size.height)
    }
    
    func findGraphCenter() -> CGPoint {
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    func setGraphStart(x: Float, y: Float) {
        graphStart = CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
    
    private func findRectStart() -> CGPoint {
        var x: CGFloat = 0.0
        var y: CGFloat = 0.0
        
        if(isVerticalOrientation()) {
            y = (bounds.size.height / 2) - (bounds.size.width / 2)
        } else {
            x = (bounds.size.width / 2) - (bounds.size.height / 2)
        }
        
        return CGPoint(x: x, y: y)
    }
    
    private func findGraphRectangle() -> CGRect {
        return CGRect(origin: rectStart, size: CGSize(width: graphSize, height: graphSize))
    }
    
    private func changeToBrainCoordinate(xToDraw: CGFloat, origin: CGPoint, pointsPerUnit: CGFloat) -> CGFloat {
        return (xToDraw - origin.x) / pointsPerUnit
    }
    
    private func changeToCoordinateToDraw(y: CGFloat, origin: CGPoint, pointsPerUnit: CGFloat) -> CGFloat {
        return -((y * pointsPerUnit) - origin.y)
    }

    private func align(coordinate: CGFloat) -> CGFloat {
        return round(coordinate * contentScaleFactor) / contentScaleFactor
    }
    
    private func drawResultIn(rect bounds: CGRect, at origin: CGPoint, resizedTo pointsPerUnit: CGFloat) {
        UIGraphicsGetCurrentContext()!.saveGState()
//        color.set()
        let path = UIBezierPath()
        var xToDraw =  bounds.minX
        var firstDrawPoint = true
        while xToDraw <= bounds.maxX {
            let xBrain = changeToBrainCoordinate(xToDraw: xToDraw, origin: origin, pointsPerUnit: pointsPerUnit)
            if let yBrain = dataSourceFunction?.calculateYforX(sender: self, x: xBrain) {
                if yBrain.isNormal || yBrain.isZero {
                    let yToDraw = changeToCoordinateToDraw(y: yBrain, origin: origin, pointsPerUnit: pointsPerUnit)
                    if yToDraw <= bounds.maxY && yToDraw >= bounds.minY {
                        if firstDrawPoint {
                            path.move(to: CGPoint(x: xToDraw, y: align(coordinate: yToDraw)))
                            firstDrawPoint = false
                        } else {
                            path.addLine(to: CGPoint(x: xToDraw, y: align(coordinate: yToDraw)))
                        }
                    }
                }
            }
            xToDraw += Constants.xIncrementSize
        }
        path.stroke()
        UIGraphicsGetCurrentContext()!.restoreGState()
    }
    
    override func draw(_ rect: CGRect) {
        graphSize = findGraphSize()
        rectStart = findRectStart()
        graphRectangle =  findGraphRectangle()
        
        drawer.drawAxes(in: graphRectangle, origin: graphStart, pointsPerUnit: scale)
        if dataSourceFunction != nil {
            self.drawResultIn(rect: rect, at: graphStart, resizedTo: scale)
        }
    }
    
    func changeGraphCenter(center point: CGPoint) {
        graphStart = point
    }
    
    func changeGraphCenter() {
        changeGraphCenter(center: findGraphCenter())
    }
    
    func changeScale(byReactingTo pinchRecognizer: UIPinchGestureRecognizer) {
        switch pinchRecognizer.state {
        case .changed, .ended:
            scale *= pinchRecognizer.scale
            pinchRecognizer.scale = 1
        default:
            break
        }
    }
}
