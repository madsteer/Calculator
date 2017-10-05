//
//  ForceMasterViewOnStartSplitViewController.swift
//  Calculator
//
//  Created by Cory Steers on 8/4/17.
//  Copyright © 2017 Cory Steers. All rights reserved.
//

/*
 found this on stack overflow:  https://stackoverflow.com/questions/29506713/open-uisplitviewcontroller-to-master-view-rather-than-detail
 It was written for Xcode 6 and presumably swift 1 ???
 The last line (@objc) is a slight modification from the Stack Overflow answer that xcode 8 provided me.
 What's not in the Stack Overflow article is that you need to
 1. go to the Main.storyboard and select the Split View Controller
 2. click the "show the identity inspector" icon in the right panel
 3. Click the right arrow next to the "Class" field and select "ForceMasterViewOnStartSplitViewController"
 that's it!!
 
 Not sure what the expected behavior is for starting the app in landscape mode on a "plus" phone or iPad.  So, this may need more tweaking for that.
 */

import UIKit

/*
 * commented this code out, as I found a more appropriate way here:  https://useyourloaf.com/blog/split-view-controller-display-modes/
 *
class ForceMasterViewOnStartSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }

    @objc(splitViewController:collapseSecondaryViewController:ontoPrimaryViewController:) func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}
 */
