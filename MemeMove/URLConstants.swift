//
//  AppSession.swift
//  MemeMove
//
//  Created by Vijay Raj on 06/04/22.
//

import Foundation

struct APPURL {
    private struct Domains {
        static let Dev = "https://api.mememove.com:8443/MeMeMove/"
    }
    
    private static let Domain = Domains.Dev
    private static let BaseURL = Domain.self
    
    static var registerUser : String {
        return BaseURL + "User/Registration/user?"
    }
    
    static var userLogin :String {
        return BaseURL + "User/login/user?"
    }
    static var forgotPassword :String {
        return BaseURL + "User/forgot/password?"
    }
    
    static var confirmOtp :String {
        return BaseURL + "User/confirm/otp/verfication?"
    }
    
    static var generatePassword :String {
        return BaseURL + "User/reset/password/user?"
    }
}
