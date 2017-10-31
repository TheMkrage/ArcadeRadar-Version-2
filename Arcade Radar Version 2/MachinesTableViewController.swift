//
//  MachinesTableViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/18/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import Presentr

class MachinesTableViewController: UITableViewController {

    var machines: [ArcadeMachine] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MachineTab") as? MachineTabViewController else {
            return
        }
        vc.machine = self.machines[indexPath.row]
        vc.view.backgroundColor = UIColor.white
        vc.view.layer.borderWidth = 0
        let presentr = Presentr(presentationType: .custom(width: .sideMargin(value: 25), height: .fluid(percentage: 0.8), center: .center))
        let navigationController = UINavigationController(rootViewController: vc)
        self.customPresentViewController(presentr, viewController: navigationController, animated: true, completion: nil)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return machines.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = self.machines[indexPath.row].name
        return cell
    }

}
