//
//  AuthorDetail.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation
import RealmSwift
import Realm

enum RatingRange {
    case bad
    case medium
    case good
}

class AuthorDetail: Object, Decodable {
    
    @objc dynamic var username: String?
    @objc dynamic var name: String?
    @objc dynamic var avatarPath: String?
    @objc dynamic var rating: Double = 0.0
   
    var ratingRate: RatingRange {
        if rating <= 5 {
            return .bad
        } else if rating > 5 && rating <= 7.5 {
            return .medium
        } else {
            return .good
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case name = "name"
        case avatarPath = "avatar_path"
        case rating = "rating"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        username = try values.decode(String.self, forKey: .username)
        name = try? values.decodeIfPresent(String.self, forKey: .name)
        avatarPath = try? values.decodeIfPresent(String.self, forKey: .avatarPath)
        rating = try values.decode(Double.self, forKey: .rating)
    }
    
    override static func primaryKey() -> String? {
        return "username"
    }
    
    required override init() {
        super.init()
    }
    
}
