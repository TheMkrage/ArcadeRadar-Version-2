//
//  AddCommentViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/8/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit

protocol AddCommentDelegate: class {
    func commentEditingDidEndEditing(withTitle: String, text: String)
}

class AddCommentViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var titleField: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet var submitButton: UIButton!
    weak var delegate: AddCommentDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitButton.backgroundColor = Colors.yesColor
        self.submitButton.titleLabel?.addTextSpacing()
        self.submitButton.layer.cornerRadius = 15
        
        self.textView.delegate = self
        self.textView.layer.cornerRadius = 1
        self.textView.layer.borderWidth = 1
        self.textView.layer.borderColor = UIColor.darkGray.cgColor
        self.titleField.becomeFirstResponder()
    }

    @IBAction func hitSubmit() {
        self.delegate?.commentEditingDidEndEditing(withTitle: titleField.text ?? "Title", text: textView.text)
        self.dismiss(animated: true, completion: nil)
    }
}
