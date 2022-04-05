//
//  OTPViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 16/03/22.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var otpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

       cornerRadius()
    }
    

    func cornerRadius() {
        otpView.layer.cornerRadius = 40
        otpView.layer.borderWidth = 5
        otpView.layer.borderColor = UIColor(rgb: 0x60C8FF).cgColor
        verifyButton.layer.cornerRadius = verifyButton.frame.size.height / 2
    }

    @IBAction func verifyButton(_ sender: UIButton) {
        
        let generatePassword =  self.storyboard?.instantiateViewController(withIdentifier: "GeneratePasswordViewController") as! GeneratePasswordViewController
        self.navigationController?.pushViewController(generatePassword, animated: true)
    }
}
