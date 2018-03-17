//
//  Utils.swift
//  Tweeter
//
//  Created by Apple on 3/17/18.
//  Copyright © 2018 Apple. All rights reserved.
//

import Foundation
import UIKit

extension Date{
    enum Format: String {
        case yearMonthDay = "yyyy-MM-dd"
        var format: String {
            return rawValue
            
        }
    }
    func convertToString(format:Format) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.format
        let dateString = dateFormatter.string(from:self as Date)
        return dateString
    }
    
}
extension UITextView{
    func numberOfLines() -> Int {
        let layoutManager = self.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        var lineRange: NSRange = NSMakeRange(0, 1)
        var index = 0
        var numberOfLines = 0
        
        while index < numberOfGlyphs {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange)
            numberOfLines += 1
        }
        return numberOfLines
    }
}
