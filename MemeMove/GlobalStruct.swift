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

