//
//  BeaconDetectionViewController.swift
//  Time Attendance System
//
//  Created by Omeir Ahmed on 24/10/2020.
//  Copyright © 2020 Omeir Ahmed. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation
import Firebase

class BeaconDetectionViewController: UIViewController {

    @IBOutlet weak var messageLabel: UILabel!
    var centralManager: CBCentralManager?
    var peripheral: CBPeripheral?
    let locationManager = CLLocationManager()
    
    
    fileprivate func setupLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            startObserving()
        } else {
            locationManager.requestAlwaysAuthorization()
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    fileprivate func setupNotifiers() {
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterZone), name: NSNotification.Name(rawValue: "didEnterZone"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didLeaveZone), name: NSNotification.Name(rawValue: "didLeaveZone"), object: nil)
    }
    
    fileprivate func setupBluetoothManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNotifiers()
        setupBluetoothManager()
        setupLocationServices()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign out", style: .plain, target: self, action: #selector(handleSignout))
        // Do any additional setup after loading the view.
    }
    
    @objc func handleSignout() {
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "phoneNumber")
        UserDefaults.standard.removeObject(forKey: "department")
        if let sceneDelegate = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
                appDelegate.stopObservingZones()
            }
            let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let viewController = storyBoard.instantiateViewController(identifier: "ViewController") as! ViewController
            let navigation = UINavigationController(rootViewController: viewController)
            if let window = sceneDelegate.windows.first {
                ///  Set the root view controller of the window with your view controller
                window.rootViewController = navigation
                ///  Set the window and call makeKeyAndVisible()
                window.makeKeyAndVisible()
            }
        }
    }
    
    @objc func didEnterZone(notification:Notification) {
        let userInfo = notification.userInfo
        let deviceIdentifier = userInfo?["deviceIdentifier"] as? String ?? ""
        let deviceName = DeviceIdentifier.identifers[deviceIdentifier] ?? ""
        messageLabel.text = "Beacon '\(deviceName)' found! \n Submitting Data to Firebase..."
        let currentEmployee = Employee.currentEmployee
        let name = currentEmployee?.name ?? ""
        let email = currentEmployee?.email ?? ""
        let phoneNumber = currentEmployee?.phoneNumber ?? ""
        let department = currentEmployee?.department ?? ""
        var values = ["name":name,
                      "email":email,
                      "phoneNumber":phoneNumber,
                      "department":department,
                      "date": Utility.getDateFormatCurrentTimeZone(by: Date(), format: "MMM dd, yyyy 'at' hh:mm aa"),
                      ]
        if !deviceName.isEmpty {
            values["device_type"] = deviceName
        }
        Database.database().reference().child("entrance_records").childByAutoId().updateChildValues(values) { (error, ref) in
            if error == nil {
                self.messageLabel.text = "Done"
            }
        }
    
    }
    
    @objc func didLeaveZone() {
        messageLabel.text = "You just left the zone"
    }

}

extension BeaconDetectionViewController: CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .unauthorized:
            switch central.authorization {
            case .allowedAlways:
                print("allowedAlways")
            case .denied:
                print("denied")
            case .restricted:
                print("restricted")
            case .notDetermined:
                print("notDetermined")
            @unknown default:
                fatalError()
            }
        case .unknown:
            print("unknown")
        case .unsupported:
            print("unsupported")
        case .poweredOn:
            print("poweredOn")
        case .poweredOff:
            print("poweredOff")
        case .resetting:
            print("resetting")
        @unknown default:
            print("unknown default")
        }
    }
    
}

extension BeaconDetectionViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude), \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse :
            startObserving()
        default:
            print("Location access was denied")
        }
    }
    
    fileprivate func startObserving() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            appDelegate.startProximityObservation()
            messageLabel.text = "Looking for beacons nearby..."
        }
    }
    
}
