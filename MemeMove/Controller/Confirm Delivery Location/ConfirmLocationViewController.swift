//
//  ConfirmLocationViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 24/03/22.
//

import UIKit
import GoogleMaps

class ConfirmLocationViewController: UIViewController,GMSMapViewDelegate {
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var confirmLocation: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentAddress: UILabel!
    
    var pinPointLatitude : Double = 0.0
    var pinPointLongitude :Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentLocationOnMap()
        bringSubViews()
        cornerRadius()
        navigationBar()
    }
    
    func navigationBar() {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func bringSubViews() {
        self.view.bringSubviewToFront(addressView)
        self.view.bringSubviewToFront(navigationView)
    }
    
    func cornerRadius() {
        confirmLocation.layer.cornerRadius = 20
        changeButton.layer.borderWidth = 2.0
        changeButton.layer.borderColor =  UIColor(rgb: 0x60C8FF).cgColor
        changeButton.layer.cornerRadius = 10
        navigationView.layer.cornerRadius = 40
        navigationView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
    }
    
    
    func fetchData() {
        if UserDefaults.standard.double(forKey: "pickUpLatitude") != nil {
            pinPointLatitude = UserDefaults.standard.double(forKey: "pickUpLatitude")
        }
        if UserDefaults.standard.double(forKey: "pickUpLatitude") !=  nil {
            pinPointLongitude = UserDefaults.standard.double(forKey: "pickUpLongitude")
        }
        if UserDefaults.standard.double(forKey: "dropLatitude") != nil {
           pinPointLatitude = UserDefaults.standard.double(forKey: "dropLatitude")
        }
        if UserDefaults.standard.double(forKey: "dropLongitude") != nil {
            pinPointLongitude = UserDefaults.standard.double(forKey: "dropLongitude")
        }
        if UserDefaults.standard.string(forKey: "confirmLocation") != nil {
            currentLocation.text = UserDefaults.standard.string(forKey: "confirmLocation")
        }
    }
    
    func showCurrentLocationOnMap() {
        fetchData()
           
        let camera = GMSCameraPosition.camera(withLatitude: pinPointLatitude, longitude: pinPointLongitude, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame , camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        self.view.addSubview(mapView)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.map = mapView
    }
    
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        let deliveryAddress = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryPackageViewController") as! DeliveryPackageViewController
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func confirmLocationPressed(_ sender: UIButton) {
        
        let addAddress =  self.storyboard?.instantiateViewController(withIdentifier: "AddAddressDetailViewController") as! AddAddressDetailViewController
        self.navigationController?.pushViewController(addAddress, animated: true)
    }
    
    
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        let addAddress =  self.storyboard?.instantiateViewController(withIdentifier: "DeliveryPackageViewController") as! DeliveryPackageViewController
        self.navigationController?.popViewController(animated: true)
        
    }
    

}
