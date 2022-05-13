//
//  TimeOfDeliveryViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 12/05/22.
//

import UIKit

class TimeOfDeliveryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func navigateToDelivery() {
        let deliveryPage =  self.storyboard?.instantiateViewController(withIdentifier: "DeliveryPackageViewController") as! DeliveryPackageViewController
        self.navigationController?.pushViewController(deliveryPage, animated: true)
    }
    

    @IBAction func quickDeliveryPressed(_ sender: UIButton) {
        navigateToDelivery()
    }
    
    
    @IBAction func scheduledDelivery(_ sender: UIButton) {
        navigateToDelivery()
    }
    

}
