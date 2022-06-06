//
//  PaymentViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 30/03/22.
//

import UIKit

class PaymentViewController: UIViewController {
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var pickUpAddress: UITextField!
    @IBOutlet weak var deliveryAddress: UITextField!
    @IBOutlet weak var packageContent: UITextField!
    @IBOutlet weak var proceedPay: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        fetchData()
    }
    
    func fetchData() {
        if UserDefaults.standard.string(forKey: "currentAddress") != nil {
            
            print(UserDefaults.standard.string(forKey: "currentAddress"))
            pickUpAddress.text = UserDefaults.standard.string(forKey: "currentAddress")
        }
    }
    
    func cornerRadius() {
        proceedPay.layer.cornerRadius = 20
    }
    

    @IBAction func proceedBtnTapped(_ sender: UIButton) {
        let stripePayment = self.storyboard?.instantiateViewController(withIdentifier: "StripePaymentViewController") as! StripePaymentViewController
        self.navigationController?.pushViewController(stripePayment, animated: true)
    }
    
}
