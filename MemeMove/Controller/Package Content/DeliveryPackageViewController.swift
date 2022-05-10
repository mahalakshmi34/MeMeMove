//
//  DeliveryPackageViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 24/03/22.
//

import UIKit
import CoreLocation
import GooglePlaces
import GoogleMaps


class DeliveryPackageViewController: UIViewController,CLLocationManagerDelegate {
    
    @IBOutlet weak var deliveryLocation: UIButton!
    @IBOutlet weak var pickUpLocation: UIButton!
    @IBOutlet weak var packageContent: UIButton!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var pickUpAddress: UITextField!
    @IBOutlet weak var deliveryAddress: UITextField!
    @IBOutlet weak var closeButton: UIButton!
    
    var currentLocationLat :Double = 0.0
    var currentLocationLong : Double = 0.0
    var destinationLatitude : Double = 0.0
    var destinationLongitude :Double = 0.0
    var locationManager = CLLocationManager()
    var currentLoc :CLLocation!
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        userCurrentLocation()
        cornerRadius()
        dropShadow()
    }
    
    func navigationBar() {
        self.navigationController?.navigationBar.isHidden = false
    }
    
    func userCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    @IBAction func pickUpAddressPressed(_ sender: UITextField) {
        pickUpAddress .tag = 0
        autoComplete()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        let center = CLLocationCoordinate2D(latitude: userLocation!.coordinate.latitude, longitude: userLocation!.coordinate.longitude)
        currentLocationLat = (userLocation?.coordinate.latitude)!
        currentLocationLong = (userLocation?.coordinate.longitude)!
        getCurrentLocation()
        locationManager.stopUpdatingLocation()
    }
    
    
    @IBAction func deliveryAddressTapped(_ sender: UITextField) {
        deliveryAddress.tag = 1
        autoComplete()
    }
    
    func autoComplete() {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
    }
    
    
    func getCurrentLocation() ->String {
        var address: String = ""
        let geoCoder = CLGeocoder()
        let location = CLLocation(latitude: currentLocationLat, longitude: currentLocationLong)
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
               // pickUpAddress.text = city as String
            }
        })
        return address;
    }
    
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        pickUpAddress.text = ""
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

extension CLLocation {
    func placemark(completion: @escaping (_ placemark: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
}

extension DeliveryPackageViewController: GMSAutocompleteViewControllerDelegate,UISearchBarDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place ID: \(place.placeID)")
        print("Place attributions: \(place.attributions)")
//        if pickUpAddress.tag == 0 {
//            pickUpAddress.text = place.name
//        }
//        if deliveryAddress.tag == 1 {
//            deliveryAddress.text = place.name
//        }
        var address = place.placeID
        GetPlacdDataByPlaceID(pPlaceID:address!)
        navigateToMap()
        dismiss(animated: true, completion: nil)
    }

  func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
    // TODO: handle the error.
    print("Error: ", error.localizedDescription)
  }

  // User canceled the operation.
  func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    dismiss(animated: true, completion: nil)
  }

  // Turn the network activity indicator on and off again.
  func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
  }

  func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
    UIApplication.shared.isNetworkActivityIndicatorVisible = false
  }
    
    func navigateToMap() {
        let deliveryLocation = self.storyboard?.instantiateViewController(withIdentifier: "ConfirmLocationViewController") as! ConfirmLocationViewController
        self.navigationController?.pushViewController(deliveryLocation, animated: true)
    }
    

    func GetPlacdDataByPlaceID(pPlaceID :String) {
        let placesClient = GMSPlacesClient.shared()
        placesClient.lookUpPlaceID(pPlaceID, callback: { [self] (place, error) -> Void in
            if let error = error {
                print("lookup place id query error: \(error.localizedDescription)")
                return
            }
            if let place = place {
                print("\(place.coordinate.latitude)")
                print("\(place.coordinate.longitude)")
                
                UserDefaults.standard.set(place.coordinate.latitude, forKey: "pickUpLatitude")
                UserDefaults.standard.set(place.coordinate.longitude, forKey: "pickUpLongitude")
            
             
            } else {
                print("No place details for \(pPlaceID)")
            }
        })
    }

}



