//
//  String+DateFormatter.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation

extension String  {
    
    func toDateFormattedString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale.init(identifier: "en_US")
        
        let date = dateFormatter.date(from: self)

        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none

        return dateFormatter.string(from: date ?? Date())
    }
    
}
