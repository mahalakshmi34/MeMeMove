//
//  SelectVehicleTypeViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 28/03/22.
//

import UIKit

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateMethod()
        cornerRadius()
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
    }
    
    @IBAction func enterPackageDetail(_ sender: UIButton) {
        
        enterPackageDetails.isHidden = false
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
        alert.popoverPresentationController?.sourceRect = sender.frame
        
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectvehicle", for: indexPath)as! VehicleTypeCollectionViewCell
        let image = UIImage(named: "Group 191")
        cell.vehicleType.image = UIImage(named: "Group 191")
        cell.vehicleImage.addShadowToButton(color: UIColor.lightGray, cornerRadius: 20)
        cell.vehicleName.text = "Car"
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
