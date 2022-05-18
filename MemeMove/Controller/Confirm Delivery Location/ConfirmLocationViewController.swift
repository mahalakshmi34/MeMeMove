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
    var geoCoder :CLGeocoder!
   
    
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
        marker.position = CLLocationCoordinate2D(latitude: pinPointLatitude, longitude: pinPointLongitude)
        marker.isDraggable = true
        marker.map = mapView
        self.mapView.delegate = self
        marker.isDraggable = true
        marker.tracksInfoWindowChanges = true
        reverseGeocoding(marker: marker)
        marker.map = mapView
        self.mapView.delegate = self
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition)  {
        print("change")
        mapView.isMyLocationEnabled = true
        //returnPositionOfMapView(mapView: mapView)
    }
    
 
    
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        mapView.isMyLocationEnabled = true
        
        print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
               reverseGeocoding(marker: marker)
           print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
        
        //reverseGeocode(coordinate: position.target)
    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

        mapView.isMyLocationEnabled = true
        
        //reverseGeocode(coordinate: position.target)
    }
    
    func reverseGeocoding(marker: GMSMarker) {
            let geocoder = GMSGeocoder()
            let coordinate = CLLocationCoordinate2DMake(Double(marker.position.latitude),Double(marker.position.longitude))
            
            var currentAddress = String()
            
            geocoder.reverseGeocodeCoordinate(coordinate) { response , error in
                if let address = response?.firstResult() {
                    let lines = address.lines! as [String]
                    
                    print("Response is = \(address)")
                    print("Response is = \(lines)")
                    
                    self.currentLocation.text = address.administrativeArea
                    self.currentAddress.text = lines.joined(separator: "\n")

                }
                marker.title = currentAddress
                marker.map = self.mapView
            }
        }

    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) {
      // 1
      let geocoder = GMSGeocoder()

      // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { [self] response, error in
        guard
          let address = response?.firstResult(),
         // print(address)
          let lines = address.lines
         // print(lines)
          else {
            return
        }

        // 3
          currentAddress.text = lines.joined(separator: "\n")
            print(currentAddress.text)

        // 4
        UIView.animate(withDuration: 0.25) {
          self.view.layoutIfNeeded()
        }
      }
    }

    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        let deliveryAddress = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryPackageViewController") as! DeliveryPackageViewController
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func confirmLocationPressed(_ sender: UIButton) {
        for controller in self.navigationController!.viewControllers  {
                if let deliveryPackage = controller as? DeliveryPackageViewController {
                       deliveryPackage.confirmLocationAddress = currentAddress.text!
                       self.navigationController?.popToViewController(deliveryPackage, animated: true)
                   }
          }
    }
    
    
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        let addAddress =  self.storyboard?.instantiateViewController(withIdentifier: "DeliveryPackageViewController") as! DeliveryPackageViewController
        self.navigationController?.popViewController(animated: true)
    }
}
