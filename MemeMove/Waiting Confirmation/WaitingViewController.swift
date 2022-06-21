//
//  WaitingViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 07/06/22.
//

import UIKit
import SwiftyJSON

struct Candidate : Codable {
    var orderid : String
    var orderstatus :String
}

class WaitingViewController: UIViewController {
    
    var mSocket = SocketHandler.sharedInstance.getSocket()
    var orderID = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        socketData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func emitFunction() {
        mSocket.emit("driver","connected")
    }
    
//    func map() -> [[String: String]]{
//        var jsonArray: [[String: String]] = [[String: String]]()
//
//        for value in data {
//               let json = (["key1": value.someVariable, "key2": value.someOtherVariable ])
//                jsonArray.append(json as! [String : String])
//            }
//            print(jsonArray)
//            return jsonArray
//        }
 
    
    func socketData() {
        SocketHandler.sharedInstance.establishConnection()
        
        mSocket.on("check") { [self]  (args,ack ) -> Void in
            
//            if(dataArray[0] != nil){
            var dataReceived :JSON = JSON(rawValue: args[0]) ?? ""
            print("hekko,\(dataReceived.arrayValue)")
            
            for datas in dataReceived.arrayValue {
                
                if let orderid = datas["orderid"].string {
                    orderID = orderid
                    print(orderID)
                    UserDefaults.standard.set(orderid, forKey: "orderid")
                }
                
                if let orderStatus = datas["orderstatus"].string {
                    print(orderStatus)
                }
               
                var orderItem = UserDefaults.standard.string(forKey: "confirmOrderId")
               
               print(orderItem!)
            
                
                if orderID ==  orderItem {
                    print("hello",orderItem)
                    
                    let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "FinalBookingViewController") as! FinalBookingViewController
                    self.navigationController?.pushViewController(storyBoard, animated: true)
                    
                    mSocket.disconnect()
                }

        
           // print("testing",dataArray)

//            for e in dataArray {
//
//                //print("s",e)
//            }
        
//            for r in 0 ... dataArray {
//                print("ss",(r))
//            }
//            var jsonString = convertIntoJSONString(arrayObject: dataArray[0] as! [Any])
//            print("jsonString - \(jsonString!)")
//
            
//            for x in 0 ... dataReceived!.count {
//
//                print(x)
//
//              //  var new :JSONObject = jsonString[x] as JSONObject
//            }
            
          
//
//            let jsonData = jsonString?.data(using: .utf8)
//            let decoder = JSONDecoder()
//            decoder.keyDecodingStrategy = .convertFromSnakeCase
           // decoder.dataDecodingStrategy = .secondsSince1970
        
            
//            do {
//                var picture = try JSONDecoder().decode([Candidate].self, from: jsonData!)
//
//                let jsonValue = JSON(jsonData)
//                print(jsonValue)
//
//

//            }
          
//            catch {
//                print(error.localizedDescription)
//            }

            }
        }
    }
    
    func convertIntoJSONString(arrayObject: [Any]) -> String? {

            do {
                let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
                if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                    return jsonString as String
                }
                
            } catch let error as NSError {
                print("Array convertIntoJSON - \(error.description)")
            }
            return nil
        }

}
