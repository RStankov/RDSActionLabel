//
//  RDSAnnotatedMatcher.swift
//  RDSAnnotatedLabel
//
//  Created by Radoslav Stankov on 1/2/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import Foundation

typealias RDSAnnotatedHandler = ((String) -> ())

let rdsAnnotatedNoopHandler: RDSAnnotatedHandler = { (arg: String) in }

class RDSAnnotatedMatcher {
    private let regexp: NSRegularExpression

    let handle: RDSAnnotatedHandler
    let color: UIColor
    let selectedColor: UIColor

    init(pattern : String, color : UIColor, selectedColor : UIColor? = nil, handle : RDSAnnotatedHandler? = nil ) {
        self.regexp = try! NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])

        self.color = color
        self.selectedColor = selectedColor ?? color

        if let handle = handle {
            self.handle = handle
        } else {
            self.handle = rdsAnnotatedNoopHandler
        }
    }

    func isMatching(string: String) -> Bool {
        let results = regexp.matchesInString(string, options: [], range: NSRange(location: 0, length: string.characters.count))
        return results.count > 0
    }
}