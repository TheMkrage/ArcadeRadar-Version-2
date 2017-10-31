//
//  AddArcadeViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/10/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import CoreLocation

class AddArcadeViewController: FormViewController {
    
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    
    var initialArcade: Arcade?
    var currentLocation: CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createButton.backgroundColor = Colors.yesColor
        self.createButton.titleLabel?.addTextSpacing()
        self.createButton.layer.cornerRadius = 15
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
        self.nameTextField.returnKeyType = .next
        
        self.phoneNumberTextField.returnKeyType = .next
        self.phoneNumberTextField.keyboardType = .phonePad
        
        self.websiteTextField.returnKeyType = .next
        self.websiteTextField.keyboardType = .URL
        
        self.addressTextField.returnKeyType = .done
        if let initialArcade = initialArcade {
            self.nameTextField.text = initialArcade.name
            self.phoneNumberTextField.text = initialArcade.phoneNumber
            self.websiteTextField.text = initialArcade.website
            self.websiteTextField.returnKeyType = .done
            self.addressTextField.tag = 0
            self.addressTextField.isHidden = true
            self.addressLabel.isHidden = true
            self.createButton.setTitle("SAVE", for: .normal)
        }
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func completedForm() {
        super.completedForm()
        if let initialArcade = initialArcade {
            initialArcade.name = self.nameTextField.text
            initialArcade.phoneNumber = self.phoneNumberTextField.text
            initialArcade.website = self.websiteTextField.text
            ArcadeSession.shared.update(arcade: initialArcade)
        } else {
            let arcade = Arcade()
            arcade.name = self.nameTextField.text
            arcade.phoneNumber = self.phoneNumberTextField.text
            arcade.website = self.websiteTextField.text
            arcade.address = self.addressTextField.text
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(arcade.address ?? "") { (placemarks, error) in
                if let placemarks = placemarks, let location = placemarks.first?.location {
                    arcade.latitude = location.coordinate.latitude
                    arcade.longitude = location.coordinate.longitude
                } else {
                    print(placemarks)
                    print(error?.localizedDescription)
                    arcade.latitude = self.currentLocation?.latitude
                    arcade.longitude = self.currentLocation?.longitude
                }
                ArcadeSession.shared.add(arcade: arcade)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func addArcade(_ sender: Any) {
        self.completedForm()
    }
}
