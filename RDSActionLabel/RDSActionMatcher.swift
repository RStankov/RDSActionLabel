//
//  RDSActionMatcher.swift
//  RDSActionLabel
//
//  Created by Radoslav Stankov on 1/2/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import Foundation

typealias RDSActionHandler = ((String) -> ())

let RDSActionNoopHandler: RDSActionHandler = { (arg: String) in }

class RDSActionMatcher {
    private let regexp: NSRegularExpression

    let handle: RDSActionHandler
    let color: UIColor
    let selectedColor: UIColor

    init(pattern : String, color : UIColor, selectedColor : UIColor? = nil, handle : RDSActionHandler? = nil ) {
        self.regexp = try! NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])

        self.color = color
        self.selectedColor = selectedColor ?? color

        if let handle = handle {
            self.handle = handle
        } else {
            self.handle = RDSActionNoopHandler
        }
    }

    func isMatching(string: String) -> Bool {
        let results = regexp.matchesInString(string, options: [], range: NSRange(location: 0, length: string.characters.count))
        return results.count > 0
    }
}