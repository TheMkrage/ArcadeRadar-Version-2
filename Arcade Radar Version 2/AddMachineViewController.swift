//
//  AddMachineViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/18/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import DropDown

class AddMachineViewController: FormViewController {
    var initialMachine: ArcadeMachine?
    var arcade: RateableLocation!
    var searchDropDown = DropDown()
    var isLoadingNewResults = false
    var machineTypes = [ArcadeMachineType]()
    var addMachineDelegate: MachineAddedDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createButton.backgroundColor = Colors.yesColor
        self.createButton.titleLabel?.addTextSpacing()
        self.createButton.layer.cornerRadius = 15
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        
        self.nameTextField.returnKeyType = .next
        self.priceTextField.returnKeyType = .done
        self.nameTextField.delegate = self
        
        if let initialMachine = initialMachine {
            self.nameTextField.text = initialMachine.name
            self.priceTextField.text = initialMachine.pricePerPlayString ?? ""
            self.createButton.setTitle("SAVE", for: .normal)
        }
        
        
        self.nameTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.searchDropDown.direction = .bottom
        self.searchDropDown.anchorView = self.nameTextField
        self.searchDropDown.bottomOffset = CGPoint(x: 0, y: 30)
        self.searchDropDown.dataSource = [""]
        self.searchDropDown.selectionAction = { (index, selectedString) in
            self.nameTextField.text = selectedString
        }
    }
    
    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func completedForm() {
        if let initialMachine = initialMachine {
            initialMachine.name = self.nameTextField.text
            initialMachine.pricePerPlayString = self.priceTextField.text
            MachineSession.shared.update(machine: initialMachine)
        } else {
            let machine = ArcadeMachine()
            machine.createdAt = Date()
            machine.lastSeen = Date()
            machine.name = self.nameTextField.text
            machine.pricePerPlayString = self.priceTextField.text
            machine.arcadeId = arcade.objectId
            machine.latitude = arcade.latitude
            machine.longitude = arcade.longitude
            machine.objectId = MachineSession.shared.add(machine: machine)
            addMachineDelegate?.added(machineWithId: machine.objectId)
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "mapRefresh"), object: nil)
        self.dismiss(animated: true, completion: {
            super.completedForm()
        })
    }
    
    @IBAction func addMachine(_ sender: Any) {
        self.completedForm()
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        isLoadingNewResults = true
        SearchSession.shared.search(forMachineType: text) { (machine) in
            if self.isLoadingNewResults {
                self.isLoadingNewResults = false
                self.searchDropDown.dataSource = [text]
                self.machineTypes = []
            }
            DispatchQueue.main.async {
                self.machineTypes.append(machine)
                self.searchDropDown.dataSource.append(machine.name)
                self.searchDropDown.reloadAllComponents()
            }
        }
    }
    
    override func endEditing() {
        super.endEditing()
        self.view.endEditing(true)
        self.searchDropDown.hide()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchDropDown.dataSource = [""]
        self.searchDropDown.show()
        self.searchDropDown.reloadAllComponents()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.searchDropDown.hide()
    }
}
