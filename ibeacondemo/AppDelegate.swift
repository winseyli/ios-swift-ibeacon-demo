//
//  AppDelegate.swift
//  ibeacondemo
//
//  Created by Winsey Li on 22/4/2016.
//  Copyright © 2016 codefrd. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CLLocationManagerDelegate {

    var window: UIWindow?
    
    var locationManager: CLLocationManager!


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        
        let notificationType:UIUserNotificationType = [ UIUserNotificationType.sound,  UIUserNotificationType.alert]
        let notificationSettings = UIUserNotificationSettings(types: notificationType, categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        return true
    }
    
    func startMonitoring(_ beaconRegion: CLBeaconRegion) {
        beaconRegion.notifyOnEntry = true
        beaconRegion.notifyOnExit = true
        locationManager.startMonitoring(for: beaconRegion)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if !(status == .authorizedAlways || status == .authorizedWhenInUse) {
            print("Must allow location access for this application to work")
        } else {
            if let uuid = UUID(uuidString: Constant.IBEACON_PROXIMITY_UUID) {
                let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: Constant.IBEACON_IDENTIFIER)
                startMonitoring(beaconRegion)
            }
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
            
            let notification = UILocalNotification()
            notification.alertBody = "didEnterRegion"
            notification.soundName = "Default"
            UIApplication.shared.presentLocalNotificationNow(notification)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let beaconRegion = region as? CLBeaconRegion {
            print("DID EXIT REGION: uuid: \(beaconRegion.proximityUUID.uuidString)")
            
            let notification = UILocalNotification()
            notification.alertBody = "didExitRegion"
            notification.soundName = "Default"
            UIApplication.shared.presentLocalNotificationNow(notification)
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

