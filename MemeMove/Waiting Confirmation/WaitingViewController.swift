//
//  WaitingViewController.swift
//  MemeMove
//
//  Created by Vijay Raj on 07/06/22.
//

import UIKit

class WaitingViewController: UIViewController {
    
    var mSocket = SocketHandler.sharedInstance.getSocket()

    override func viewDidLoad() {
        super.viewDidLoad()
        socketData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func emitFunction() {
        mSocket.emit("driver","connected")
    }
    
    func socketData() {
        SocketHandler.sharedInstance.establishConnection()
        mSocket.on("check") { [self] ( dataArray, ack) -> Void in
            let dataReceived = dataArray[0] as? String
            
            print("\(dataReceived)")
            emitFunction()
           // self.labelCounter.text = "\(dataReceived)"
        }
    }

}
