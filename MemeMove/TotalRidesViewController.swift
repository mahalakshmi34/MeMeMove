//
//  TotalRidesViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 09/07/22.
//

import UIKit
import Alamofire
import SwiftyJSON

class TotalRidesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var totalRideTableView: UITableView!
    
    var confirmOrderId = ""
    var userID = ""
    var fromArea :[String] = []
    var toArea :[String] = []
    var deliveryStatus :[String] = []
    var deliveredDate :[String] = []
    var statusOfpackage :[String] = []
    var apiResult :[JSON] = []
    var totalRides :[String] = []
    var selectedcells :Int = 0
    var fetchArray :[String] = []
    var testData : JSON = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewDelegate()
        fetchTableView()
    }
    
    func tableViewDelegate() {
        totalRideTableView.delegate = self
        totalRideTableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fromArea.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableView = tableView.dequeueReusableCell(withIdentifier: "totalRides", for: indexPath) as! TotalRidesTableViewCell
        
        tableView.fromRoad.text = fromArea[indexPath.row]
        tableView.toRoad.text = toArea[indexPath.row]
        tableView.labelLine.text = ""
        tableView.onGoingUpdate.text = statusOfpackage[indexPath.row]
        return tableView
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = indexPath.row
        print(cell)
        
        let navigation = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        print(apiResult[cell])
        
        testData = apiResult[cell]
        
       // fetchArray.append(apiResult[cell].rawValue as! String)
        navigation.dataResult = testData
        navigation.itemCell = selectedcells
        self.navigationController?.pushViewController(navigation, animated: true)
    }
    
    
    func fetchTableView() {
        
        if UserDefaults.standard.string(forKey: "userID") != nil {
            userID = UserDefaults.standard.string(forKey: "userID")!
        }
        
    let url = "https://api.mememove.com:8443/MeMeMove/Order/get/all/order/byUser?id=\(userID)"
        
        AF.request(url, method: .get).responseJSON { [self] response in
            print("isiLagi: \(response)")
            switch response.result {
            case .success(let data):
                print("isi: \(data)")
                let json = JSON(data)
                print(json)
                
                let cityDetails = json.arrayValue
                print(cityDetails)
                
                apiResult = json.arrayValue
                
                for cityDetail in cityDetails {
                    if let area = cityDetail["area"].string {
                        print(area)
                        fromArea.append(area)
                    }
                    if let toPlace = cityDetail["toarea"].string {
                        print(toPlace)
                        toArea.append(toPlace)
                    }
                    
                    if let status = cityDetail["deliverystatus"].string {
                        print(status)
                        statusOfpackage.append(status)
                    }
                    
                    if let deliveredData = cityDetail["delivereddate"].string {
                        print(deliveredData)
                        deliveredDate.append(deliveredData)
                    }
                }
             
                totalRideTableView.reloadData()
                
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}
