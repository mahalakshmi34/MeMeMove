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
    @IBOutlet weak var mobileNumberTextField: UITextField!
    @IBOutlet weak var referralCodeText: UITextField!
    
    var userName = ""
    var emailID = ""
    var mobileNumber = ""
    var messageData = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateMethod()
        cornerRadius()
    }
    
    func delegateMethod() {
        var color = UIColor.white
        var placeholder = userNameText.placeholder ?? ""
        userNameText.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        color = UIColor.white
        placeholder = emailIDText.placeholder ?? ""
        emailIDText.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        color = UIColor.white
        placeholder = mobileNumberTextField.placeholder ?? ""
        mobileNumberTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        color = UIColor.white
        placeholder = referralCodeText.placeholder ?? ""
        referralCodeText.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
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
        else if mobileNumberTextField.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter your password")
        }
//        else if referralCodeText.text?.count == 0 {
//            showAlert(alertText: "Alert", alertMessage: "Please enter your referral code")
//        }
        else if emailIDText.text?.count != 0 {
            getEmailValidationMessage(email: emailIDText.text!)
        }
        
       // registerUser()

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
        guard let textFieldText = mobileNumberTextField.text,
            let rangeOfTextToReplace = Range(range, in: textFieldText) else {
                return false
        }
        let substringToReplace = textFieldText[rangeOfTextToReplace]
        let count = textFieldText.count - substringToReplace.count + string.count
        return count <= 10
    }
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
           textFieldValidation()
          navigateToLogin()
       
    }
    
    func navigateToLogin() {
        let generatePassword = self.storyboard?.instantiateViewController(withIdentifier: "GeneratePasswordViewController") as! GeneratePasswordViewController
        generatePassword.userNameValue = userNameText.text!
        generatePassword.emailIDValue = emailIDText.text!
        generatePassword.mobileNumberValue = mobileNumberTextField.text!
        self.navigationController?.pushViewController(generatePassword, animated: true)
    }
    
    
    //API CALLS
    
    func registerUser() {
        let url = APPURL.registerUser + "username=\(userNameText.text!)&emailId=\(emailIDText.text!)&mobilenumber=\(mobileNumberTextField.text!)"
        print(url)
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        AF.request(url, method: .post,encoding: JSONEncoding.default,headers: header)
            .responseDecodable(of: userRegistration.self) { [self] (response) in
                guard let message =  response.value else { return }
                print(message)
                
               
              //  navigateToLogin()
                
                UserDefaults.standard.set(emailIDText.text, forKey: "userEmail")
            }
    }
}
   
extension userRegistration :Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
       // message = try values.decodeIfPresent(String.self, forKey: .message)!
        message = try values.decode(String.self, forKey: .message)
    }
}
