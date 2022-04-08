//
//  RegistrationViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 16/03/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class RegistrationViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var registrationView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var userNameText: UITextField!
    @IBOutlet weak var emailIDText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var referralCodeText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateMethod()
        cornerRadius()
        userRegistration()
    }
    
    func delegateMethod() {
        
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
        else if referralCodeText.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter your referral code")
        }
        else if emailIDText.text?.count != 0 {
            getEmailValidationMessage(email: emailIDText.text!)
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

    
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let textFieldText = mobileNumberText.text,
//            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
//                return false
//        }
//        let substringToReplace = textFieldText[rangeOfTextToReplace]
//        let count = textFieldText.count - substringToReplace.count + string.count
//        return count <= 10
//    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
           //textFieldValidation()
        
        let login = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(login, animated: true)
    }
    
    
    //API CALLS
    
    func userRegistration() {
        let url = APPURL.registerUser + "username=maha&emailId=mahalakshmi.appdeveloper@gmail.com&password=maha"
        print(url)
        
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .post,encoding: JSONEncoding.default,headers: header)
            .responseJSON { [self] response in
                print("isiLagi: \(response)")
            }
    }

}
    
