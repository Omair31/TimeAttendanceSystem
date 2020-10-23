//
//  ViewController.swift
//  Time Attendance System
//
//  Created by Omeir Ahmed on 11/10/2020.
//  Copyright © 2020 Omeir Ahmed. All rights reserved.
//

import UIKit
import AuthenticationServices


class ViewController: UIViewController {

    @IBOutlet weak var appLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSignInWithApple()
    }
    
    fileprivate func setupSignInWithApple() {
        // Do any additional setup after loading the view.
        let appleButton = ASAuthorizationAppleIDButton()
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        appleButton.addTarget(self, action: #selector(handleSignInWithApple), for: .touchUpInside)
        
        view.addSubview(appleButton)
        appleButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        appleButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        appleButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7).isActive = true
        
        UIView.animate(withDuration: 0.5) {
            self.appLabel.transform = CGAffineTransform(translationX: 0, y: -50)
            appleButton.transform = CGAffineTransform(translationX: 0, y: 20)
        }
    }
    
    @objc func handleSignInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.email,.fullName]
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }

}


extension ViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            let employeeInfoVC = self.storyboard?.instantiateViewController(identifier: "EmployeeInfoViewController") as! EmployeeInfoViewController
            employeeInfoVC.credentials = credentials
            navigationController?.pushViewController(employeeInfoVC, animated: true)
        default:
            print("Did nothing")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
//        let alertController = UIAlertController(title: "Error", message: "Authentication failed due to the following reason:\n \(error.localizedDescription)", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        present(alertController, animated: true, completion: nil)
        let employeeInfoVC = self.storyboard?.instantiateViewController(identifier: "EmployeeInfoViewController") as! EmployeeInfoViewController
        navigationController?.pushViewController(employeeInfoVC, animated: true)
    }
    
    
}

