//
//  GlobalStruct.swift
//  MemeMove
//
//  Created by Vijay Raj on 06/04/22.
//

import Foundation
import UIKit

struct Login {
    var message : String
    var userid :String
    
    enum CodingKeys :String,CodingKey {
        case message
        case userid
    }
}

struct userRegistration {
    var message :String
    
    enum CodingKeys : String,CodingKey {
        case message
    }
}

struct forgotPassword {
    var message :String
    
    enum CodingKeys :String,CodingKey {
        case message
    }
}

struct confirmOtp {
    var message :String
    
    enum CodingKeys :String,CodingKey {
        case message
    }
}

struct addOrderItems {
    var orderid : Int
    var ordername :String
    var flatno : Int
    var apartment : String
    var area :String
    var landmark :String
    var city :String
    var state :String
    var country :String
    var fromlat :Double
    var fromlong :Double
    var deliverytype: String
    var orderimg :String
    var orderdate :String
    var length : Double
    var breath :Double
    var height :Double
    var weight :Double
    var userid : Int
    var username : String
    var userphoneno :String
    var userpay : Double
    var vehicletype : String
    var driverid : Int
    var drivername : String
   
    
    enum CodingKeys :String,CodingKey {
        case orderid
        case ordername
        case flatno
        case apartment
        case landmark
        case city
        case state
        case country
    }
}

