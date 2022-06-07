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
    var pickUpTag = 1
    var deliveryTag = 2
   
    
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
        if UserDefaults.standard.double(forKey: "pickUpLongitude") !=  nil {
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
       // fetchData()
           
        let camera = GMSCameraPosition.camera(withLatitude: pinPointLatitude, longitude: pinPointLongitude, zoom: 12.0)
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
                    
                    print(address.administrativeArea)
                    
                    if UserDefaults.standard.integer(forKey: "pickUpTag") == 1 {
                        UserDefaults.standard.set(address.administrativeArea, forKey: "currentLocationState")
                    }
                    if UserDefaults.standard.integer(forKey: "deliveryTag") == 2 {
                        UserDefaults.standard.set(address.administrativeArea, forKey: "toState")
                    }
                   
                    print(address.country)
                    print(address.subLocality)
                    
                    
                    self.currentLocation.text = address.administrativeArea
                    self.currentAddress.text = lines.joined(separator: "\n")

                }
                marker.title = currentAddress
                marker.map = self.mapView
            }
        }
    
    func getCurrentLocation() ->String {
        var address: String = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: pinPointLatitude, longitude: pinPointLongitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { [self] (placemarks, error) -> Void in
            var placeMark: CLPlacemark!
            placeMark = placemarks?[0]
            if let place = placemarks?[0] {
                if place.subThoroughfare != nil {
                }
            }
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
                address = city as String
                UserDefaults.standard.set(city, forKey: "currentLocationCity")
                UserDefaults.standard.set(city, forKey: "fromCity")
                UserDefaults.standard.set(city, forKey: "toCity")
                //pickUpAddress.text = city as String
            }
            if let country = placeMark.addressDictionary?["Country"] as? NSString {
                print(country)
                UserDefaults.standard.set(country, forKey: "currentLocationCountry")
                UserDefaults.standard.set(country, forKey: "fromCountry")
                UserDefaults.standard.set(country, forKey: "toCountry")
            }
            
            if let State = placeMark.addressDictionary?["State"] as? NSString {
                print(State)
                UserDefaults.standard.set(State, forKey: "currentLocationState")
                UserDefaults.standard.set(State, forKey: "fromState")
                UserDefaults.standard.set(State, forKey: "toState")
            }
            
            if UserDefaults.standard.integer(forKey: "pickUpTag") == 1 {
                UserDefaults.standard.string(forKey: "fromCity")
                UserDefaults.standard.string(forKey: "fromCountry")
                UserDefaults.standard.string(forKey: "fromState")
                
            }
            
            if UserDefaults.standard.integer(forKey: "deliveryTag") == 2 {
                UserDefaults.standard.string(forKey: "toCity")
                UserDefaults.standard.string(forKey: "toCountry")
                UserDefaults.standard.string(forKey: "toState")
                
            }
            
        })
        return address;
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
            
            UserDefaults.standard.set(currentAddress.text, forKey: "currentAddress")

        // 4
        UIView.animate(withDuration: 0.25) {
          self.view.layoutIfNeeded()
        }
      }
    }

    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        let deliveryAddress = self.storyboard?.instantiateViewController(withIdentifier: "DeliveryPackageViewController") as! DeliveryPackageViewController
        deliveryAddress.pickUpAddress.tag = pickUpTag
        deliveryAddress.deliveryAddress.tag = deliveryTag
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func confirmLocationPressed(_ sender: UIButton) {
        getCurrentLocation()
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
