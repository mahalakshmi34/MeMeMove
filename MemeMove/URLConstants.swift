//
//  AppSession.swift
//  MemeMove
//
//  Created by Vijay Raj on 06/04/22.
//

import Foundation

struct APPURL {
    private struct Domains {
        static let Dev = "http://api.mememove.com:8080/MeMeMove/"
    }
    
    private static let Domain = Domains.Dev
    private static let BaseURL = Domain.self
    
    static var registerUser : String {
        return BaseURL + "Registration/user?"
    }
    
    static var userLogin :String {
        return BaseURL + "User/login/user?"
    }
    static var forgotPassword :String {
        return BaseURL + "forgot/password?"
    }
    
    static var confirmOtp :String {
        return BaseURL + "confirm/otp/verfication?"
    }
    
    static var generatePassword :String {
        return BaseURL + "reset/password/user?"
    }
}
