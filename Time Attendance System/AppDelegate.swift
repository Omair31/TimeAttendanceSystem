//
//  AppDelegate.swift
//  Time Attendance System
//
//  Created by Omeir Ahmed on 11/10/2020.
//  Copyright © 2020 Omeir Ahmed. All rights reserved.
//

import UIKit
import Firebase
import EstimoteProximitySDK
import CoreLocation


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var proximityObserver: ProximityObserver!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        return true
    }
    
    func startProximityObservation() {
        let estimoteCloudCredentials = CloudCredentials(appID: AppCredentials.appId,
                                                        appToken: AppCredentials.appToken)

        proximityObserver = ProximityObserver(credentials: estimoteCloudCredentials, onError: { error in
            print("ProximityObserver error: \(error.localizedDescription)")
        })

        let zone = ProximityZone(tag: AppCredentials.tag,
                                 range: ProximityRange.near)
       
        
        zone.onEnter = { context in
            if let deskOwner = context.attachments["desk-owner"] {
                print("Welcome to \(deskOwner)'s desk")
            }
            NotificationCenter.default.post(name: NSNotification.Name("didEnterZone"), object: ["deviceIdentifier":context.deviceIdentifier])
            
        }
        
        
        zone.onExit = { context in
            print("Bye bye, come again! \(context.attachments)")
            NotificationCenter.default.post(name: NSNotification.Name("didLeaveZone"), object: ["deviceIdentifier":context.deviceIdentifier])
        }
        
        
        zone.onContextChange = { contexts in
            let deskOwners = contexts.map {$0.attachments["Desk Owner"]!}
            print("In range of desks: \(deskOwners)")

        }

        proximityObserver.startObserving([zone])
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

