//
//  Response.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    
    let page: Int
    let totalpages: Int
    let totalResults: Int
    let data: T?
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalpages = "total_pages"
        case totalResults = "total_results"
        case data = "results"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        page = try values.decode(Int.self, forKey: .page)
        totalpages = try values.decode(Int.self, forKey: .totalpages)
        totalResults = try values.decode(Int.self, forKey: .totalResults)
        data = try? values.decodeIfPresent(T.self, forKey: .data)
    }
    
}
