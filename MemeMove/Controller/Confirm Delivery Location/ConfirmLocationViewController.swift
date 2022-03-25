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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentLocationOnMap()
        bringSubViews()
        cornerRadius()
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
    
    
    func showCurrentLocationOnMap() {
        let camera = GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 18.0)
        let mapView = GMSMapView.map(withFrame: self.view.frame , camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        self.view.addSubview(mapView)
        let marker = GMSMarker()
        marker.position = camera.target
        marker.map = mapView
    }


}
