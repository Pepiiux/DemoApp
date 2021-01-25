//
//  Movie.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation
import RealmSwift
import Realm

class Movie: Object, Decodable {
    
    @objc dynamic var id = 0
    @objc dynamic var adult: Bool = false
    @objc dynamic var backdropPath: String?
    @objc dynamic var originalLanguage: String?
    @objc dynamic var originalTitle: String?
    @objc dynamic var overview: String?
    @objc dynamic var popularity: Double = 0.0
    @objc dynamic var posterPath: String?
    @objc dynamic var releaseDate: String?
    @objc dynamic var title: String?
    @objc dynamic var video: Bool = false
    @objc dynamic var voteAverage: Double = 0.0
    @objc dynamic var voteCount = 0
    
    var ratingRate: RatingRange {
        if voteAverage <= 5 {
            return .bad
        } else if voteAverage > 5 && voteAverage <= 7.5 {
            return .medium
        } else {
            return .good
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case adult = "adult"
        case backdropPath = "backdrop_path"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview = "overview"
        case popularity = "popularity"
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title = "title"
        case video = "video"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int.self, forKey: .id)
        adult = try values.decode(Bool.self, forKey: .adult)
        backdropPath = try values.decode(String.self, forKey: .backdropPath)
        originalLanguage = try values.decode(String.self, forKey: .originalLanguage)
        originalTitle = try values.decode(String.self, forKey: .originalTitle)
        overview = try values.decode(String.self, forKey: .overview)
        popularity = try values.decode(Double.self, forKey: .popularity)
        posterPath = try values.decode(String.self, forKey: .posterPath)
        releaseDate = try values.decode(String.self, forKey: .releaseDate)
        title = try values.decode(String.self, forKey: .title)
        video = try values.decode(Bool.self, forKey: .video)
        voteAverage = try values.decode(Double.self, forKey: .voteAverage)
        voteCount = try values.decode(Int.self, forKey: .voteCount)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required override init() {
        super.init()
    }
    
}
