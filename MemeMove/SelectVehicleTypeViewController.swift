//
//  SelectVehicleTypeViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 28/03/22.
//

import UIKit

class SelectVehicleTypeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
   
    @IBOutlet weak var editText: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var measureProduct: UIButton!
    @IBOutlet weak var selectVehicle: UIButton!
    @IBOutlet weak var lengthTextField: UITextField!
    @IBOutlet weak var widthTextField: UITextField!
    @IBOutlet weak var heightTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    
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
