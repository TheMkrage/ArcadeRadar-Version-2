//
//  ViewController.swift
//  Arcade Radar 2
//
//  Created by Matthew Krager on 12/26/15.
//  Copyright © 2015 Matthew Krager. All rights reserved.
//

import UIKit
import MapKit
import FirebaseCore
import FirebaseDatabase
import FBAnnotationClusteringSwift
import Presentr

// .004 degress is .25 miles

class MapViewController: UIViewController, CLLocationManagerDelegate, ReportViewDelegate {
    
    // Map Managers
    let clusteringManager = FBClusteringManager()
    let locationManager = CLLocationManager()
    // Outlets
    @IBOutlet var rateOnMapView: ReportView!
    @IBOutlet var mapView: MKMapView!
    // true if displaying arcades, false if displaying machines
    var isDisplayingArcades = true {
        didSet {
            self.clusteringManager.setAnnotations(annotations: [])
            self.reloadMapAnnotations()
        }
    }
    var presentedProfileVC: UIViewController?
    // displaying machines can either come from from search query or machineTypeId
    // whichever is not nil is being used
    var machineTypeId: String? {
        didSet {
            self.clusteringManager.setAnnotations(annotations: [])
            self.reloadMapAnnotations()
        }
    }
    var searchMachineQuery: String? {
        didSet {
            self.clusteringManager.setAnnotations(annotations: [])
            self.reloadMapAnnotations()
        }
    }
    
    // MARK: - View...
    override func viewDidAppear(_ animated: Bool) {
        self.refresh()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(deleteAndRefresh), name: NSNotification.Name(rawValue: "mapRefresh"), object: nil)
        self.mapView.delegate = self
        self.rateOnMapView.delegate = self
        // Location manager
        // Ask for Authorisation from the User.
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        self.mapView.showsUserLocation = true
        
        // Current Location span
        if let locValue: CLLocationCoordinate2D = self.locationManager.location?.coordinate {
            let latitude: CLLocationDegrees = locValue.latitude
            let longitude: CLLocationDegrees = locValue.longitude
            let latDelta: CLLocationDegrees = 0.05
            let lonDelta: CLLocationDegrees = 0.05
            let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            mapView.setRegion(region, animated: false)
        }
        
