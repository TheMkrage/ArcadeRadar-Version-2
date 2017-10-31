//
//  UIViewControllerExtension.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/2/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import Presentr

extension UIViewController {

    func alert(title: String, message: String) {
        let alertVC = Presentr.alertViewController(title: title, body: message)
        alertVC.addAction(AlertAction(title: "Awesome", style: .default, handler: nil))
        let presentr = Presentr(presentationType: .alert)
        if let presented = self.presentedViewController {
            presented.customPresentViewController(presentr, viewController: alertVC, animated: true, completion: nil)
        } else {
            self.customPresentViewController(presentr, viewController: alertVC, animated: true, completion: nil)
        }
    }
    
    func alert(title: String, message: String, alertTitle: String, handler: (() -> Void)?) {
        let alertVC = Presentr.alertViewController(title: title, body: message)
        alertVC.addAction(AlertAction(title: alertTitle, style: .default, handler: handler))
        let presentr = Presentr(presentationType: .alert)
        if let presented = self.presentedViewController {
            presented.customPresentViewController(presentr, viewController: alertVC, animated: true, completion: nil)
        } else {
            self.customPresentViewController(presentr, viewController: alertVC, animated: true, completion: nil)
        }
    }
    
    func isInRootNavigation() -> Bool {
        var toReturn = false
        // no navigation means it is in root nav (or should be treated so)
        guard let vcs = self.navigationController?.viewControllers else {
            return true
        }
        for vc in vcs {
            if (vc as? NewsMenuViewController) != nil {
                toReturn = true
            }
        }
        return toReturn
    }
}
