//
//  TwoDimensionalGraphingModel.swift
//  Calculator
//
//  Created by Cory Steers on 7/10/17.
//  Copyright © 2017 Cory Steers. All rights reserved.
//

import Foundation

struct TwoDimensionalGraphingModel {
    
    init(graphStart: GraphStart, rectStart: RectangleStart, scale: Float) {
        self.init(graphStart: graphStart, rectStart: rectStart, scale: scale, memory: 0.0, log: "")
    }
    
    init(graphStart: GraphStart, rectStart: RectangleStart, scale: Float, memory: Double, log: String) {
        self.graphStart = graphStart
        self.rectStart = rectStart
        self.scale = scale
        self.memory = memory
        self.log = log
    }
    
//    struct RectangleGraph {
//        var originX: Float
//        var originY: Float
//        var sizeWidth: Float
//        var sizeHeight: Float
//    }
    
    let graphStart: GraphStart
    let rectStart: RectangleStart
//    let rectGraph: RectangleGraph
//    let graphSize: Float

    let scale: Float
    let memory: Double
    let log: String
}

struct GraphStart {
    var x: Float
    var y: Float
}

struct RectangleStart {
    var x: Float
    var y: Float
}

