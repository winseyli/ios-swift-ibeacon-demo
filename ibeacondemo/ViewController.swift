//
//  ViewController.swift
//  ibeacondemo
//
//  Created by Winsey Li on 22/4/2016.
//  Copyright © 2016 codefrd. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var imageView: UIImageView!
    
    let IBEACON_PROXIMITY_UUID = "00B5E77E-FCF1-4B6E-A53E-24EC77B6F59F"
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func startMonitoring(beaconRegion: CLBeaconRegion) {
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        locationManager.startMonitoringForRegion(beaconRegion)
    }

    func startRanging(beaconRegion: CLBeaconRegion) {
        locationManager.startRangingBeaconsInRegion(beaconRegion)
    }
    
    //  ======== CLLocationManagerDelegate methods ==========
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if !(status == .AuthorizedAlways || status == .AuthorizedWhenInUse) {
            print("Must allow location access for this application to work")
        } else {
            if let uuid = NSUUID(UUIDString: IBEACON_PROXIMITY_UUID) {
                let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "iBeacon")
                startMonitoring(beaconRegion)
                startRanging(beaconRegion)
            }
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        for beacon in beacons {
            var beaconProximity: String
            switch (beacon.proximity) {
            case CLProximity.Unknown:    beaconProximity = "Unknown"
            case CLProximity.Far:        beaconProximity = "Far"
            case CLProximity.Near:       beaconProximity = "Near"
            case CLProximity.Immediate:  beaconProximity = "Immediate"
            }
            print("BEACON RANGED: uuid: \(beacon.proximityUUID.UUIDString) major: \(beacon.major)  minor: \(beacon.minor) proximity: \(beaconProximity)")
        }
        
        if beacons.count > 0 {
            let beacon = beacons[0]
            
            var imageName = "finding"
            if (beacon.major == 1) {
                imageName = "product_tv"
            } else if (beacon.major == 2) {
                imageName = "product_macbook"
            } else if (beacon.major == 3) {
                imageName = "product_dslr"
            } else if (beacon.major == 4) {
                imageName = "product_ps4"
            }
            
            imageView.image = UIImage(named: imageName)
        }
    }
    
    func locationManager(manager: CLLocationManager, didStartMonitoringForRegion region: CLRegion) {
        print("monitoring started")
    }
    
    func locationManager(manager: CLLocationManager, monitoringDidFailForRegion region: CLRegion?, withError error: NSError) {
        print("monitoring failed")
    }
    
    func locationManager(manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("DID ENTER REGION: uuid: \(beaconRegion.proximityUUID.UUIDString)")
        }
    }
    
    func locationManager(manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("DID EXIT REGION: uuid: \(beaconRegion.proximityUUID.UUIDString)")
        }
    }
    
}

