//
//  MachineProfileViewController.swift
//  Arcade Radar Version 2
//
//  Created by Matthew Krager on 8/5/17.
//  Copyright © 2017 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit
import Presentr

class MachineProfileViewController: LocationTrackingViewController, ReportViewDelegate {

    @IBOutlet var machineLabel: UILabel!
    @IBOutlet var initiallySeenLabel: UILabel!
    @IBOutlet var lastSeenLabel: UILabel!
    @IBOutlet var reportView: ReportView!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var compassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reportView.learnMoreButton.isHidden = true
        self.reportView.isDisplayingArcades = false
        self.reportView.delegate = self
        let machine = (self.tabBarController as! MachineTabViewController).machine!
        if let isFound = ReportSaver.shared.currentReportFor(id: machine.objectId) {
            // simulate buttons being pressed when loading from file
            if isFound {
                self.reportView.yesButtonPressed(self.reportView.yesButton)
            } else {
                self.reportView.noButtonPressed(self.reportView.noButton)
            }
        }
        self.view.addBlurEffect()
        self.view.layer.cornerRadius = 25.0
        self.view.layer.borderColor = UIColor.gray.cgColor
        self.view.layer.borderWidth = 2.0
        self.updateLabels()
        
    }
    
    func updateLabels() {
        let machine = (self.tabBarController as! MachineTabViewController).machine!
        if machine.pricePerPlayString == "" {
            self.priceLabel.text = "Unknown Price"
        } else {
            self.priceLabel.text = machine.pricePerPlayString ?? "Unknown Price"
        }
        self.machineLabel.text = machine.name
        self.initiallySeenLabel.text = "Discovered on \(machine.createdAt?.getFormattedDate() ?? "")"
        self.lastSeenLabel.text = "Last Seen on \(machine.lastSeen?.getFormattedDate() ?? "")"
    }
    
    @IBAction func bringToMapButton(sender: AnyObject) {
        // Give the user direction in Maps
        let machine = (self.tabBarController as! MachineTabViewController).machine!
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: machine.geoPoint, addressDictionary:nil))
        mapItem.name = machine.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }
    
    @IBAction func bringToArcade(sender: UIButton) {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ArcadeTabProfile") as? ArcadeTabViewController else {
            return
        }
        guard let machine = (self.tabBarController as? MachineTabViewController)?.machine, let arcadeId = machine.arcadeId else {
            return
        }
        ArcadeSession.shared.get(byId: arcadeId) { (arcade) in
            guard let arcade = arcade else {
                return
            }
            vc.arcade = arcade
            vc.view.backgroundColor = UIColor.white
            // if the root view controller is a browse vc, then use presentr, if not, then just push normally
            if self.isInRootNavigation() {
                let navigationController = UINavigationController(rootViewController: vc)
                
                let presentr = Presentr(presentationType: .custom(width: .sideMargin(value: 25), height: .fluid(percentage: 0.8), center: .center))
                self.customPresentViewController(presentr, viewController: navigationController, animated: true, completion: nil)
            } else {
                self.show(vc, sender: self)
            }
        }
    }
    
    @IBAction func editButton(_ sender: Any) {
        guard let machine = (self.tabBarController as? MachineTabViewController)?.machine else {
            return
        }
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewMachine") as? AddMachineViewController else {
            return
        }
        let presentr = Presentr(presentationType: .popup)
        
        let location = Arcade()
        location.latitude = machine.latitude
        location.longitude = machine.longitude
        vc.arcade = location
        vc.formCompletedDelegate = self
        vc.initialMachine = machine
        let nav = UINavigationController(rootViewController: vc)
        self.customPresentViewController(presentr, viewController: nav, animated: true, completion: nil)
    }
    
    @IBAction func swipeDown(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeArcadeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    func reportStatusChanged(to result: Bool) {
        guard let machine = (self.tabBarController as? MachineTabViewController)?.machine else {
            return
        }
        let reportStatus = ReportSaver.shared.saveIfNeeded(id: machine.objectId, isFound: result)
        switch reportStatus {
        case .wasNotPresent:
            if result {
                machine.finds = machine.finds + 1
                machine.lastSeen = Date()
            } else {
                machine.notFinds = machine.notFinds + 1
            }
        case .wentFromNoToYes:
            machine.finds = machine.finds + 1
            machine.notFinds = machine.notFinds - 1
            machine.lastSeen = Date()
        case .wentFromYesToNo:
            machine.finds = machine.finds - 1
            machine.notFinds = machine.notFinds + 1
        default: break
        }
        
        self.reportView.finds = (machine.finds)!
        self.reportView.notFinds = (machine.notFinds)!
        ReportSession.shared.report(rateableLocation: machine, isDisplayingArcade: false)
        self.lastSeenLabel.text = "Last Seen on \(machine.lastSeen?.getFormattedDate() ?? "")"
    }

    func learnMorePressed() { }
    
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        super.locationManager(manager, didUpdateLocations: locations)
        let machine = (self.tabBarController as! MachineTabViewController).machine!
        if let distancesInMeters = self.lastLocation?.distance(from: CLLocation(latitude: machine.latitude, longitude: machine.longitude)).rounded() {
            let distanceInMiles = (distancesInMeters * 0.000621371).roundTo(places: 2)
            self.distanceLabel.text = "\(distanceInMiles) mi"
        }
    }
    
    override func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        super.locationManager(manager, didUpdateHeading: newHeading)
        let machine = (self.tabBarController as! MachineTabViewController).machine!
        let location = CLLocation(latitude: machine.latitude, longitude: machine.longitude)
        let currentBearing = lastLocation?.bearingToLocationRadian(location).radiansToDegrees ?? 0
        let currentHeading = lastHeading?.trueHeading ?? 0
        let angle = currentBearing - CGFloat(currentHeading)
        UIView.animate(withDuration: 0.35) {
            self.compassButton.transform = CGAffineTransform(rotationAngle: angle.degreesToRadians)
        }
    }
}

extension MachineProfileViewController: FormCompletedDelegate {
    func completedForm() {
        self.updateLabels()
    }
}
