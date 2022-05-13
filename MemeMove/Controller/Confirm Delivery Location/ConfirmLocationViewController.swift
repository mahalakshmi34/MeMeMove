//
//  ConfirmLocationViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 24/03/22.
//

import UIKit
import GoogleMaps
import SwiftyJSON
import CoreLocation

class ConfirmLocationViewController: UIViewController,GMSMapViewDelegate {
    
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var confirmLocation: UIButton!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var addressView: UIView!
    @IBOutlet weak var currentLocation: UILabel!
    @IBOutlet weak var currentAddress: UILabel!
    
    var pinPointLatitude : Double = 0.0
    var pinPointLongitude :Double = 0.0
    var mapView :GMSMapView!
    
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
           
        let camera = GMSCameraPosition.camera(withLatitude: pinPointLatitude, longitude: pinPointLongitude, zoom: 6.0)
        mapView = GMSMapView.map(withFrame: self.view.frame , camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        self.view.addSubview(mapView)
        let marker = GMSMarker()
        marker.isDraggable = true
        marker.position = camera.target
        marker.map = mapView
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)  {
        print("change")
        returnPositionOfMapView(mapView: mapView)
    }
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
       // returnPositionOfMapView(mapView: mapView)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        //returnPositionOfMapView(mapView: mapView)
    }
    
    func returnPositionOfMapView(mapView : GMSMapView) {
        let geoCoder = GMSGeocoder()
        let latitude = mapView.camera.target.latitude
        let longitude = mapView.camera.target.longitude
        let position =  CLLocationCoordinate2DMake(latitude, longitude)
        geoCoder.reverseGeocodeCoordinate(position) { [self] response , error
            in
            if error != nil {
                print("GMSReverseGeocode : \(String(describing: error?.localizedDescription))")
            }
            else {
                let result =  response?.results()?.first
                print(result)
                let address = result?.lines?.reduce("") { $0 == "" ? $1 : $0 + ", " + $1 }
                print(address)
                currentAddress.text = address
                }
            }
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
