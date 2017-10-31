//
//  ArcadeTableViewController.swift
//  Arcade Radar
//
//  Created by Matthew Krager on 5/7/16.
//  Copyright © 2016 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit
import FirebaseDatabase
import Presentr
import JGProgressHUD

protocol MachineAddedDelegate {
    func added(machineWithId id: String)
}

class ArcadeMachinesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PresentrDelegate {
    @IBOutlet weak var arcadeNameLabel: UILabel!
    var machines: [ArcadeMachine] = []
    let locationManager = CLLocationManager()

    @IBOutlet var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.table.delegate = self
        self.table.dataSource = self
        self.loadMachines()
        
        self.view.addBlurEffect()
        self.view.layer.cornerRadius = 25.0
        self.view.layer.borderColor = UIColor.gray.cgColor
        self.view.layer.borderWidth = 2.0
        
        let arcade = (self.tabBarController as! ArcadeTabViewController).arcade!
        self.arcadeNameLabel.text = arcade.name
        
        self.table.rowHeight = UITableViewAutomaticDimension
        self.table.estimatedRowHeight = 92
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    @IBAction func swipeDown(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    func loadMachines() {
        let arcade = (self.tabBarController as! ArcadeTabViewController).arcade
        guard let machineIds = arcade?.machineIds else {
            return
        }
        let progress = JGProgressHUD(style: .extraLight)
        progress?.show(in: self.view)
        for id in machineIds {
            Database.database().reference().child("machine").child(id).observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
                progress?.dismiss()
                guard let m = ArcadeMachine(snapshot: snapshot) else {
                    return
                }
                self.machines.append(m)
                self.machines.sort(by: { (m1, m2) -> Bool in
                    return m1.name < m2.name
                })
                self.table.reloadData()
            }
        }
    }
    
    @IBAction func closeArcadeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func yesButtonPressed(_ sender: UIButton) {
        let machine = self.machines[sender.tag]
        self.reportStatus(forMachine: machine, withCellRow: sender.tag, isFound: true)
    }
    
    func noButtonPressed(_ sender: UIButton) {
        let machine = self.machines[sender.tag]
        self.reportStatus(forMachine: machine, withCellRow: sender.tag, isFound: false)
    }
    
    func reportStatus(forMachine machine: ArcadeMachine, withCellRow row: Int, isFound: Bool) {
        let reportStatus = ReportSaver.shared.saveIfNeeded(id: machine.objectId, isFound: isFound)
        switch reportStatus {
        case .wasNotPresent:
            if isFound {
                machine.finds = machine.finds + 1
            } else {
                machine.notFinds = machine.notFinds + 1
            }
        case .wentFromNoToYes:
            machine.finds = machine.finds + 1
            machine.notFinds = machine.notFinds - 1
        case .wentFromYesToNo:
            machine.finds = machine.finds - 1
            machine.notFinds = machine.notFinds + 1
        default: break
            //print("Well this shouldn't happen")
        }
        guard let cell = self.table.cellForRow(at: IndexPath(row: row, section: 0)) as? ArcadeMachineTableViewCell else {
            return
            }
        cell.finds = machine.finds
        cell.notFinds = machine.notFinds
        ReportSession.shared.report(rateableLocation: machine, isDisplayingArcade: false)
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.machines.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.table.dequeueReusableCell(withIdentifier: "ArcadeMachineCell") as? ArcadeMachineTableViewCell else {
            return UITableViewCell()
        }
        cell.resetAppearance()
        let machine = self.machines[indexPath.row]
        cell.nameLabel.text = machine.name
        cell.pricePerPlayLabel.text = machine.pricePerPlayString ?? "Unknown Price"
        cell.finds = machine.finds
        cell.notFinds = machine.notFinds
        cell.yesButton.tag = indexPath.row
        cell.noButton.tag = indexPath.row
        cell.yesButton.addTarget(self, action: #selector(yesButtonPressed(_:)), for: .touchUpInside)
        cell.noButton.addTarget(self, action: #selector(noButtonPressed(_:)), for: .touchUpInside)
        if let isFound = ReportSaver.shared.currentReportFor(id: machine.objectId) {
            // simulate buttons being pressed when loading from file
            if isFound {
                cell.yesButtonPressed(cell.yesButton)
            } else {
                cell.noButtonPressed(cell.noButton)
            }
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "MachineTab") as? MachineTabViewController else {
            return
        }
        
        vc.machine = self.machines[indexPath.row]
        vc.view.backgroundColor = UIColor.white
        vc.view.layer.borderWidth = 0
        
        // if the root view controller is a browse vc, then use presentr, if not, then just push normally
        if self.isInRootNavigation() {
            let navigationController = UINavigationController(rootViewController: vc)
            
            let presentr = Presentr(presentationType: .custom(width: .sideMargin(value: 25), height: .fluid(percentage: 0.8), center: .center))
            presentr.presentrDelegate = self
            self.customPresentViewController(presentr, viewController: navigationController, animated: true, completion: nil)
        } else {
            self.show(vc, sender: self)
        }
    }

    @IBAction func addButtonPressed(_ sender: Any) {
        self.addNewArcadeMachine()
    }
    
    func addNewArcadeMachine() {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NewMachine") as? AddMachineViewController else {
            return
        }
        let presentr = Presentr(presentationType: .popup)
        let arcade = (self.tabBarController as! ArcadeTabViewController).arcade
        vc.addMachineDelegate = self
        vc.arcade = arcade
        vc.formCompletedDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.customPresentViewController(presentr, viewController: nav, animated: true, completion: nil)
    }
    
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        self.table.reloadData()
        return true
    }
}

extension ArcadeMachinesTableViewController: FormCompletedDelegate {
    func completedForm() {
        self.table.reloadData()
    }
}

extension ArcadeMachinesTableViewController: MachineAddedDelegate {
    func added(machineWithId id: String) {
        let arcade = (self.tabBarController as! ArcadeTabViewController).arcade
        arcade?.machineIds?.append(id)
        machines = []
        self.loadMachines()
    }
}
