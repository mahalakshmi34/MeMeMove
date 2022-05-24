//
//  SelectVehicleTypeViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 28/03/22.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVGKit


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
    var vehicleImage :[String] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateMethod()
        cornerRadius()
        fetchData()
        
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
                }
               
            case .failure(let error):
                print(error)
            }
        })
    }
    
    func fetchData() {
    
        let url = "http://api.mememove.com:8080/MeMeMove/Driver/get/all/VehicleType/ByCity?city=chennai"
        
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
                            vehicleName.append(city)
                        }
                        if let vehicleImg = cityDetail["vimg"].string {
                            print(vehicleImg)
                            vehicleImage.append(vehicleImg)
                      
                        }
                    }
                    
                    collectionView.reloadData()
                   
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vehicleName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectvehicle", for: indexPath)as! VehicleTypeCollectionViewCell
        
        cell.vehicleName.text = vehicleName[indexPath.row]
    
        let url = URL(string: vehicleImage[indexPath.row])!
            print(url)
            if let data = try? Data(contentsOf: url) {
                let receivedimage :SVGKImage = SVGKImage(data: data)
                cell.vehicleType.image = receivedimage.uiImage
                cell.vehicleImage.addShadowToButton(color: UIColor.lightGray, cornerRadius: 20)
        }
    
            
        
        return cell
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
}

