//
//  ForgotPasswordViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 16/03/22.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mobileNumberText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cornerRadius()
    }
    
    func getEmailValidationMessage(email: String) {
        var invalidEmailMessage = "";
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if (mobileNumberText.text?.count == 0) {
            print("email")
        }
        if(!emailPred.evaluate(with: email)) {
            showAlert(alertText: "Alert", alertMessage: "Invalid Email Address")
        }
    }
    
    func textValidation() {
        if mobileNumberText.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter emailID or mobilenumber")
        }
        
        
    }
    
    
    func cornerRadius() {
        forgotPasswordView.layer.cornerRadius = 40
        forgotPasswordView.layer.borderWidth = 5
        forgotPasswordView.layer.borderColor = UIColor(rgb: 0x60C8FF).cgColor
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        
        let OTP = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        self.navigationController?.pushViewController(OTP, animated: true)
        
    }
    
}
