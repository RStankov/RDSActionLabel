//
//  RDSActionText.swift
//  RDSActionLabel
//
//  Created by Radoslav Stankov on 1/2/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import XCTest

@testable import RDSActionLabel

class RDSActionTextTests: XCTestCase {
    private lazy var matcher: RDSActionMatcher = RDSActionMatcher(pattern: "test", color: UIColor.black, selectedColor: UIColor.red)

    func testEquality() {
        let text = RDSActionText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)
        let same = RDSActionText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)
        let other = RDSActionText(range: NSMakeRange(0, 11), string: "test", matcher: matcher)

        XCTAssert(text == same)
        XCTAssert(text != other)
    }

    func testTextInRange() {
        let text = RDSActionText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        XCTAssert(text.inRange(index: 5))
        XCTAssertFalse(text.inRange(index: 20))
    }

    func testTextColor() {
        let text = RDSActionText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        XCTAssertEqual(text.color(), matcher.color)
        XCTAssertEqual(text.color(isSelected: false), matcher.color)
        XCTAssertEqual(text.color(isSelected: true), matcher.selectedColor)
    }

    func testTextHandle() {
        var passedText = "not called"
        let matcher = RDSActionMatcher(pattern: "test", color: UIColor.black) { passedText = $0 }
        let text = RDSActionText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        text.handle()
        
        XCTAssertEqual(passedText, "test")
    }
}
