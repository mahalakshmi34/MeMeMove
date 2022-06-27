//
//  FinalBookingViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 08/06/22.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import SocketIO

class FinalBookingViewController: UIViewController,GMSMapViewDelegate,UITextFieldDelegate {
    
    var mSocket = SocketHandler.sharedInstance.getSocket()
    
    var mapView :GMSMapView!
    var geoCoder :CLGeocoder!

    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tenMinsButton: UIButton!
    @IBOutlet weak var meetAtPickPoint: UIButton!
    @IBOutlet weak var driverName: UILabel!
    @IBOutlet weak var vehicleNumber: UILabel!
    @IBOutlet weak var vehicleBrand: UILabel!
    @IBOutlet weak var fareOfDriver: UILabel!
    @IBOutlet weak var toLandMarkLocation: UILabel!
    
    var otpPinNumber = ""
    var nameOfDriver = ""
    var vehicleRegNo = ""
    var vehicleBrandName = ""
    var driverImage = ""
    var toLandMark = ""
    var driverPay = 0.0
    var pinNumber = ""
    var orderID = ""
    var orderItem = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showCurrentLocationOnMap()
        addSubViews()
        socketData()
        getAllOrders()
    }
  
    func socketData() {
        
        if UserDefaults.standard.string(forKey: "confirmOrderId") != nil {
            orderItem = UserDefaults.standard.string(forKey: "confirmOrderId")!
            print(orderItem)
        }

        SocketHandler.sharedInstance.establishConnection()
        mSocket.on(orderItem) { [self]  (args, ack ) -> Void in
            print("test",args , ack)
            
//            if(dataArray[0] != nil){
            let dataReceived :String = args[0] as! String
            print("latlong,\(dataReceived)") 
        }
    
    }
    
    func addSubViews() {
        self.view.bringSubviewToFront(mainView)
        statusView.dropShadow()
        statusView.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        tenMinsButton.layer.cornerRadius = tenMinsButton.frame.height / 2
        meetAtPickPoint.addShadowToButton(cornerRadius: 10)
    }
    
    func getAllOrders() {
        
        if UserDefaults.standard.string(forKey: "confirmOrderId") != nil {
            orderID =  UserDefaults.standard.string(forKey: "confirmOrderId")!
            print(orderID)
        }
        
        
        let url =
        "https://api.mememove.com:8443/MeMeMove/Order/get/order/id?id=\(orderID)"
        AF.request(url, method: .get).responseJSON { [self] response in
            print("isiLagi: \(response)")
            switch response.result {
            case .success(let data):
                print("isi: \(data)")
                let json = JSON(data)
                print(json)
                
                if let pinNumber = json["pin"].string {
                    otpPinNumber = pinNumber
                    UserDefaults.standard.set(otpPinNumber, forKey: "otpPinNumber")
                }
                
                if let driverNames = json["drivername"].string {
                    nameOfDriver = driverNames
                    UserDefaults.standard.set(nameOfDriver, forKey: "driverName")
                }
                
                if let vehicleNumber = json["vehicleRegno"].string {
                    print(vehicleNumber)
                    vehicleRegNo = vehicleNumber
                    UserDefaults.standard.set(vehicleRegNo, forKey: "vehicleRegNo")
                }
                
                if let vehicleBrandNames = json["vehicleBrand"].string {
                    print(vehicleBrandNames)
                    vehicleBrandName = vehicleBrandNames
                    UserDefaults.standard.set(vehicleBrandName, forKey: "vehicleBrand")
                }
                
                if let driverImg = json["driverImg"].string {
                    print(driverImg)
                    driverImage = driverImg
                    UserDefaults.standard.set(driverImage, forKey: "driverImg")
                }
                
                if let landMark = json["tolandmark"].string {
                    print(landMark)
                  toLandMark = landMark
                    UserDefaults.standard.set(toLandMark, forKey: "toLandmark")
                }
                
                if let driverFare = json["driverpay"].double {
                    print(driverFare)
                    driverPay = driverFare
                    UserDefaults.standard.set(driverPay, forKey: "driverPay")
                }
                
                if let pinNumbers = json["pin"].string {
                    print(pinNumbers)
                    pinNumber = pinNumbers
                    UserDefaults.standard.set(pinNumber, forKey: "pinNumber")
                }
          
                fetchData()
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func fetchData() {
        
        if UserDefaults.standard.string(forKey: "driverName") != nil {
            driverName.text = UserDefaults.standard.string(forKey: "driverName")
        }
        
        if UserDefaults.standard.string(forKey: "toLandmark") != nil {
            toLandMarkLocation.text =  UserDefaults.standard.string(forKey: "toLandmark")
        }
        
        if UserDefaults.standard.double(forKey: "driverpay") != nil {
            
            let fareCalculation = UserDefaults.standard.double(forKey: "driverpay")
            
            fareOfDriver.text = String(fareCalculation)
        }
        
        if UserDefaults.standard.string(forKey: "vehicleRegno") != nil {
            
            vehicleNumber.text =  UserDefaults.standard.string(forKey: "vehicleRegno")
        }
        
        if UserDefaults.standard.string(forKey: "pinNumber") != nil {
            
        }
    }
    
    
         
    func showCurrentLocationOnMap() {
           
        let camera = GMSCameraPosition.camera(withLatitude: -33.26, longitude: 151.20, zoom: 12.0)
        mapView = GMSMapView.map(withFrame: self.view.frame , camera: camera)
        mapView.settings.compassButton = true
        mapView.settings.myLocationButton = true
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
        self.view.addSubview(mapView)
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: -33.26, longitude: 151.20)
        marker.isDraggable = true
        marker.map = mapView
        self.mapView.delegate = self
        marker.isDraggable = true
        marker.tracksInfoWindowChanges = true
        marker.map = mapView
        self.mapView.delegate = self
        addSubViews()
    }
    
    @IBAction func textfield(_ sender: UITextField) {
        UIView.transition(with: mainView, duration: 0.33,
                          options: .curveEaseOut,
                          animations: { [self] in
            mainView.removeFromSuperview()
          },
          completion: nil
        )
       
  }
}
