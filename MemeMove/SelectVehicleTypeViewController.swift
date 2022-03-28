//
//  SelectVehicleTypeViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 28/03/22.
//

import UIKit

class SelectVehicleTypeViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        delegateMethod()
        
    }
    
    func delegateMethod() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    

}
