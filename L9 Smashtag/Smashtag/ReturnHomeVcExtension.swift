//
//  ReturnHomeVcExtension.swift
//  Smashtag
//
//  Created by Cory Steers on 1/9/18.
//  Copyright © 2018 Stanford University. All rights reserved.
//

import UIKit

extension UIViewController {

    @objc func returnHome() {
        self.dismiss(animated: true, completion: {});
        self.navigationController?.popViewController(animated: true);
        
        if let controllers = self.navigationController?.viewControllers {
            self.navigationController?.popToViewController(controllers[0], animated: true)
        }
    }
        
    func addReturnHome() {
        let returnButton = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(returnHome))
        var rightBarButtons: [UIBarButtonItem] = navigationItem.rightBarButtonItems ?? []
        rightBarButtons.append(returnButton)
        
        navigationItem.rightBarButtonItems = rightBarButtons
    }
}
