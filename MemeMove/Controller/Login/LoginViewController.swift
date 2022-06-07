//
//  LoginViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 16/03/22.
//

import UIKit
import Alamofire
import SwiftyJSON


class LoginViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var emailIdTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        delegateMethod()
        placeHolderColor()
    }
    
    func placeHolderColor() {
        var color = UIColor.white
        var placeholder = emailIdTextField.placeholder ?? ""
        emailIdTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
        
        color = UIColor.white
        placeholder = passwordTextField.placeholder ?? ""
        passwordTextField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : color])
    }
    
    func delegateMethod() {
        emailIdTextField.delegate = self

    }
    
    func cornerRadius() {
        loginView.layer.cornerRadius = 40
        loginView.layer.borderWidth = 5
        loginView.layer.borderColor = UIColor(rgb: 0x60C8FF).cgColor
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
        emailIdTextField.layer.cornerRadius = 20
        passwordTextField.layer.cornerRadius = 40
        emailIdTextField.layer.backgroundColor = UIColor(rgb: 0x707070).cgColor
        passwordTextField.layer.backgroundColor = UIColor(rgb: 0x707070).cgColor
        
    }
    
    func textFieldValidation() {
        if emailIdTextField.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter your email id or mobilenumber")
        }
        else if passwordTextField.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Please enter your password")
        }
        else if emailIdTextField.text?.count != 0 {
            getEmailValidationMessage(email: emailIdTextField.text!)
        }
    }
    
    func getEmailValidationMessage(email: String) {
        var invalidEmailMessage = "";
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        if (emailIdTextField.text?.count == 0) {
            print("email")
        }
        if(!emailPred.evaluate(with: email)) {
            showAlert(alertText: "Alert", alertMessage: "Invalid Email Address")
        }
    }
    
    
    @IBAction func forgotPassword(_ sender: UIButton) {
       navigateToForgotPassword()
    }
    
    
    @IBAction func registerButton(_ sender: UIButton) {
       navigateToRegister()
    }    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        //textFieldValidation()
         userLogin()
    }
    
    func navigateToForgotPassword() {
        let forgotPassword = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPassword, animated: true)
    }
    
    
    func navigateToRegister() {
        let register = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(register, animated: true)
    }
    
    func navigateToHome() {
        let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    func userLogin() {
        let url = APPURL.userLogin + "email=\(emailIdTextField.text!)&pwd=\(passwordTextField.text!)"
        print(url)
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url,method: .post,encoding: JSONEncoding.default,headers: header)
            .responseDecodable(of:Login.self) { [self] (response) in
                guard var message = response.value else { return }
                print(message)
                print(message.userid)
                UserDefaults.standard.set(message.userid, forKey: "userID")
                UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                navigateToHome()
                
            }
    }
}


extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}

extension UIViewController {
    func showAlert(alertText : String, alertMessage : String) {
        let alert = UIAlertController (title: alertText, message: alertMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
}

extension Login :Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)!
        userid = try values.decodeIfPresent(String.self, forKey: .userid)!
    }
}
