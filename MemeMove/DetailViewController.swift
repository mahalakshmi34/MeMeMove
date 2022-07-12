//
//  DetailViewController.swift
//  Pods
//
//  Created by Vijay Raj on 12/07/22.
//

import UIKit
import SwiftyJSON
import Alamofire

class DetailViewController: UIViewController {
    
    @IBOutlet var vehicleType: UILabel!
    @IBOutlet var driverNumber: UILabel!
    @IBOutlet var dateandTime: UILabel!
    @IBOutlet var RideType: UILabel!
    @IBOutlet var pickUpLocation: UILabel!
    @IBOutlet var dropLocation: UILabel!
    
    var dataResult : JSON = []
    var itemCell :Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    
    func fetchData() {
        print(dataResult)
        print(itemCell)
        
          
        
        
    }
}
