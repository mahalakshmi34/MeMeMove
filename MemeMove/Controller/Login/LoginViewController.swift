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
        delegateMethod()
        cornerRadius()
        userLogin()
    }
    
    func delegateMethod() {
        emailIdTextField.delegate = self
    }
    
    func cornerRadius() {
        loginView.layer.cornerRadius = 40
        loginView.layer.borderWidth = 5
        loginView.layer.borderColor = UIColor(rgb: 0x60C8FF).cgColor
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
        emailIdTextField.layer.cornerRadius = 30
        passwordTextField.layer.cornerRadius = passwordTextField.frame.size.height / 2
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
        
        let forgotPassword = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as! ForgotPasswordViewController
        self.navigationController?.pushViewController(forgotPassword, animated: true)
    }
    
    
    @IBAction func registerButton(_ sender: UIButton) {
        
        let register = self.storyboard?.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        self.navigationController?.pushViewController(register, animated: true)
    }
    
    
    @IBAction func submitButtonPressed(_ sender: UIButton) {
        
        //textFieldValidation()
        
        let home = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(home, animated: true)
    }
    
    func userLogin() {
        let url = APPURL.userLogin + "email=mahalakshmi.appdeveloper@gmail.com&pwd=maha"
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
