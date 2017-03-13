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
    
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
    }
    
    func startMonitoring(_ beaconRegion: CLBeaconRegion) {
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        locationManager.startMonitoring(for: beaconRegion)
    }

    func startRanging(_ beaconRegion: CLBeaconRegion) {
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    //  ======== CLLocationManagerDelegate methods ==========
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if !(status == .authorizedAlways || status == .authorizedWhenInUse) {
            print("Must allow location access for this application to work")
        } else {
            if let uuid = UUID(uuidString: Constant.IBEACON_PROXIMITY_UUID) {
                let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: Constant.IBEACON_IDENTIFIER)
                startMonitoring(beaconRegion)
                startRanging(beaconRegion)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            var beaconProximity: String
            switch (beacon.proximity) {
            case CLProximity.unknown:    beaconProximity = "Unknown"
            case CLProximity.far:        beaconProximity = "Far"
            case CLProximity.near:       beaconProximity = "Near"
            case CLProximity.immediate:  beaconProximity = "Immediate"
            }
            print("BEACON RANGED: uuid: \(beacon.proximityUUID.uuidString) major: \(beacon.major)  minor: \(beacon.minor) proximity: \(beaconProximity)")
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
    
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("monitoring started")
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("monitoring failed")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("DID ENTER REGION: uuid: \(beaconRegion.proximityUUID.uuidString)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("DID EXIT REGION: uuid: \(beaconRegion.proximityUUID.uuidString)")
        }
    }
    
}

