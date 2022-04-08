//
//  AppSession.swift
//  MemeMove
//
//  Created by Vijay Raj on 06/04/22.
//

import Foundation

struct APPURL {
    private struct Domains {
        static let Dev = "http://api.mememove.com:8080/MeMeMove/User/"
    }
    
    private static let Domain = Domains.Dev
    private static let BaseURL = Domain.self
    
    static var registerUser : String {
        return BaseURL + "Registration/user?"
    }
}
