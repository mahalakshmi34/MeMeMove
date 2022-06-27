//
//  WaitingViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 07/06/22.
//

import UIKit
import SwiftyJSON
import SocketIO

struct orderStructure{
    var orderid : String
    var orderstatus : String
}


class WaitingViewController: UIViewController {
    
    var mSocket = SocketHandler.sharedInstance.getSocket()
    var orderID = ""
    var orderStatus = ""
    var orderItem = ""
    var socketConnection : Bool = false
    var logs : [JSON]  = []

    override func viewDidLoad() {
        super.viewDidLoad()
        //SocketHandler.sharedInstance.establishConnection()
        socketData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
      
    }

    
    func emitFunction() {
        mSocket.emit("driver","connected")
    }

    func socketData() {
        SocketHandler.sharedInstance.establishConnection()
        mSocket.on("check") { [self]  (args,ack ) -> Void in
            var dataReceived :JSON = JSON(rawValue: args[0]) ?? ""
            print("hekko,\(dataReceived.arrayValue)")
            
            socketDisconnect()
            
           var filteredArr = dataReceived.arrayValue.filter { dataReceived in
                
                guard let orderid = dataReceived ["orderid"].string, let orderItem =  UserDefaults.standard.string(forKey: "confirmOrderId") else { return false }
                
                return orderid == orderItem
                
//                if let orderid = dataReceived ["orderid"].string {
//                    orderID = orderid
//                    print(orderID)
//                    UserDefaults.standard.set(orderid, forKey: "orderid")
//                }
                
//                if UserDefaults.standard.string(forKey: "confirmOrderId") != nil {
//                 orderItem = UserDefaults.standard.string(forKey: "confirmOrderId")!
//                 print(orderItem)
//             }
//             print("order",orderID)
//
//                if orderID == orderItem {
//
//                    let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "FinalBookingViewController") as! FinalBookingViewController
//
//                    self.navigationController
//                }
//
//                return true
            }
            
            if filteredArr.count > 0 {
                let storyBoard = self.storyboard?.instantiateViewController(withIdentifier: "FinalBookingViewController") as! FinalBookingViewController
                self.navigationController?.pushViewController(storyBoard, animated: true)
            }
            
            socketDisconnect()
           
    
//            innerLoop : for datas in dataReceived.arrayValue {
//                if let orderid = datas ["orderid"].string {
//                    orderID = orderid
//                    print(orderID)
//                    UserDefaults.standard.set(orderid, forKey: "orderid")
//                }
//                if let orderStatusItem = datas["orderstatus"].string {
//                    print(orderStatusItem)
//                    orderStatus = orderStatusItem
//                   UserDefaults.standard.set(orderStatusItem, forKey: "orderStatus")
//                }
//
//            if UserDefaults.standard.string(forKey: "orderStatus") != nil {
//                UserDefaults.standard.string(forKey: "orderStatus")!
//            }
//
//
//            }

        }
    }
    
    
    
    func socketDisconnect() {
        mSocket.disconnect()
        SocketHandler.sharedInstance.mSocket.disconnect()
        SocketHandler.sharedInstance.closeConnection()
        mSocket.removeAllHandlers()
    }
        
       // SocketHandler.sharedInstance.closeConnection()

    
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
