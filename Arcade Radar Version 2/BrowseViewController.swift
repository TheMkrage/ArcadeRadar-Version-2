//
//  BrowseViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 7/12/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import CoreLocation
import Presentr
import JGProgressHUD

class BrowseViewController: LocationTrackingViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var searchController: UISearchController!
    var arcades: [Arcade] = [Arcade]()
    var filteredArcades: [Arcade] = [Arcade]()
    var hasRequestedLoadForCurrentLocation = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search For Arcades"
        definesPresentationContext = true
        //tableView.tableHeaderView = searchController.searchBar
        //searchController.searchBar.delegate = self
        //searchController.delegate = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.reloadData()
    }
    
    func isSearching() -> Bool {
        return self.searchController.isActive && !(self.searchController.searchBar.text?.isEmpty ?? true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArcadeTabProfile") as? ArcadeTabViewController else {
            return
        }
        vc.view.backgroundColor = vc.view.backgroundColor?.withAlphaComponent(1)
        vc.arcade = self.arcades[indexPath.row]
        // 92 is for the top bar and status and search
        let presentr = Presentr(presentationType: .custom(width: ModalSize.custom(size: Float(self.view.frame.width)), height: ModalSize.custom(size: Float(self.view.frame.height) - 108), center: ModalCenterPosition.custom(centerPoint: CGPoint(x: self.view.center.x, y: self.view.center.y + 54))))
        presentr.backgroundColor = UIColor.clear
        presentr.backgroundOpacity = 0.0
        presentr.roundCorners = true
        presentr.cornerRadius = 25.0
        self.customPresentViewController(presentr, viewController: vc, animated: true) {
            //self.mapView.deselectAnnotation(annotation, animated: false)
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "BrowseArcadeTableViewCell") as? BrowseArcadeTableViewCell else {
            return UITableViewCell()
        }
        var arcade = Arcade()
        if self.isSearching() && self.filteredArcades.count > indexPath.row {
            arcade = self.filteredArcades[indexPath.row]
        } else if !self.isSearching() && self.arcades.count > indexPath.row {
            arcade = self.arcades[indexPath.row]
        } else {
            return UITableViewCell()
        }
        let location = CLLocation(latitude: arcade.latitude, longitude: arcade.longitude)
        
        let currentBearing = lastLocation?.bearingToLocationRadian(location).radiansToDegrees ?? 0
        let currentHeading = lastHeading?.trueHeading ?? 0
        
        cell.setRotation(angle: currentBearing - CGFloat(currentHeading))
        cell.arcadeNameLAbel.text = arcade.name
        cell.gameLabel.text = "\(arcade.machineIds?.count ?? 0) Games"
        if let distancesInMeters = self.lastLocation?.distance(from: CLLocation(latitude: arcade.latitude, longitude: arcade.longitude)).rounded() {
            let distanceInMiles = (distancesInMeters * 0.000621371).roundTo(places: 2)
            cell.distanceLabel.text = "\(distanceInMiles) mi"
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        self.arcades.sort { (arcadeLH, arcadeRH) -> Bool in
            guard let distLH = self.lastLocation?.distance(from: CLLocation(latitude: arcadeLH.latitude, longitude: arcadeLH.longitude)).rounded(), let distRH = self.lastLocation?.distance(from: CLLocation(latitude: arcadeRH.latitude, longitude: arcadeRH.longitude)).rounded() else {
                return false
            }
            return distLH < distRH
        }
        self.filteredArcades.sort { (arcadeLH, arcadeRH) -> Bool in
            guard let distLH = self.lastLocation?.distance(from: CLLocation(latitude: arcadeLH.latitude, longitude: arcadeLH.longitude)).rounded(), let distRH = self.lastLocation?.distance(from: CLLocation(latitude: arcadeRH.latitude, longitude: arcadeRH.longitude)).rounded() else {
                return false
            }
            return distLH < distRH
        }

        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.isSearching() ? self.filteredArcades.count : self.arcades.count
    }
    
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        super.locationManager(manager, didUpdateLocations: locations)
        if !hasRequestedLoadForCurrentLocation {
            if let location = lastLocation {
                hasRequestedLoadForCurrentLocation = true
                let seCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude - 0.25, longitude: location.coordinate.longitude + 0.25)
                let nwCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude + 0.25, longitude: location.coordinate.longitude - 0.25)
                let progress = JGProgressHUD(style: .extraLight)
                progress?.show(in: self.tableView)
                LocationSession.shared.getArcadesInsideOf(seCoord: seCoord, nwCoord: nwCoord, childAddedResponse: { (arcade) in
                    progress?.dismiss(animated: true)
                    let arcade = arcade
                    self.arcades.append(arcade)
                    self.tableView.reloadData()
                })
            }
            
        }
    }
    
    override func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        super.locationManager(manager, didUpdateHeading: newHeading)
        if !self.isSearching() || (self.isSearching() && self.filteredArcades.count != 0) {
            self.tableView.reloadData()
        }
    }
}

extension BrowseViewController: UISearchBarDelegate {
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = self.searchController.searchBar.text else {
            return
        }
        self.filteredArcades = [Arcade]()
        let progress = JGProgressHUD(style: .extraLight)
        progress?.show(in: self.tableView)
        SearchSession.shared.search(forArcade: text, completionHandler: { (arcade) in
            progress?.dismiss()
            let arcade = arcade
            arcade.longitude = -arcade.longitude
            self.filteredArcades.append(arcade)
            
            self.tableView.reloadData()
        })
    }
}

extension BrowseViewController: UISearchControllerDelegate {
    // MARK: - UISearchControllerDelegate
    func willDismissSearchController(_ searchController: UISearchController) {
        self.tableView.reloadData()
    }
}