        let addButton = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addNewArcade))
        
        addButton.setTitleTextAttributes([NSFontAttributeName:UIFont.boldSystemFont(ofSize: 40)], for: .normal)
        
        let filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Filter"), landscapeImagePhone: nil, style: .plain, target: self, action: #selector(moveToFilter))
        filterButton.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 7, right: 0)
        // navBar Setup
        self.navigationItem.rightBarButtonItems = [
            addButton,
            filterButton
        ]
        
        // allows alerts
        self.definesPresentationContext = true
    }
    
    func addNewArcade() {
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewArcade") as? AddArcadeViewController else {
            return
        }
        vc.formCompletedDelegate = self
        vc.currentLocation = self.locationManager.location?.coordinate
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
    
    func refresh() {
        if abs(self.mapView.region.span.latitudeDelta) < 10000.6 && abs(self.mapView.region.span.longitudeDelta) < 10000.8 {
            let nwPoint = CGPoint(x: self.mapView.bounds.origin.x - 100, y: mapView.bounds.origin.y - 100)
            let sePoint = CGPoint(x: (self.mapView.bounds.origin.x + self.mapView.bounds.size.width + 100), y: (mapView.bounds.origin.y + mapView.bounds.size.height) + 100)
            // Transform points into lat,lng values
            let nwCoord = self.mapView.convert(nwPoint, toCoordinateFrom: self.mapView)
            let seCoord = self.mapView.convert(sePoint, toCoordinateFrom: self.mapView)
            
            if self.isDisplayingArcades {
                LocationSession.shared.getArcadesInsideOf(seCoord: seCoord, nwCoord: nwCoord, childAddedResponse: {(arcade) in
                    let overlay = ArcadeMkCircle(center:CLLocationCoordinate2D(latitude: arcade.latitude! as CLLocationDegrees, longitude: arcade.longitude! as CLLocationDegrees), radius: 20)
                    overlay.arcade = arcade
                    
                    // check if user is within 250 meters (.15 miles) from any arcades. If so, check if Xp should be awarded
                    if let currentLocation = self.locationManager.location?.coordinate {
                        if CLLocation(latitude: arcade.latitude, longitude: arcade.longitude).distance(from: CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)).magnitude < 250 {
                            if VisitSaver.shared.shouldAwardXpForVisitingArcade(withId: arcade.objectId) {
                                
                            }
                        }
                        
                    }
                    guard let annotations = self.clusteringManager.allAnnotations() as? [ArcadeMkCircle] else {
                        return
                    }
                    if !annotations.contains(overlay) {
                        self.clusteringManager.addAnnotations(annotations: [overlay])
                        self.reloadMapAnnotations()
                    }
                })
            } else {
                LocationSession.shared.getArcadeMachinesInsideOf(seCoord: seCoord, nwCoord: nwCoord, childAddedResponse: {(machine) in
                    let overlay = ArcadeMachineMkCircle(center:CLLocationCoordinate2D(latitude: machine.latitude! as CLLocationDegrees, longitude: machine.longitude! as CLLocationDegrees), radius: 20)
                    overlay.machine = machine
                    
                    guard let annotations = self.clusteringManager.allAnnotations() as? [ArcadeMachineMkCircle] else {
                        return
                    }
                    
                    // if id's dont match or search query isnt included, then return
                    
                    if let searchQuery = self.searchMachineQuery, let machineId = self.machineTypeId {
                        print("\(machine.name) \n \(searchQuery)")
                        if !machine.name.contains(searchQuery) && machineId != machine.typeId {
                            return
                        }
                    }
                    
                    if !annotations.contains(overlay) {
                        self.clusteringManager.addAnnotations(annotations: [overlay])
                        self.reloadMapAnnotations()
                    }
                    
                })
            }
        } else {
            print("Please Zoom in to see machines")
        }
    }
    
    func reloadMapAnnotations() {
        DispatchQueue.main.async {
            let mapBoundsWidth = Double(self.mapView.bounds.size.width)
            let mapRectWidth: Double = self.mapView.visibleMapRect.size.width
            let scale: Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(rect: self.mapView.visibleMapRect, withZoomScale:scale)
            self.clusteringManager.displayAnnotations(annotations: annotationArray, onMapView:self.mapView)
        }
    }
    
    // MARK: - Move To Other Views
    @IBAction func moveToFullView(_ sender: Any) {
        moveToProfileForSelectedAnnotation()
    }
    
    func deleteAndRefresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { 
            self.clusteringManager.setAnnotations(annotations: [])
            self.reloadMapAnnotations()
            self.refresh()
        }      
    }
    
    func moveToProfileForSelectedAnnotation() {
        // 60 is for the top bar
        let presentr = Presentr(presentationType: .custom(width: ModalSize.custom(size: Float(self.mapView.frame.width)), height: ModalSize.custom(size: Float(self.mapView.frame.height)), center: ModalCenterPosition.custom(centerPoint: CGPoint(x: self.mapView.center.x, y: self.mapView.center.y))))
        presentr.backgroundColor = UIColor.clear
        presentr.backgroundOpacity = 0.0
        presentr.roundCorners = true
        presentr.cornerRadius = 25.0
        presentr.presentrDelegate = self
        if self.isDisplayingArcades {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArcadeTabProfile") as? ArcadeTabViewController else {
                return
            }
            presentedProfileVC = vc
            guard let annotation = self.mapView.selectedAnnotations.first as? ArcadeMkCircle, let arcade = annotation.arcade else {
                return
            }
            vc.arcade = arcade
            self.customPresentViewController(presentr, viewController: vc, animated: true) {
                //self.mapView.deselectAnnotation(annotation, animated: false)}
            }
        } else {
            guard let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MachineTab") as? MachineTabViewController else {
                return
            }
            presentedProfileVC = vc
            guard let annotation = self.mapView.selectedAnnotations.first as? ArcadeMachineMkCircle, let machine = annotation.machine else {
                return
            }
            vc.machine = machine
            self.customPresentViewController(presentr, viewController: vc, animated: true) {
                //self.mapView.deselectAnnotation(annotation, animated: false)
            }
        }
    }
    
    // Moves to the Filter VC which takes up the top of the screen
    func moveToFilter() {
        let presentr = Presentr(presentationType: .custom(width: ModalSize.full, height: ModalSize.fluid(percentage: 0.33), center: ModalCenterPosition.customOrigin(origin: CGPoint(x: 0, y: 0))))
        guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "filter") as? FilterViewController else {
            return
        }
        vc.filterDelegate = self
        vc.searchBarInitialText = self.searchMachineQuery ?? ""
        vc.isDisplayingArcade = self.isDisplayingArcades
        self.customPresentViewController(presentr, viewController: vc, animated: true, completion: nil)
    }
    
    // MARK: - MapView Delegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // if user tapped a "machine icon" on the map, animate the rateOnMapView
        if view.annotation is ArcadeMachineMkCircle || view.annotation is ArcadeMkCircle {
            self.rateOnMapView.center = CGPoint(x: self.rateOnMapView.center.x, y: self.view.frame.height + self.rateOnMapView.frame.height)
            self.rateOnMapView.isHidden = false
            self.rateOnMapView.isDisplayingArcades = self.isDisplayingArcades
            var objId = ""
            guard let annotation = self.mapView.selectedAnnotations.first as? RateableLocationMKCircle, let rateableLocation = annotation.rateableLocation else {
                return
            }
            self.rateOnMapView.finds = rateableLocation.finds
            self.rateOnMapView.notFinds = rateableLocation.notFinds
            objId = rateableLocation.objectId
            
            if let isFound = ReportSaver.shared.currentReportFor(id: objId) {
                // simulate buttons being pressed when loading from file
                if isFound {
                    self.rateOnMapView.yesButtonPressed(self.rateOnMapView.yesButton)
                } else {
                    self.rateOnMapView.noButtonPressed(self.rateOnMapView.noButton)
                }
            }
            self.rateOnMapView.alpha = 1.0
            UIView.animate(withDuration: 0.5) {
                self.rateOnMapView.center = CGPoint(x: self.view.frame.width/2, y: self.rateOnMapView.frame.height/2)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // Current Location span
        if let locValue: CLLocationCoordinate2D = self.locationManager.location?.coordinate {
            let latitude: CLLocationDegrees = locValue.latitude
            let longitude: CLLocationDegrees = locValue.longitude
            let latDelta: CLLocationDegrees = 0.05
            let lonDelta: CLLocationDegrees = 0.05
            let span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
            let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
            let region: MKCoordinateRegion = MKCoordinateRegionMake(location, span)
            self.mapView.setRegion(region, animated: false)
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        UIView.animate(withDuration: 0.5, animations: {
            self.rateOnMapView.alpha = 0.0
        })
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if view.tag == 0 { // is a cluster object
            if self.isDisplayingArcades {
                let vc = ArcadesTableViewController()
                vc.arcades = ((view.annotation as! FBAnnotationCluster).annotations as! [ArcadeMkCircle]).map({ $0.arcade!})
                vc.title = (view.annotation?.title)!
                self.show(vc, sender: self)
            } else {
                let vc = MachinesTableViewController()
                vc.machines = ((view.annotation as! FBAnnotationCluster).annotations as! [ArcadeMachineMkCircle]).map({ $0.machine!})
                vc.title = (view.annotation?.title)!
                self.show(vc, sender: self)
            }
        } else if view.tag == 1 {
            self.moveToProfileForSelectedAnnotation()
        }
    }
    
    // MARK: - Report View Delegate
    func learnMorePressed() {
        self.moveToProfileForSelectedAnnotation()
    }
    
    func reportStatusChanged(to result: Bool) {
        guard let annotation = self.mapView.selectedAnnotations.first as? RateableLocationMKCircle, let rateableLocation = annotation.rateableLocation else {
            return
        }
        let reportStatus = ReportSaver.shared.saveIfNeeded(id: rateableLocation.objectId, isFound: result)
        switch reportStatus {
        case .wasNotPresent:
            if result {
                annotation.rateableLocation?.finds = rateableLocation.finds + 1
                annotation.rateableLocation?.lastSeen = Date()
            } else {
                annotation.rateableLocation?.notFinds = rateableLocation.notFinds + 1
            }
        case .wentFromNoToYes:
            
            annotation.rateableLocation?.finds = rateableLocation.finds + 1
            annotation.rateableLocation?.lastSeen = Date()
            annotation.rateableLocation?.notFinds = rateableLocation.notFinds - 1
        case .wentFromYesToNo:
            annotation.rateableLocation?.finds = rateableLocation.finds - 1
            annotation.rateableLocation?.notFinds = rateableLocation.notFinds + 1
        default: break
            //print("Well this shouldn't happen")
        }
        
        self.rateOnMapView.finds = (annotation.rateableLocation?.finds)!
        self.rateOnMapView.notFinds = (annotation.rateableLocation?.notFinds)!
        ReportSession.shared.report(rateableLocation: annotation.rateableLocation!, isDisplayingArcade: self.isDisplayingArcades)
    }
}


extension MapViewController: FilterDelegate {
    func filter(to arcades: Bool) {
        self.isDisplayingArcades = arcades
        self.refresh()
    }
    
    func filter(with searchQuery: String?, machineId: String?) {
        self.searchMachineQuery = searchQuery ?? ""
        self.machineTypeId = machineId ?? ""
        self.refresh()
    }
}

extension MapViewController : MKMapViewDelegate {
    // MARK: - Map Extension
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        DispatchQueue.main.async {
            let mapBoundsWidth = Double(self.mapView.bounds.size.width)
            let mapRectWidth: Double = self.mapView.visibleMapRect.size.width
            let scale: Double = mapBoundsWidth / mapRectWidth
            let annotationArray = self.clusteringManager.clusteredAnnotationsWithinMapRect(rect: self.mapView.visibleMapRect, withZoomScale:scale)
            
            self.clusteringManager.displayAnnotations(annotations: annotationArray, onMapView:self.mapView)
        }
        self.refresh()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var reuseId = ""
        if annotation is FBAnnotationCluster, let annotation = annotation as? FBAnnotationCluster, let storedAnnotations = annotation.annotations as? [MKCircle] {
            
            reuseId = "Cluster"
            if self.isDisplayingArcades {
                annotation.title = ("\(storedAnnotations.count) Arcades")
            } else {
                annotation.title = ("\(storedAnnotations.count) Machines")
            }
            var clusterView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId)
            clusterView = FBAnnotationClusterView(annotation: annotation, reuseIdentifier: reuseId, options: nil)
            clusterView?.canShowCallout = true
            clusterView?.tintColor = Colors.yesColor
            clusterView?.tag = 0
            
            let btn = UIButton(type: .detailDisclosure)
            clusterView?.rightCalloutAccessoryView = btn
            return clusterView
            
        } else if annotation is MKUserLocation {
            return nil
        } else {
            reuseId = "Pin"
            var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as MKAnnotationView?
            if pinView == nil {
                pinView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            } else {
                pinView?.annotation = annotation
            }
            pinView?.tintColor = Colors.yesColor
            pinView?.image = UIImage(named: "cabinetFacing.png")
            pinView?.frame.size = CGSize(width: 45, height: 45)
            pinView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            pinView?.rightCalloutAccessoryView = btn
            pinView?.tag = 1
            return pinView
        }
    }
}


extension MapViewController: FormCompletedDelegate {
    func completedForm() {
        self.clusteringManager.setAnnotations(annotations: [])
        self.reloadMapAnnotations()
        self.refresh()
    }
}

extension MapViewController: PresentrDelegate {
    func presentrShouldDismiss(keyboardShowing: Bool) -> Bool {
        self.clusteringManager.setAnnotations(annotations: [])
        self.reloadMapAnnotations()
        self.refresh()
        return true
    }
}
