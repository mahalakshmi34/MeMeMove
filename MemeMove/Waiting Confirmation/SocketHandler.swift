//
//  SocketHandler.swift
//  MemeMove
//
//  Created by Vijay Raj on 14/06/22.
//

import UIKit
import SocketIO

class SocketHandler: NSObject {
    
    static let sharedInstance = SocketHandler()
    
    let socket = SocketManager(socketURL: URL(string: "http://e-bikefleet.com:5002")!, config: [.log(true), .compress])
    var mSocket: SocketIOClient!
    
    override init() {
        super.init()
        mSocket = socket.defaultSocket
    }

    func getSocket() -> SocketIOClient {
        return mSocket
    }

    func establishConnection() {
        mSocket.connect()
    }

    func closeConnection() {
        mSocket.disconnect()
    }

}
