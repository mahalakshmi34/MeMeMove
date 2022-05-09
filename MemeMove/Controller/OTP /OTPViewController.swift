//
//  OTPViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 16/03/22.
//

import UIKit
import Alamofire


class OTPViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var otpFirst: UITextField!
    @IBOutlet weak var otpSecond: UITextField!
    @IBOutlet weak var otpThird: UITextField!
    @IBOutlet weak var otpFourth: UITextField!
    
    var codeOTP :String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        delegateMethod()
        otpSelector()
        textTapped()
    }
    
    func textTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapped(_:)))
        otpView.addGestureRecognizer(tap)
    }
    
    @objc func handleTapped(_ sender: UITapGestureRecognizer? = nil) {
        self.view.endEditing(true)
    }
    
    
    func delegateMethod() {
        otpFirst.delegate = self
        otpSecond.delegate = self
        otpThird.delegate = self
        otpFourth.delegate = self
    }
    

    func cornerRadius() {
        otpView.layer.cornerRadius = 40
        otpView.layer.borderWidth = 5
        otpView.layer.borderColor = UIColor(rgb: 0x60C8FF).cgColor
        verifyButton.layer.cornerRadius = verifyButton.frame.size.height / 2
    }
    
    func otpSelector() {
        otpFirst.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpSecond.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpThird.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
        otpFourth.addTarget(self, action: #selector(self.textFieldDidChange(textField:)), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChange(textField: UITextField){
       let text = textField.text
        let outputFinal = "\(otpFirst.text!)\(otpSecond.text!)\(otpThird.text!)\(otpFourth.text!)"
        codeOTP = outputFinal
        if  text?.count == 1 {
        switch textField{
        case otpFirst:
              otpSecond.becomeFirstResponder()
        case otpSecond:
              otpThird.becomeFirstResponder()
        case otpThird:
              otpFourth.becomeFirstResponder()
        case otpFourth:
              otpFourth.resignFirstResponder()
                default:
                    break
                }
            }
        else if text?.count == 0 {
                switch textField{
                case otpFourth:
                    otpThird.becomeFirstResponder()
                case otpThird:
                    otpSecond.becomeFirstResponder()
                case otpSecond:
                    otpFirst.becomeFirstResponder()
                default:
                    break
                }
            }
            else{

            }
        }
    
    
    func receiveOtp() {
        let url = APPURL.confirmOtp + "otp=\(codeOTP)"
        let header : HTTPHeaders = ["Content-Type": "application/json"]
        
        AF.request(url,method: .post,encoding: JSONEncoding.default,headers: header)
            .responseDecodable(of:confirmOtp.self) { [self](response) in
                guard let message = response.value else { return }
                print(message)
                navigateToGeneratePassword()
                
               // self.showAlert(alertText: "Alert", alertMessage: "\(message)")
            }
    }
    
    func navigateToGeneratePassword() {
        let generatePassword =  self.storyboard?.instantiateViewController(withIdentifier: "GeneratePasswordViewController") as! GeneratePasswordViewController
        self.navigationController?.pushViewController(generatePassword, animated: true)
    }

    @IBAction func verifyButton(_ sender: UIButton) {
        
          receiveOtp()
      
    }
}

extension confirmOtp :Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        message = try values.decodeIfPresent(String.self, forKey: .message)!
        //message = try values.decode(String.self, forKey: .message)
    }
}


extension UIButton {
    func addShadowToTextField(color: UIColor = UIColor.gray, cornerRadius: CGFloat) {
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1.0
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
    }
}
