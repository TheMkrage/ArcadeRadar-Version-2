//
//  SearchForNameViewControllerTableViewController.swift
//  Arcade Radar
//
//  Created by Matthew Krager on 5/8/16.
//  Copyright © 2016 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit

class SearchForNameTableViewController: UITableViewController {

    // MARK: - Properties
    var arcadeNameForCreating: String?
    var location: CLLocationCoordinate2D?
    var isSendingToMap = true
    var filteredMachines = [ArcadeMachineType]()
    let searchController = UISearchController(searchResultsController: nil)
    var searchID = 0
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the Search Controller
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        definesPresentationContext = true
        searchController.dimsBackgroundDuringPresentation = false

        if !isSendingToMap {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(SearchForNameTableViewController.cancel))
        }
        // Setup the Scope Bar
        searchController.searchBar.scopeButtonTitles = []

        tableView.tableHeaderView = searchController.searchBar
    }

    func cancel() {
        self.dismiss(animated: true, completion: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table View
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            if self.isSendingToMap {
                return filteredMachines.count
            }
            return filteredMachines.count + 1
        }
        return 0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.isSendingToMap {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "map") as! MapViewController
            self.show(vc, sender: self)
        } else {
            let createViewController = self.storyboard?.instantiateViewController(withIdentifier: "Create") as! CreateArcadeMachineViewController
            createViewController.nameOfMachine = filteredMachines[indexPath.row].name
            createViewController.arcadeName = self.arcadeNameForCreating
            createViewController.location = self.location!
            self.show(createViewController, sender: self)
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let machine: ArcadeMachineType
        cell.textLabel?.textColor = Colors.hackerGreen
        if searchController.isActive && searchController.searchBar.text != "" && indexPath.row < self.filteredMachines.count {
            machine = filteredMachines[indexPath.row]
            cell.textLabel!.text = machine.name
        } else {

            cell.textLabel!.text = "Not Listed"
        }

        return cell
    }

    func filterContentForSearchText(searchText: String, id: Int, scope: String = "All") {
        if searchController.searchBar.text != "" {

        } else { // if not, make nothing show
            self.filteredMachines = []
            self.tableView.reloadData()
        }
    }
}

extension SearchForNameTableViewController: UISearchBarDelegate {
    // MARK: - UISearchBar Delegate
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if self.isSendingToMap {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "map") as! MapViewController
            let searchText = searchBar.text!
            let pointsArr = searchText.components(separatedBy: " ")
            var whereClause = "name LIKE '%\(searchText)%'"
            if pointsArr.count > 1 {
                for x in pointsArr {
                    if x != "" {
                        whereClause = "\(whereClause) OR name LIKE '%\(x)%'"
                    }
                }
            }
            self.show(vc, sender: self)
        }
    }
}

extension SearchForNameTableViewController: UISearchResultsUpdating {
    @available(iOS 8.0, *)
    public func updateSearchResults(for searchController: UISearchController) {

    }

    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        searchID += 1
        filterContentForSearchText(searchText: searchController.searchBar.text!, id: self.searchID)
    }
}
