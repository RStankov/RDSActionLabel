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
    private lazy var matcher = RDSActionMatcher(pattern: "test", color: UIColor.blackColor(), selectedColor: UIColor.redColor())

    func testEquality() {
        let text = RDSActionText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)
        let same = RDSActionText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)
        let other = RDSActionText(range: NSMakeRange(0, 11), string: "test", matcher: matcher)

        XCTAssert(text == same)
        XCTAssert(text != other)
    }

    func testTextInRange() {
        let text = RDSActionText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        XCTAssert(text.inRange(5))
        XCTAssertFalse(text.inRange(20))
    }

    func testTextColor() {
        let text = RDSActionText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        XCTAssertEqual(text.color(), matcher.color)
        XCTAssertEqual(text.color(false), matcher.color)
        XCTAssertEqual(text.color(true), matcher.selectedColor)
    }

    func testTextHandle() {
        var passedText = "not called"
        let matcher = RDSActionMatcher(pattern: "test", color: UIColor.blackColor()) { passedText = $0 }
        let text = RDSActionText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        text.handle()
        
        XCTAssertEqual(passedText, "test")
    }
}