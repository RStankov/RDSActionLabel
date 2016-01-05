//
//  RDSActiveMatcher.swift
//  RDSActiveLabel
//
//  Created by Radoslav Stankov on 1/2/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import Foundation

typealias RDSActiveHandler = ((String) -> ())

let RDSActiveNoopHandler: RDSActiveHandler = { (arg: String) in }

class RDSActiveMatcher {
    private let regexp: NSRegularExpression

    let handle: RDSActiveHandler
    let color: UIColor
    let selectedColor: UIColor

    init(pattern : String, color : UIColor, selectedColor : UIColor? = nil, handle : RDSActiveHandler? = nil ) {
        self.regexp = try! NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])

        self.color = color
        self.selectedColor = selectedColor ?? color

        if let handle = handle {
            self.handle = handle
        } else {
            self.handle = RDSActiveNoopHandler
        }
    }

    func isMatching(string: String) -> Bool {
        let results = regexp.matchesInString(string, options: [], range: NSRange(location: 0, length: string.characters.count))
        return results.count > 0
    }
}