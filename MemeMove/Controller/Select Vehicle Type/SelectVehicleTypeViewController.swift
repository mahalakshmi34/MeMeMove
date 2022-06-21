//
//  SelectVehicleTypeViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 28/03/22.
//

import UIKit
import Alamofire
import SwiftyJSON



class SelectVehicleTypeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
    @IBOutlet weak var editText: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var measureProduct: UIButton!
    @IBOutlet weak var selectVehicle: UIButton!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var enterPackageDetails: UIView!
    @IBOutlet weak var cameraFrontView: UIButton!
    @IBOutlet weak var cameraTopView: UIButton!
    
    var temporaryImagePath = ""
    var temporaryImage = UIImage()
    var imageData = ""
    var imageView = UIImageView()
    var vehicleName :[String] = []
    var vehicleImages :[String] = []
    
    var flatNumber = ""
    var howToReach = ""
    var contactNumber = ""
    var apartmentName = ""
    var dateString = ""
    var currentCity = ""
    var currentState = ""
    var currentCountry = ""
    var toCountry = ""
    var toState = ""
    var toCity = ""
    var pickUpLat = 0.0
    var pickUpLong = 0.0
    var dropLat = 0.0
    var dropLong = 0.0
    var userID = ""
    
    
    var pickUpTagNumber = 1
    var deliveryTagNumber = 2
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateMethod()
        cornerRadius()
        fetchData()
        todaysDate()
        //addOrder()
        
    }
    

    func cornerRadius() {
        editText.useUnderline()
        proceedButton.layer.cornerRadius = 20
        selectVehicle.addShadowToButton(color: UIColor.lightGray, cornerRadius: 10)
        measureProduct.addShadowToButton(color: UIColor.lightGray, cornerRadius: 10)
        lengthTextField.addShadowToTextField(cornerRadius: 20)
        widthTextField.addShadowToTextField(cornerRadius: 20)
        heightTextField.addShadowToTextField(cornerRadius: 20)
        weightTextField.addShadowToTextField(cornerRadius: 20)
        
        enterPackageDetails.layer.cornerRadius = 20
        
        enterPackageDetails.dropShadowOfView()
    }
    
    func delegateMethod() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    @IBAction func measureProduct(_ sender: UIButton) {
        enterPackageDetails.isHidden = true
        cameraFrontView.isHidden = false
        cameraTopView.isHidden = false
    }
    
    @IBAction func enterPackageDetail(_ sender: UIButton) {
        
        enterPackageDetails.isHidden = false
        cameraFrontView.isHidden = true
        cameraTopView.isHidden = true
    }
    
    
    @IBAction func cameraTopView(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { (handler) in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (handler) in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (handler) in
        }))
        alert.popoverPresentationController?.sourceView =  self.view // works for both iPhone & iPad
        //alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = sender.frame
        
        present(alert, animated: true) {
            print("option menu presented")
        }
    }
    
    @IBAction func cameraFrontViewTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Open Camera", style: .default, handler: { (handler) in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (handler) in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (handler) in
        }))
        alert.popoverPresentationController?.sourceView =  self.view // works for both iPhone & iPad
        //alert.popoverPresentationController?.sourceView = self.view
        
       // alert.popoverPresentationController?.sourceRect = sender.frame
        
        present(alert, animated: true) {
            print("option menu presented")
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera;
            imagePicker.delegate = self
            // imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func openGallery(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if  let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) {
            
        var selectedImage :  UIImage?

        if let editedImage  = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            temporaryImage = editedImage
            //self.imageView.image = editedImage
            picker.dismiss(animated: true)
        }
        else if let orginalImage = info[.originalImage] as? UIImage {
            selectedImage = orginalImage
            temporaryImage = orginalImage
            self.imageView.image = orginalImage
            picker.dismiss(animated: true)
        }
        else {
            print("error")
        }
