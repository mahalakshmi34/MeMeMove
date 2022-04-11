//
//  ForgotPasswordViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 16/03/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var forgotPasswordView: UIView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var mobileNumberText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cornerRadius()
        forgotPassword()
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
    
    func forgotPassword() {
        let url = APPURL.forgotPassword + "emailId=mahalakshmi.appdeveloper@gmail.com"
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .post,encoding: JSONEncoding.default,headers: header)
            .responseJSON { [self] response in
                print("isiLagi: \(response)")
                switch response.result {
                case .success(let data):
                    print("isi: \(data)")
                    let json = JSON(data)
                    print(json)
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
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
