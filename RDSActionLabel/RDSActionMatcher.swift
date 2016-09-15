//
//  RDSActionMatcher.swift
//  RDSActionLabel
//
//  Created by Radoslav Stankov on 1/2/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import Foundation

public typealias RDSActionHandler = ((String) -> ())

let RDSActionNoopHandler: RDSActionHandler = { (arg: String) in }

class RDSActionMatcher {
    private let regexp: NSRegularExpression

    let handle: RDSActionHandler
    let color: UIColor
    let selectedColor: UIColor

    init(pattern : String, color : UIColor, selectedColor : UIColor? = nil, handle : RDSActionHandler? = nil ) {
        self.regexp = try! NSRegularExpression(pattern: pattern, options: [.caseInsensitive])

        self.color = color
        self.selectedColor = selectedColor ?? color

        if let handle = handle {
            self.handle = handle
        } else {
            self.handle = RDSActionNoopHandler
        }
    }

    func match(_ string:String) -> [NSRange] {
        var ranges = [NSRange]()

        regexp.enumerateMatches(in: string, options: [], range: NSRange(location: 0, length: string.characters.count)) { (result: NSTextCheckingResult?, _, _) in
            if let result = result {
                ranges.append(result.range)
            }
        }
        
        return ranges
    }
}