//
        let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? NSURL
        print(imageURL?.absoluteString)
        temporaryImagePath = imageURL?.absoluteString ?? ""
        print(temporaryImagePath)
        
        updateProfile()
        
            picker.dismiss(animated: true, completion: nil)
    }
}
    
    func updateProfile() {
        let url = "https://api.mememove.com:8443/MeMeMove/Order/add/order/image"
        imageData = temporaryImagePath
        let image = UIImage(contentsOfFile: imageData)
        
        let parameter : [String : Any] = [
            "frontimage"  : temporaryImagePath,
            "topimage" : temporaryImagePath
        ]
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Accept" : "application/json"
        ]
        AF.upload(multipartFormData: { [self] multipartFormData in
        for (key,value) in parameter {
        multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)! , withName: key)
        }
            multipartFormData.append(temporaryImage.jpegData(compressionQuality: 0.5)!, withName: "frontimage", fileName: "uploadimage.jpeg", mimeType: "image/jpeg")
            multipartFormData.append(temporaryImage.jpegData(compressionQuality: 0.5)!, withName: "topimage", fileName: "uploadimage.jpeg", mimeType: "image/jpeg")
            
        },
        to: url,method: .post,headers: headers).responseJSON(completionHandler: { [self]response in
            print(response)
            switch response.result {
            case .success(let data):
                print("isi: \(data)")
                
            let json = JSON(data)
            print(json)
                
                if let frontImage = json["front"].string {
                    print(frontImage)
                    UserDefaults.standard.set(frontImage, forKey: "frontImage")
                }
                
                if let backImage = json["back"].string {
                    print(backImage)
                    UserDefaults.standard.set(backImage, forKey: "backImage")
                }
               
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func fetchData() {
        if UserDefaults.standard.string(forKey: "currentLocationCity") != nil {
            currentCity = UserDefaults.standard.string(forKey: "currentLocationCity")!
        }
        if UserDefaults.standard.string(forKey: "currentLocationState") != nil {
            currentState = UserDefaults.standard.string(forKey: "currentLocationState")!
        }
        if UserDefaults.standard.string(forKey: "currentLocationCountry") != nil {
            currentCountry = UserDefaults.standard.string(forKey: "currentLocationCountry")!
        }
    
   let url = "https://api.mememove.com:8443/MeMeMove/Driver/get/all/VehicleType/ByLocation?country=\(currentCountry)"
        
//"https://api.mememove.com:8443/MeMeMove/Driver/get/all/VehicleType/ByLocation?country=\(currentCountry)&state=Tamil Nadu&city=\(currentCity)"
        print(url)
        
        AF.request(url, method: .get).responseJSON { [self] response in
            print("isiLagi: \(response)")
            switch response.result {
            case .success(let data):
                print("isi: \(data)")
                let json = JSON(data)
                print(json)
                let cityDetails = json.arrayValue
                
                for cityDetail in cityDetails {
                    if let city = cityDetail["city"].string {
                        print(city)
                        vehicleName.append(city)
                    }
                    if let vehicleImg = cityDetail["vimg"].string {
                        print(vehicleImg)
                        vehicleImages.append(vehicleImg)
                        print(vehicleImages.count)
                    }
                }
                collectionView.reloadData()
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
        
       
    }
    
    func todaysDate() {
        
            var startDate = ""
            var endDate  = ""
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let now = Date()
            dateString = formatter.string(from:now)
            print(dateString)
    }
    
   func addOrder() {
       if UserDefaults.standard.string(forKey: "currentLocationState") != nil {
           currentState = UserDefaults.standard.string(forKey: "currentLocationState")!
       }
       if UserDefaults.standard.string(forKey: "currentLocationCity") != nil {
           currentCity = UserDefaults.standard.string(forKey: "currentLocationCity")!
       }
       if UserDefaults.standard.string(forKey: "currentLocationCountry") != nil {
           currentCountry = UserDefaults.standard.string(forKey: "currentLocationCountry")!
       }
       if UserDefaults.standard.integer(forKey: "pickUpTag") == 1 {
           UserDefaults.standard.string(forKey: "fromCountry")
           UserDefaults.standard.string(forKey: "fromState")
           UserDefaults.standard.string(forKey: "fromCity")
          pickUpLat =  UserDefaults.standard.double(forKey: "pickUpLatitude")
           pickUpLong = UserDefaults.standard.double(forKey: "pickUpLongitude")
           
       }
     if UserDefaults.standard.integer(forKey: "deliveryTag") == 2 {
         toCountry = UserDefaults.standard.string(forKey: "toCountry")!
         toState = UserDefaults.standard.string(forKey: "toState")!
         toCity = UserDefaults.standard.string(forKey: "toCity")!
         dropLat = UserDefaults.standard.double(forKey: "dropLatitude")
         dropLong = UserDefaults.standard.double(forKey: "dropLongitude")
    }
       
       if UserDefaults.standard.string(forKey: "userID") != nil {
           userID = UserDefaults.standard.string(forKey: "userID")!
       }
       
       
       var username = ""
       var userphoneno = ""
       
let url =
       
"https://api.mememove.com:8443/MeMeMove/Order/add/Order?landmark=\(currentCity)&city=\(currentCity)&state=\(currentState)&country=\(currentCountry)&fromlat=\(pickUpLat)&fromlong=\(pickUpLong)&deliverytype=FAST&orderdate=\(dateString)&length=23.0&breath=40.0&height=30.0&toflatno=\(flatNumber)&tolandmark=\(toCity)&tocity=\(toCity)&tostate=\(toState)&tocountry=\(toCountry)&toname=\(howToReach)&tophoneno=\(contactNumber)&tolat=\(dropLat)&tolong=\(dropLong)&userid=\(userID)"
    print(url)

            let header : HTTPHeaders = ["Content-Type": "application/json"]
      
       AF.request(url, method: .post, encoding: JSONEncoding.default, headers: header)
           .responseJSON { [self] response in
           print("isiLagi: \(response)")
           switch response.result {
           case .success(let data):
           print("isi: \(data)")
           let json = JSON(data)
           print(json)
               
               if let orderID = json["orderid"].int {
                   print(orderID)
                   UserDefaults.standard.set(orderID, forKey: "orderID")
               }
               
               if let orderName = json["ordername"].string {
                   print(orderName)
                   UserDefaults.standard.set(orderName, forKey: "orderName")
               }
               
               if let userPay = json["userpay"].double {
                   print(userPay)
                   UserDefaults.standard.set(userPay, forKey: "userPay")
               }
               
               if let flatNumber = json["flatno"].int {
                   print(flatNumber)
                   UserDefaults.standard.set(flatNumber, forKey: "flatNumber")
               }
               
               if let apartment = json["apartment"].string {
                   print(apartment)
                   UserDefaults.standard.set(apartment, forKey: "apartmentName")
               }
               
               if let username = json["username"].string {
                   print(username)
                   UserDefaults.standard.set(username, forKey: "username")
               }
               
               if let userphoneno = json["userphoneno"].string {
                   print(userphoneno)
                   UserDefaults.standard.set(userphoneno, forKey: "userphoneno")
               }
               
               if let driverid = json["driverid"].int {
                   print(driverid)
                   UserDefaults.standard.set(driverid, forKey: "driverid")
               }
               
               if let driverName = json["drivername"].string {
                   print(driverName)
                   UserDefaults.standard.set(driverName, forKey: "driverName")
               }
               
               if let driverPhoneno = json["driverphoneno"].string {
                   print(driverPhoneno)
                   UserDefaults.standard.set(driverPhoneno, forKey: "driverphoneno")
               }
               
               if let driverPay = json["driverpay"].double {
                   print(driverPay)
                   UserDefaults.standard.set(driverPay, forKey: "driverPay")
               }
               
               if let toName = json["toname"].string {
                   print(toName)
                   UserDefaults.standard.set(toName, forKey: "toName")
               }
               
               if let toPhoneNumber = json["tophoneno"].string {
                   print(toPhoneNumber)
                   UserDefaults.standard.set(toPhoneNumber, forKey: "toPhoneNumber")
               }
               
               if let deliveryStatus = json["deliverystatus"].string {
                   print(deliveryStatus)
                   UserDefaults.standard.set(deliveryStatus, forKey: "deliveryStatus")
               }
               
               
               
            navigateToPayment()
        
           case .failure(let error):
               print("Request failed with error: \(error)")
               }
           }
        }

    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicleImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectvehicle", for: indexPath)as! VehicleTypeCollectionViewCell
        
        cell.vehicleName.text = vehicleName[indexPath.row]
        
       
            let imageURL   = URL(string: "https://mylogantown.s3.amazonaws.com/mememove/Pearl-Phoenix-Reda.png")
            print(imageURL!)
            DispatchQueue.main.async {
                if let imageData = try? Data(contentsOf: imageURL!) {

                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    cell.vehicleType.image = image
                }
                    
                }
            
        }
        
    // just not to cause a deadlock in UI!
                  
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vehicleName = vehicleName[indexPath.row]
        print(vehicleName)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 150, height:150)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
    }
    
    func navigateToPayment() {
        let payment = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        self.navigationController?.pushViewController(payment, animated: true)
    }
    
    @IBAction func proceedButton(_ sender: UIButton) {
        
        addOrder()
    }
    
}

extension UIView {
    func dropShadowOfView(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
