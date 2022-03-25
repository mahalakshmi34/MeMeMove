//
//  RegistrationViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 16/03/22.
//

import UIKit

class RegistrationViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailIDText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var mobileNumberText: UITextField!
    @IBOutlet weak var referralCodeText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateMethod()
        cornerRadius()
    
    }
    func delegateMethod() {
        mobileNumberText.delegate = self
    }
    
    func cornerRadius() {
        registrationView.layer.cornerRadius = 40
        registrationView.layer.borderWidth = 5
        registrationView.layer.borderColor = UIColor(rgb: 0x60C8FF).cgColor
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
    }
    
    func textFieldValidation() {
        if userNameText.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter your username")
        }
        else if emailIDText.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter your emailId")
        }
        else if passwordText.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter your password")
        }
        else if confirmPasswordText.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please confirm your password")
        }
        else if mobileNumberText.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter your mobileNumber")
        }
        else if referralCodeText.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter your referral code")
        }
        else if emailIDText.text?.count != 0 {
            getEmailValidationMessage(email: emailIDText.text!)
        }
        else if passwordText.text != confirmPasswordText.text {
            showAlert(alertText: "Alert", alertMessage: "Confirm password must be equal")
        }
    }
    
    func getEmailValidationMessage(email: String) {
        var invalidEmailMessage = "";
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if (emailIDText.text?.count == 0) {
            print("email")
        }
        if(!emailPred.evaluate(with: email)) {
            showAlert(alertText: "Alert", alertMessage: "Invalid Email Address")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = mobileNumberText.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 10
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
           textFieldValidation()
    }
    
}
