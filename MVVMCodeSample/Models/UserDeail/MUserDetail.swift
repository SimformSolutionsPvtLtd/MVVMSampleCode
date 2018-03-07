//
//  MUserDetail.swift
//  MeditateMe
//
//  Created by Tejas Ardeshna on 10/05/17.
//  Copyright © 2017 Tejas Ardeshna. All rights reserved.
//

import UIKit
import ObjectMapper

class MUserDetail : NSObject, NSCoding, Mappable{
    
    var result : Result?
    
  
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        result <- map["result"]
        
    }
    
    
    @objc required init(coder aDecoder: NSCoder)
    {
        result = aDecoder.decodeObject(forKey: "result") as? Result
        
    }
   
    func encode(with aCoder: NSCoder)
    {
        if result != nil{
            aCoder.encode(result, forKey: "result")
        }
        
    }
    
}


