//
//  EmployeeInfoViewController.swift
//  Time Attendance System
//
//  Created by Omeir Ahmed on 11/10/2020.
//  Copyright © 2020 Omeir Ahmed. All rights reserved.
//

import UIKit
import Firebase
import AuthenticationServices

class EmployeeInfoViewController: UIViewController {
    
    var credentials: ASAuthorizationAppleIDCredential?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Employee Info"
        guard let credentials = self.credentials else {return}
        nameTextField.text = (credentials.fullName?.givenName ?? "") + " " + (credentials.fullName?.familyName ?? "")
        emailTextField.text = credentials.email
        
        // Do any additional setup after loading the view.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    @IBAction func submitPressed(_ sender: UIButton) {
        for view in stackView.subviews {
            if let textField = view as? UITextField {
                if textField.text == nil || textField.text?.isEmpty == true {
                    showAlert()
                    return
                }
            }
        }
        
        Database.database().reference().child(UUID().uuidString).updateChildValues(
        ["name":nameTextField.text ?? "",
        "email":emailTextField.text ?? "",
        "phoneNumber":phoneNumberTextField.text ?? "",
        "department":departmentTextField.text ?? ""]) { (error, reference) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            self.showSuccessAlert()
        }

    }
    
    func showAlert() {
        let alertController = UIAlertController(title: "Error", message: "Please enter complete details", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showSuccessAlert() {
        let alertController = UIAlertController(title: "Success", message: "Data successfully submitted to Firebase.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

}
