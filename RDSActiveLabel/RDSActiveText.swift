//
//  RDSAnnotatedText.swift
//  RDSAnnotatedLabel
//
//  Created by Radoslav Stankov on 1/2/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import Foundation

class RDSAnnotatedText : Equatable {
    private let matcher: RDSAnnotatedMatcher;
    private let string: String

    let range: NSRange

    init(range: NSRange, string: String, matcher: RDSAnnotatedMatcher) {
        self.range = range
        self.string = string
        self.matcher = matcher;
    }

    func color(isSelected: Bool = false) -> UIColor {
        return isSelected ? matcher.selectedColor : matcher.color
    }

    func handle() {
        matcher.handle(string)
    }

    func inRange(index: Int) -> Bool {
        return index >= range.location && index <= range.location + range.length
    }
}

func ==(lhs: RDSAnnotatedText, rhs: RDSAnnotatedText) -> Bool {
    return lhs.string == rhs.string && lhs.range.location == rhs.range.location && lhs.range.length == rhs.range.length
}