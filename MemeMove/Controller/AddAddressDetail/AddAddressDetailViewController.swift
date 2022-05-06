//
//  AddAddressDetailViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 25/03/22.
//

import UIKit
import GoogleMaps

class AddAddressDetailViewController: UIViewController,GMSMapViewDelegate {
    
    
    @IBOutlet weak var mapView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    @IBOutlet weak var navigationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentLocationOnMap()
        bringSubViews()
        cornerRadius()
        dropShadow()
        viewDropShadow()
    }
    
    func bringSubViews() {
        self.view.bringSubviewToFront(scrollView)
        self.scrollView.bringSubviewToFront(navigationView)
        self.scrollView.bringSubviewToFront(addAddressView)
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
    
    func showCurrentLocationOnMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame , camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        self.mapView.addSubview(mapView)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.map = mapView
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
        navigationView.layer.cornerRadius = 40
        navigationView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        addAddressView.layer.cornerRadius = 20
        addAddressView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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


