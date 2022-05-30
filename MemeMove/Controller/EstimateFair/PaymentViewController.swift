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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    func fetchData() {
        
        if UserDefaults.standard.string(forKey: "currentAddress") != nil {
            pickUpAddress.text = UserDefaults.standard.string(forKey: "currentAddress")
        }
        
    }
    


}
