//
//  AddAddressDetailViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 25/03/22.
//

import UIKit

class AddAddressDetailViewController: UIViewController {
    
    @IBOutlet weak var addAdressButton: UIButton!
    @IBOutlet weak var reachTextField: UITextField!
    @IBOutlet weak var buildingName: UITextField!
    @IBOutlet weak var houseFlatNumber: UITextField!
    @IBOutlet weak var contactNumberTextField: UITextField!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var officeButton: UIButton!
    @IBOutlet weak var othersButton: UIButton!
    @IBOutlet weak var addAddressView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        dropShadow()
        viewDropShadow()
        
    }
    
    func viewDropShadow() {
        addAddressView.layer.shadowColor = UIColor.black.cgColor
        addAddressView.layer.shadowOpacity = 1
        addAddressView.layer.shadowOffset = .zero
        addAddressView.layer.shadowRadius = 10
        addAddressView.layer.shadowPath = UIBezierPath(rect: addAddressView.bounds).cgPath
        addAddressView.layer.shouldRasterize = true
        addAddressView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func dropShadow() {
        contactNumberTextField.useUnderline()
        houseFlatNumber.useUnderline()
        buildingName.useUnderline()
        reachTextField.useUnderline()

    }
    
    func cornerRadius() {
        addAdressButton.layer.cornerRadius = 20
        changeButton.layer.borderWidth = 2.0
        changeButton.layer.borderColor =  UIColor(rgb: 0x60C8FF).cgColor
        changeButton.layer.cornerRadius = 10
        homeButton.layer.borderWidth = 2.0
        homeButton.layer.borderColor =  UIColor.lightGray.cgColor
        homeButton.layer.cornerRadius = 10
        officeButton.layer.borderWidth = 2.0
        officeButton.layer.borderColor =  UIColor.lightGray.cgColor
        officeButton.layer.cornerRadius = 10
        othersButton.layer.borderWidth = 2.0
        othersButton.layer.borderColor =  UIColor.lightGray.cgColor
        othersButton.layer.cornerRadius = 10
    }
}


extension UITextField {
    func useUnderline() {
        let border = CALayer()
        let borderWidth = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(origin: CGPoint(x: 0,y :self.frame.size.height - borderWidth), size: CGSize(width: self.frame.size.width, height: self.frame.size.height))
        border.borderWidth = borderWidth
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


