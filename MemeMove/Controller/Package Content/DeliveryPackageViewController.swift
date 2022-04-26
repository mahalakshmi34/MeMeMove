//
//  DeliveryPackageViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 24/03/22.
//

import UIKit
import GoogleMaps

class DeliveryPackageViewController: UIViewController {
    
    @IBOutlet weak var deliveryLocation: UIButton!
    @IBOutlet weak var pickUpLocation: UIButton!
    @IBOutlet weak var packageContent: UIButton!
    @IBOutlet weak var proceedButton: UIButton!
    
    var currentLocatiobLat :Double = 0.0
    var currentLocationLong : Double = 0.0
    var destinationLatitude : Double = 0.0
    var destinationLongitude :Double = 0.0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cornerRadius()
        dropShadow()
    }
    
    
    
    func cornerRadius() {
        deliveryLocation.layer.cornerRadius = 20
        pickUpLocation.layer.cornerRadius = 20
        packageContent.layer.cornerRadius = 20
        proceedButton.layer.cornerRadius = 20
    }
    func dropShadow () {
        deliveryLocation.addShadowToButton(cornerRadius: 10)
        deliveryLocation.addShadowToButton(color: UIColor.gray, cornerRadius: 10)
        pickUpLocation.addShadowToButton(cornerRadius: 10)
        pickUpLocation.addShadowToButton(color: UIColor.gray, cornerRadius: 10)
        packageContent.addShadowToButton(cornerRadius: 10)
        packageContent.addShadowToButton(color: UIColor.gray, cornerRadius: 10)
    }
}

extension UIButton {
    func addShadowToButton(color: UIColor = UIColor.lightGray, cornerRadius: CGFloat) {
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1.0
        self.backgroundColor = .white
        self.layer.cornerRadius = cornerRadius
    }
}
