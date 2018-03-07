//
//  Track.swift
//  MVVMCodeSample
//
//  Created by Tejas Ardeshna on 10/08/17.
//  Copyright © 2017 Tejas Ardeshna. All rights reserved.
//

import Foundation
import ObjectMapper

class Track : Mappable{
    
    var audio : String?
    var createdAt : String?
    var id : Int?
    var meditationId : Int?
    var meditationType : Int?
    var name : String?
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map)
    {
        audio <- map["audio"]
        createdAt <- map["created_at"]
        id <- map["id"]
        meditationId <- map["meditation_id"]
        meditationType <- map["meditation_type"]
        name <- map["name"]
        
    }
    
}
