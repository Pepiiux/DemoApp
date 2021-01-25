//
//  String+HTML.swift
//  Demo-app
//
//  Created by Hector Alvarado on 24/01/21.
//

import Foundation
import UIKit

extension String {
    
    var htmlToAttributedString: NSAttributedString {
        
        guard let data = data(using: .utf8) else {
            return NSAttributedString()
        }
        
        do {
            let htmlAttributedString = try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            let htmlMutableAttributedString: NSMutableAttributedString = NSMutableAttributedString(attributedString: htmlAttributedString)
            let fontAttribute = [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 12)]
            htmlMutableAttributedString.addAttributes(fontAttribute, range: NSRange(location: 0, length: htmlMutableAttributedString.string.count))
            
            return htmlMutableAttributedString
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        
        return htmlToAttributedString.string
    }
    
    var isHTML: Bool {
        let htmlExpression = "<[a-z][\\s\\S]*>"
        let predicate = NSPredicate(format:"SELF MATCHES %@", htmlExpression)
        return predicate.evaluate(with: self)
    }
    
}
