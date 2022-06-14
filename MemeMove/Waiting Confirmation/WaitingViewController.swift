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

    func socketData() {
        SocketHandler.sharedInstance.establishConnection()
        mSocket.on("counter") { ( dataArray, ack) -> Void in
            let dataReceived = dataArray[0] as! Int
           // self.labelCounter.text = "\(dataReceived)"
        }
    }

}
