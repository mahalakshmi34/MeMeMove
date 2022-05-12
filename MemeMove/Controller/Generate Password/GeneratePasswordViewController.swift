//
//  GeneratePasswordViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 16/03/22.
//

import UIKit
import Alamofire

class GeneratePasswordViewController: UIViewController {
    
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var passwordGenerationView: UIView!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    
    var emailID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
    }
    
    func cornerRadius() {
        passwordGenerationView.layer.cornerRadius = 40
        passwordGenerationView.layer.borderWidth = 5
        passwordGenerationView.layer.borderColor = UIColor(rgb: 0x60C8FF).cgColor
        submitButton.layer.cornerRadius = submitButton.frame.size.height / 2
    }
    
    func passwordValidation() {
        if passwordText.text ==  confirmPasswordText.text  {
            generatePassword()
        }
        else {
            showAlert(alertText: "Alert", alertMessage: "PasswordMismatch")
        }
    }
    
    func generatePassword() {
        if UserDefaults.standard.string(forKey: "userEmail") != nil {
            emailID = UserDefaults.standard.string(forKey: "userEmail")!
        }
        let url = APPURL.generatePassword + "emailId=\(emailID)"
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url, method: .post,encoding: JSONEncoding.default,headers: header)
            .responseJSON { [self] response in
                print("isiLagi: \(response)")
                navigateToHome()
            }
    }
    
    func navigateToHome() {
        let signIn = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.navigationController?.pushViewController(signIn, animated: true)
    }
    
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
        passwordValidation()
    }
}
