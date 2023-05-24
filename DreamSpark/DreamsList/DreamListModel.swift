//
//  DreamListModel.swift
//  DreamSpark
//
//  Created by SIDHUDEVARAYAN K C on 21/10/21.
//

import Foundation
import ObjectMapper

struct DreamListModel : Mappable {
    var success : Bool?
    var message : String?
    var data : [DreamDataList]?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
    }
}

struct DreamDataList : Mappable {
    var id : Int?
    var uuid : String?
    var title : String?
    var device_token : String?
    var description : String?
    var dreams_comments : [DreamCommentList]?
    var dreams_likes : Int?
    var dreams_dislikes : Int?
    var isLike : Int?
    var created_at : String?
    var deleted_at : String?
    var updated_at : String?
    var collapsed: Bool = false
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        uuid <- map["uuid"]
        device_token <- map["device_token"]
        title <- map["title"]
        description <- map["description"]
        dreams_comments <- map["dreams_comments"]
        dreams_likes <- map["dreams_likes"]
        dreams_dislikes <- map["dreams_dislikes"]
        isLike <- map["isLike"]
        deleted_at <- map["created_at"]
        created_at <- map["created_at"]
        updated_at <- map["created_at"]
    }
}

struct DreamCommentList : Mappable {
    var id : Int?
    var uuid : String?
    var dream_uuid : String?
    var device_token : String?
    var comment : String?
    var created_at : String?
    var deleted_at : String?
    var updated_at : String?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        uuid <- map["uuid"]
        device_token <- map["device_token"]
        dream_uuid <- map["dream_uuid"]
        comment <- map["comment"]
        deleted_at <- map["created_at"]
        created_at <- map["created_at"]
        updated_at <- map["created_at"]
    }
}


enum DreamType : String, CaseIterable {
    case GENERAL
    case PREMEIUM
    case PREMEIUMLIST
}


struct DreamUploadModel : Mappable {
    var success : Bool?
    var message : String?
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
    }
}
