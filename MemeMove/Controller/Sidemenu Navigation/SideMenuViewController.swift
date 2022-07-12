//
//  SideMenuViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 22/03/22.
//

import UIKit
import SideMenu

class SideMenuViewController: UIViewController {
    
    var animationOptions: UIView.AnimationOptions = .curveEaseIn
    static let menuSlideIn: SideMenuPresentationStyle = .viewSlideOutMenuPartialIn
  
    @IBOutlet weak var nameTextField: UIButton!
    @IBOutlet weak var mobileNumberText: UIButton!
    @IBOutlet weak var emailIdText: UIButton!
    @IBOutlet weak var changePasswordText: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadow()
    }
    
    
    func addShadow() {
        nameTextField.addShadowToButton(color: UIColor.gray, cornerRadius: 10)
        mobileNumberText.addShadowToButton(color: UIColor.gray, cornerRadius: 10)
        emailIdText.addShadowToButton(color: UIColor.gray, cornerRadius: 10)
        changePasswordText.addShadowToButton(color: UIColor.gray, cornerRadius: 10)
    }
    
    
    @IBAction func myAccount(_ sender: UIButton) {
        
        let navigation = self.storyboard?.instantiateViewController(withIdentifier: "MyAccountViewController") as! MyAccountViewController
        
        self.navigationController?.pushViewController(navigation, animated: true)
    }
    
    
    @IBAction func totalRides(_ sender: UIButton) {
        
        let navigation = self.storyboard?.instantiateViewController(withIdentifier: "TotalRidesViewController") as! TotalRidesViewController
        
        self.navigationController?.pushViewController(navigation, animated: true)
    }
    
    
    @IBAction func privacyButton(_ sender: UIButton) {
    }
    
    
    @IBAction func logutButton(_ sender: Any) {
    }
}
