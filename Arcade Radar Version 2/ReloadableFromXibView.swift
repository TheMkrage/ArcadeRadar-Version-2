//
//  ReloadableFromXibView.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/16/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

class ReloadableFromXibView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
        setupView()
    }
    
    // MARK: - Private Helper Method
    // Performs the initial setup.
    private func setupView() {
        self.backgroundColor = UIColor.clear
        let view = viewFromNibForClass()
        view.frame = bounds
        view.addHeavyBlurEffect()
        // Auto-layout stuff.
        view.autoresizingMask = [
            UIViewAutoresizing.flexibleWidth,
            UIViewAutoresizing.flexibleHeight
        ]
        
        // Show the view.
        addSubview(view)
    }
    
    // Loads a XIB file into a view and returns this view.
    private func viewFromNibForClass() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        if let view = nib.instantiate(withOwner: self, options: nil).first as? UIView {
            return view
        }
        return UIView()
    }

}
