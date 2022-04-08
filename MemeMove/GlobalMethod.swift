//
//  GlobalMethod.swift
//  MemeMove
//
//  Created by Vijay Raj on 06/04/22.
//

import Foundation
import Alamofire


func URLRequests(parameter: Parameters? = nil, method: HTTPMethod, url: String, header: HTTPHeaders? = nil , completion: @escaping (Data?) -> ()) {
    AF.request(url, method: method, parameters: parameter, headers: header).responseJSON { (value) in
        if let data = value.data {
            completion(data)
        } else {
            completion(nil)
        }
    }
}

func registerUserApi(userName:String,emailID:String,password:String,userRefferalCode:String,completionHandler:@escaping (registerUser? , Error?) -> Void) {
    let url = APPURL.registerUser
    let param: Parameters = ["username":userName,"emailID" : emailID,"password":password,"userRefferalCode":userRefferalCode]
    URLRequests(parameter: param, method: .post, url: url) { (data) in
        if let data = data {
            do {
                let resp = try JSONDecoder().decode(registerUser.self, from: data)
                completionHandler(resp, nil)
            } catch {
                print(error)
                completionHandler(nil, error)
            }
        }
    }
}



