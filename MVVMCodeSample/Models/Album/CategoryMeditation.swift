//
//  CategoryMeditation.swift
//  MVVMCodeSample
//
//  Created by Tejas Ardeshna on 10/08/17.
//  Copyright © 2017 Tejas Ardeshna. All rights reserved.
//

import Foundation
import ObjectMapper

class CategoryMeditation : Mappable{
    
    var categoriesId : Int?
    var createdAt : AnyObject?
    var id : Int?
    var meditationsId : Int?
    required init?(map: Map) {
        
    }
    func mapping(map: Map)
    {
        categoriesId <- map["categories_id"]
        createdAt <- map["created_at"]
        id <- map["id"]
        meditationsId <- map["meditations_id"]
        
    }
    
}
