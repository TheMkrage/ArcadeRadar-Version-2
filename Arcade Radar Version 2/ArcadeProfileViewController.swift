//
//  ArcadeProfileViewController.swift
//  Arcade Radar
//
//  Created by Matthew Krager on 6/7/16.
//  Copyright © 2016 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit
import Presentr

class ArcadeProfileViewController: LocationTrackingViewController, ReportViewDelegate {
    @IBOutlet var arcadeLabel: UILabel!
    @IBOutlet var initialDateLabel: UILabel!
    @IBOutlet var reportView: ReportView!
    @IBOutlet weak var lastVisitedLabel: UILabel!
    @IBOutlet var iconButtons: [UIButton]!
    
    @IBOutlet weak var websiteButton: UIButton!
    @IBOutlet weak var gameCountLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var compassButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reportView.learnMoreButton.isHidden = true
        self.reportView.delegate = self
        let arcade = (self.tabBarController as! ArcadeTabViewController).arcade!
        if let isFound = ReportSaver.shared.currentReportFor(id: arcade.objectId) {
            // simulate buttons being pressed when loading from file
            if isFound {
                self.reportView.yesButtonPressed(self.reportView.yesButton)
            } else {
                self.reportView.noButtonPressed(self.reportView.noButton)
            }
        }
        if arcade.website == nil || arcade.website == "" {
            self.websiteButton.isHidden = true
        }
        
        self.view.addBlurEffect()
        self.view.layer.cornerRadius = 25.0
        self.view.layer.borderColor = UIColor.gray.cgColor
        self.view.layer.borderWidth = 2.0
        updateLabels()
    }
    
    func updateLabels() {
        let arcade = (self.tabBarController as! ArcadeTabViewController).arcade!
        self.arcadeLabel.text = arcade.name
        self.gameCountLabel.text = "\(arcade.machineIds?.count ?? 0) Games"
        self.initialDateLabel.text = "Discovered on \(arcade.createdAt?.getFormattedDate() ?? "")"
        self.lastVisitedLabel.text = "Last Seen on \(arcade.lastSeen?.getFormattedDate() ?? "")"
    }

    @IBAction func bringToWebsite(sender: AnyObject) {
        let arcade = (self.tabBarController as! ArcadeTabViewController).arcade!

        if !UIApplication.shared.openURL(NSURL(string:arcade.website!)! as URL) {
            if !UIApplication.shared.openURL(NSURL(string:"https://www.\(arcade.website!)")! as URL) {
                UIApplication.shared.openURL(NSURL(string:"https://\(arcade.website!)")! as URL)
            }
        }
    }

    @IBAction func bringToMapButton(sender: AnyObject) {
        // Give the user direction in Maps
        let arcade = (self.tabBarController as! ArcadeTabViewController).arcade!
        let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: arcade.geoPoint, addressDictionary:nil))
        mapItem.name = arcade.name
        mapItem.openInMaps(launchOptions: [MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving])
    }

    @IBAction func bringToArcadeGames(sender: UIButton) {
        (self.tabBarController as! ArcadeTabViewController).selectedIndex = 1
    }
    
    @IBAction func editButton(_ sender: Any) {
        let arcade = (self.tabBarController as! ArcadeTabViewController).arcade!
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewArcade") as? AddArcadeViewController else {
            return
        }
        let presentr = Presentr(presentationType: .custom(width: .sideMargin(value: 20), height: .fluid(percentage: 0.80), center: .customOrigin(origin: CGPoint(x: 20, y: 40))))
        vc.initialArcade = arcade
        vc.formCompletedDelegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.customPresentViewController(presentr, viewController: nav, animated: true, completion: nil)
    }

    @IBAction func swipeDown(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeArcadeView(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Report View Delegate
    func learnMorePressed() {
        
    }
    
    func reportStatusChanged(to result: Bool) {
        guard let arcade = (self.tabBarController as! ArcadeTabViewController).arcade else {
            return
        }
        let reportStatus = ReportSaver.shared.saveIfNeeded(id: arcade.objectId, isFound: result)
        switch reportStatus {
        case .wasNotPresent:
            if result {
                arcade.finds = arcade.finds + 1
                arcade.lastSeen = Date()
            } else {
                arcade.notFinds = arcade.notFinds + 1
            }
        case .wentFromNoToYes:
            
            arcade.finds = arcade.finds + 1
            arcade.lastSeen = Date()
            arcade.notFinds = arcade.notFinds - 1
        case .wentFromYesToNo:
            arcade.finds = arcade.finds - 1
            arcade.notFinds = arcade.notFinds + 1
        default: break
        }
        
        self.reportView.finds = (arcade.finds)!
        self.reportView.notFinds = (arcade.notFinds)!
        ReportSession.shared.report(rateableLocation: arcade, isDisplayingArcade: true)
        self.lastVisitedLabel.text = "Last Seen on \(arcade.lastSeen?.getFormattedDate() ?? "")"
    }
    
    override func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        super.locationManager(manager, didUpdateLocations: locations)
       /* let arcade = (self.tabBarController as! ArcadeTabViewController).arcade!
        if let distancesInMeters = self.lastLocation?.distance(from: CLLocation(latitude: arcade.latitude, longitude: arcade.longitude)).rounded() {
            let distanceInMiles = (distancesInMeters * 0.000621371).roundTo(places: 2)
            self.distanceLabel.text = "\(distanceInMiles) mi"
        }*/
    }
    
    override func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        super.locationManager(manager, didUpdateHeading: newHeading)
        let arcade = (self.tabBarController as! ArcadeTabViewController).arcade!
        let location = CLLocation(latitude: arcade.latitude, longitude: arcade.longitude)
        let currentBearing = lastLocation?.bearingToLocationRadian(location).radiansToDegrees ?? 0
        let currentHeading = lastHeading?.trueHeading ?? 0
        let angle = currentBearing - CGFloat(currentHeading)
        UIView.animate(withDuration: 0.35) {
            self.compassButton.transform = CGAffineTransform(rotationAngle: angle.degreesToRadians)
        }
    }
}

extension ArcadeProfileViewController: FormCompletedDelegate {
    func completedForm() {
        self.updateLabels()
    }
}
