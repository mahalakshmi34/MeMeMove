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
    
    func receiveOTP() {
        let url = APPURL.forgotPassword + "emailId=\(mobileNumberText.text!)"
        print(url)
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .post, encoding: JSONEncoding.default,headers: header)
            .responseJSON { [self] response in
                print("isiLagi: \(response)")
                switch response.result {
                case .success(let data):
                print("isi: \(data)")
                let json = JSON(data)
                    print(json)
                    
                    UserDefaults.standard.set(mobileNumberText.text, forKey: "userEmail")
                    
                    if let message = json["message"].string {
                        navigateToOTP()
                    }
                    
                    
                   
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
    
    func navigateToOTP() {
        let OTP = self.storyboard?.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        self.navigationController?.pushViewController(OTP, animated: true)
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        receiveOTP()
    }
}

extension forgotPassword :Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       // message = try values.decodeIfPresent(String.self, forKey: .message)!
        message = try values.decode(String.self, forKey: .message)
    }
}
