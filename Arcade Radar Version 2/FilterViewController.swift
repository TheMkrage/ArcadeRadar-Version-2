//
//  FilterViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/10/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import DropDown

protocol FilterDelegate: class {
    func filter(to arcades: Bool)
    func filter(with searchQuery: String?, machineId: String?)
}

class FilterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var searchField: UITextField!
    @IBOutlet var searchStringLabel: UILabel!
    @IBOutlet var segmentedControl: UISegmentedControl!
    var searchDropDown = DropDown()
    var isLoadingNewResults = false
    var machineTypes = [ArcadeMachineType]()
    weak var filterDelegate: FilterDelegate?
    
    var isDisplayingArcade = true
    var searchBarInitialText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let normalTextAttributes: [String : AnyObject]? = [
            NSKernAttributeName: 1.2 as AnyObject,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 12.0)
        ]
        self.segmentedControl.tintColor = Colors.yesColor
        self.segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .normal)
        self.segmentedControl.setTitleTextAttributes(normalTextAttributes, for: .selected)
        self.searchField.delegate = self
        
        self.searchDropDown.anchorView = self.searchField
        self.searchDropDown.bottomOffset = CGPoint(x: 0, y: 25)
        self.searchDropDown.dataSource = [""]
        self.searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        self.searchDropDown.selectionAction = { (index, selectedString) in
            self.searchField.text = selectedString
            if index == 0 {
                self.filterDelegate?.filter(with: selectedString, machineId: nil)
            } else {
                // - 1 because index 0 is just what the user is currently typing
                self.filterDelegate?.filter(with: selectedString, machineId: self.machineTypes[index - 1].objectId)
            }
        }
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        segmentedControl.selectedSegmentIndex = self.isDisplayingArcade ? 0 : 1
        searchField.text = self.searchBarInitialText
        // unhide what is needed for machine searching
        if segmentedControl.selectedSegmentIndex == 0 {
            searchField.isHidden = true
            searchStringLabel.isHidden = true
        } else {
            searchField.isHidden = false
            searchStringLabel.isHidden = false
        }
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.searchField.isHidden = true
            self.searchStringLabel.isHidden = true
        } else {
            self.searchField.isHidden = false
            self.searchStringLabel.isHidden = false
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if self.segmentedControl.selectedSegmentIndex == 0 {
            self.searchField.isHidden = true
            self.searchStringLabel.isHidden = true
        } else {
            self.searchField.isHidden = false
            self.searchStringLabel.isHidden = false
        }
        self.filterDelegate?.filter(to: sender.selectedSegmentIndex == 0) 
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        self.filterDelegate?.filter(with: text, machineId: nil)
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func endEditing() {
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
