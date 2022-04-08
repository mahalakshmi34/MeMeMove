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



