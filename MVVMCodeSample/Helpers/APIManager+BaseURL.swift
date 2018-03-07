//
//  APIManager+BaseURL.swift
//  MVVMCodeSample
//
//  Created by Tejas Ardeshna on 07/03/18.
//  Copyright © 2018 Tejas Ardeshna. All rights reserved.
//

import Foundation

extension APIManager
{
    public class APIConstants {
        
        // URL construction
        static let baseUrl: String                = Bundle.main.infoDictionary!["MY_API_BASE_URL_ENDPOINT"] as! String
        static let APIVersion: String             = "v1"
        static let loginEndpoint : String         = "login"
        static let allMeditationEndpoint : String = "meditation"
        static let logoutEndpoint: String         = "logout"
    }
    
    func makeAppUrl(endpoint: String) -> String
    {
        // NB: include trailing slashes in APP URL strings!
        let url = "\(APIConstants.baseUrl)/\(APIConstants.APIVersion)/\(endpoint)"
        return url
    }
}

enum APIResult : NSInteger
{
    case APISuccess = 0,APIFail,APIError
}
