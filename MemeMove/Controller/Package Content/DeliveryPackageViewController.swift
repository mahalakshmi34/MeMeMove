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
    @IBOutlet weak var packageItem: UITextField!
    
    
    var currentLocationLat :Double = 0.0
    var currentLocationLong : Double = 0.0
    var destinationLatitude : Double = 0.0
    var destinationLongitude :Double = 0.0
    var locationManager = CLLocationManager()
    var currentLoc :CLLocation!
    var confirmLocationAddress = ""
    var packageFood :Array = [String]()
    var State = ""
    var Country = ""
    var City = ""
    var pickUpAddressTag = 1
    var deliveryAddressTag = 2
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        userCurrentLocation()
        cornerRadius()
        dropShadow()
        navigationBar()
        textTapped()
       // removeObject()
        //validation()
        //autoComplete()
    }
    
    override func viewWillAppear(_ animated: Bool){
        validation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        validation()
        textTapped()
        packageList()
    }
    
    func removeObject() {
        UserDefaults.standard.removeObject(forKey: "currentLocationCity")
        UserDefaults.standard.removeObject(forKey: "currentLocationCountry")
        UserDefaults.standard.removeObject(forKey: "currentLocationState")
    }
    
    func validation() {
        if pickUpAddress.tag == 1 {
       var pickTag = UserDefaults.standard.integer(forKey: "pickUpTag")
            pickUpAddress.text = confirmLocationAddress
    
          if UserDefaults.standard.string(forKey: "currentAddress") != nil {
                pickUpAddress.text = UserDefaults.standard.string(forKey: "currentAddress")
            }
            
            UserDefaults.standard.set(pickUpAddress.text, forKey: "pickUpPlaces")
      }
        if deliveryAddress.tag == 2 {
            var deliveryTag = UserDefaults.standard.integer(forKey: "deliveryTag")
            deliveryAddress.text = confirmLocationAddress
          if UserDefaults.standard.string(forKey: "currentAddress") != nil {
                deliveryAddress.text = UserDefaults.standard.string(forKey: "currentAddress")
            }
            
            UserDefaults.standard.set(deliveryAddress.text, forKey: "deliveryPlaces")
        }
       print(packageFood)
       
    }
    
    func packageList() {
        for  packageFoods in packageFood {
            print(packageFoods)
            //print(UserDefaults.standard.stringArray(forKey: "packageContentArray"))
            packageItem.text = packageFood.joined(separator: "")
            
            UserDefaults.standard.set(packageItem.text, forKey: "packageContent")
            
        }
    }
    
    func navigationBar() {
        self.navigationController?.navigationBar.isHidden = false
        pickUpAddress.text = confirmLocationAddress
    }
    
    func userCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func pickUpAddressPressed(_ sender: UITextField) {
        pickUpAddress .tag = 1
        UserDefaults.standard.set(1, forKey: "pickUpTag")
        autoComplete()
    }
    
    func textTapped() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapped(_:)))
        packageItem.addGestureRecognizer(tap)
    }
    
    @objc func handleTapped(_ sender: UITapGestureRecognizer? = nil) {
        let deliveryLocation = self.storyboard?.instantiateViewController(withIdentifier: "SelectPackageContentViewController") as! SelectPackageContentViewController
        self.navigationController?.pushViewController(deliveryLocation, animated: true)
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
        pickUpAddress.tag = 0
        deliveryAddress.tag = 2
        //UserDefaults.standard.removeObject(forKey: "pickUpTag")
        UserDefaults.standard.set(2, forKey: "deliveryTag")
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
           
            print(placeMark.postalAddress?.state)
        
            if let place = placemarks?[0] {
                if place.subThoroughfare != nil {
                }
            }
            if let city = placeMark.addressDictionary!["City"] as? NSString {
                print(city)
                address = city as String
                UserDefaults.standard.set(city, forKey: "currentLocationCity")
                //pickUpAddress.text = city as String
            }
            if let country = placeMark.addressDictionary?["Country"] as? NSString {
                print(country)
                UserDefaults.standard.set(country, forKey: "currentLocationCountry")
            }
            
            if let State = placeMark.addressDictionary?["State"] as? NSString {
                print(State)
                
            }
            
            if let formattedAddressLine = placeMark.addressDictionary!["FormattedAddressLines"] as? NSString {
                print(formattedAddressLine)
            }
            
        })
        return address;
    }
    
    
    @IBAction func closeButtonPressed(_ sender: UIButton) {
        pickUpAddress.text = ""
    }
    
    func textValidation() {
        if pickUpAddress.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Enter pick up address")
        }
        else if deliveryAddress.text?.count == 0
        {
            showAlert(alertText: "Alert", alertMessage: "Enter delivery address")
        }
        else if packageItem.text?.count == 0 {
            showAlert(alertText: "Alert", alertMessage: "Enter package content")
        }
    }
    
    func navigateToSelectVehicle() {
        let selectVehicle = self.storyboard?.instantiateViewController(withIdentifier: "AddAddressDetailViewController") as! AddAddressDetailViewController
        
        self.navigationController?.pushViewController(selectVehicle, animated: true)
    }
    
    @IBAction func proceedButton(_ sender: UIButton){
        textValidation()
        navigateToSelectVehicle()
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
        print("Place Address : \(place.addressComponents)")
        
        
        if pickUpAddress.tag == 1 {
            //pickUpAddress.text = place.name
            UserDefaults.standard.set(place.name, forKey: "confirmLocation")
        }
        if deliveryAddress.tag == 2 {
            //deliveryAddress.text = place.name
            UserDefaults.standard.set(place.name, forKey: "confirmLocation")
        }
        var address = place.placeID
        GetPlacdDataByPlaceID(pPlaceID:address!)
        dismiss(animated: false, completion: nil)
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
        deliveryLocation.pinPointLatitude = currentLocationLat
        deliveryLocation.pinPointLongitude = currentLocationLong
        deliveryLocation.pickUpTag = pickUpAddress.tag
        deliveryLocation.deliveryTag = deliveryAddress.tag
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
                print("\(place.formattedAddress)")
                
                currentLocationLat = place.coordinate.latitude
                currentLocationLong = place.coordinate.longitude
                
                if pickUpAddress.tag == 1 {
                    UserDefaults.standard.set(place.coordinate.latitude, forKey: "pickUpLatitude")
                    UserDefaults.standard.set(place.coordinate.longitude, forKey: "pickUpLongitude")
                }
                
                if deliveryAddress.tag == 2 {
                    UserDefaults.standard.set(place.coordinate.latitude, forKey: "dropLatitude")
                    UserDefaults.standard.set(place.coordinate.longitude, forKey: "dropLongitude")
                }
                navigateToMap()
             
            } else {
                print("No place details for \(pPlaceID)")
            }
        })
    }

}



