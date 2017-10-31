//
//  XpProgressView.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/2/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

class XpProgressView: UIProgressView {
    
    override func setProgress(_ progress: Float, animated: Bool) {
        UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveLinear, animations: {
            super.setProgress(progress, animated: animated)
        })
        
    }
    
    func setProgress(_ progress: Float, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: 1.5, delay: 0.0, options: .curveEaseOut, animations: {
            super.setProgress(progress, animated: true)
        }, completion: { (isCompleted) -> Void in
            completion(isCompleted)
        })
    }
    
    
}
