//
//  BlinkingFaceViewController.swift
//  FaceIt
//
//  Created by Cory Steers on 11/13/17.
//  Copyright © 2017 Cory Steers. All rights reserved.
//

import UIKit

class BlinkingFaceViewController: FaceViewController {
    var blinking = false {
        didSet {
            blinkIfNeeded()
        }
    }
    
    private var canBlink = false
    private var inABlink = false
    
    private struct BlinkRate {
        static let closedDuration: TimeInterval = 0.4
        static let openDuration: TimeInterval = 2.5
    }
    
    private func blinkIfNeeded() {
        if blinking && canBlink && !inABlink {
            faceView.eyesOpen = false
            inABlink = true
            Timer.scheduledTimer(withTimeInterval: BlinkRate.closedDuration, repeats: false) { [weak self] timer in
                self?.faceView.eyesOpen = true
                Timer.scheduledTimer(withTimeInterval: BlinkRate.openDuration, repeats: false) { [weak self] timer in
                    self?.inABlink = false
                    self?.blinkIfNeeded()
                }
            }
        }
    }
    
    override func updateUI() {
        super.updateUI()
        blinking = expression.eyes == .squinting
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        canBlink = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canBlink = false
    }
}
