//
//  CreateArcadeMachineViewController.swift
//  Arcade Radar
//
//  Created by Matthew Krager on 5/21/16.
//  Copyright © 2016 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit

class CreateArcadeMachineViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    var nameOfMachine: String = ""
    let currencies = ["Dollar(s)", "Token(s)", "Euro(s)", "Credit(s)", "Other"]

    let plays = ["Play(s)", "Song(s)", "Life/Lives", "Try/Tries", "Other"]

    @IBOutlet weak var priceTextField: UITextField!

    @IBOutlet weak var currencyTextField: UITextField!
    @IBOutlet weak var numOfPlaysTextField: UITextField!
    @IBOutlet weak var playsTextField: UITextField!
    @IBOutlet weak var arcadeTextField: UITextField!
    @IBOutlet var nameLabel: UILabel!

    @IBOutlet weak var scrollView: UIScrollView!
    var arcadeName: String?
    var location: CLLocationCoordinate2D?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.nameLabel.text = self.nameOfMachine
        self.view.backgroundColor = UIColor.darkGray
        self.scrollView.backgroundColor = UIColor.darkGray
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CreateArcadeMachineViewController.cancel))
        //priceTextField.keyboardType = .NumbersAndPunctuation
        //playsTextField.keyboardType = .NumbersAndPunctuation
        let currencyPickerView = UIPickerView()
        currencyPickerView.delegate = self

        currencyPickerView.tag = 1

        currencyTextField.inputView = currencyPickerView

        let playsPickerView = UIPickerView()

        playsPickerView.delegate = self

        playsPickerView.tag = 2

        playsTextField.inputView = playsPickerView

        if let x = self.arcadeName as String! {
            self.arcadeTextField.text = x
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        if pickerView.tag == 1 {
            return currencies.count
        } else if pickerView.tag == 2 {
            return plays.count
        }

        return 0

    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if pickerView.tag == 1 {
            return currencies[row]
        }

        if pickerView.tag == 2 {
            return plays[row]
        }

        return nil

    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        if pickerView.tag == 1 {
            if currencies[row] == "Other" {
                pickerView.endEditing(true)
                currencyTextField.inputView = nil
                currencyTextField.reloadInputViews()
            } else {
                currencyTextField.text = currencies[row]
            }
        }

        if pickerView.tag == 2 {
            if plays[row] == "Other" {
                pickerView.endEditing(true)
                playsTextField.inputView = nil
                playsTextField.reloadInputViews()
            } else {
                playsTextField.text = plays[row]
            }
        }
    }

    @IBAction func createNewMachine() {
        var newMachine = ArcadeMachine()
        newMachine.name = self.nameOfMachine
        //newMachine.arcadeName = self.arcadeTextField.text!
        //newMachine.price = Double(self.priceTextField.text!)!

        //newMachine.whatPriceIsFor = self.playsTextField.text!
        //newMachine.playsQuantity =  Int(self.numOfPlaysTextField.text!)!
        //newMachine.currency = self.currencyTextField.text!
        // get the location-
        let point = CLLocationCoordinate2D(latitude: self.location!.latitude, longitude: self.location!.longitude)
        newMachine.latitude = point.latitude
        newMachine.longitude = point.longitude
        //NotificationCenter.defaultCenter.postNotificationName("ArcadeMachineAdded", object: nil, userInfo: ["machine" : newMachine])
        //self.navigationController?.popViewControllerAnimated(true)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
