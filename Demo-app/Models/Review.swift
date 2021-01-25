//
//  Review.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation
import RealmSwift
import Realm

class Review: Object, Decodable {
    
    @objc dynamic var id: String?
    @objc dynamic var author: String?
    @objc dynamic var content: String?
    @objc dynamic var createdDate: String?
    @objc dynamic var details: AuthorDetail?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case author = "author"
        case content = "content"
        case createdDate = "created_at"
        case details = "author_details"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try? values.decodeIfPresent(String.self, forKey: .id)
        author = try? values.decodeIfPresent(String.self, forKey: .author)
        content = try? values.decodeIfPresent(String.self, forKey: .content)
        createdDate = try? values.decodeIfPresent(String.self, forKey: .createdDate)
        details = try? values.decodeIfPresent(AuthorDetail.self, forKey: .details)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required override init() {
        super.init()
    }
    
}
