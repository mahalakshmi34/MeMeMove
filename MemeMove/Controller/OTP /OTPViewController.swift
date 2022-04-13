//
//  OTPViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 16/03/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class OTPViewController: UIViewController {

    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var otpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       cornerRadius()
        confirmOtp()
    }
    

    func cornerRadius() {
        otpView.layer.cornerRadius = 40
        otpView.layer.borderWidth = 5
        otpView.layer.borderColor = UIColor(rgb: 0x60C8FF).cgColor
        verifyButton.layer.cornerRadius = verifyButton.frame.size.height / 2
    }
    
    func confirmOtp() {
        let url = APPURL.confirmOtp + "otp=123"
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

    @IBAction func verifyButton(_ sender: UIButton) {
        let generatePassword =  self.storyboard?.instantiateViewController(withIdentifier: "GeneratePasswordViewController") as! GeneratePasswordViewController
        self.navigationController?.pushViewController(generatePassword, animated: true)
    }
}
