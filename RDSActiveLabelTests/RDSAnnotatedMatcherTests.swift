//
//  RDSActiveLabelTests.swift
//  RDSActiveLabel
//
//  Created by Radoslav Stankov on 1/2/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import XCTest

@testable import RDSActiveLabel

class RDSActiveMatcherTests: XCTestCase {

    func testMatcherIsMatching() {
        let matcher = RDSActiveMatcher(pattern: "[a-z]+", color: UIColor.blackColor())

        XCTAssert(matcher.isMatching("text"))
        XCTAssertFalse(matcher.isMatching("0987654321"))
    }

    func testMatcherSelectedColor() {
        let matcher = RDSActiveMatcher(pattern: "test", color: UIColor.blackColor())
        let matcher2 = RDSActiveMatcher(pattern: "test", color: UIColor.blackColor(), selectedColor: UIColor.redColor())

        XCTAssertEqual(matcher.color, matcher.selectedColor)
        XCTAssertEqual(matcher2.selectedColor, UIColor.redColor())
    }

    func testTextInRange() {
        let matcher = RDSActiveMatcher(pattern: "test", color: UIColor.blackColor())
        let text = RDSActiveText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        XCTAssert(text.inRange(5))
        XCTAssertFalse(text.inRange(20))
    }

    func testTextColor() {
        let matcher = RDSActiveMatcher(pattern: "test", color: UIColor.blackColor(), selectedColor: UIColor.redColor())
        let text = RDSActiveText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        XCTAssertEqual(text.color(), matcher.color)
        XCTAssertEqual(text.color(false), matcher.color)
        XCTAssertEqual(text.color(true), matcher.selectedColor)
    }

    func testTextHandle() {
        var passedText = "not called"
        let matcher = RDSActiveMatcher(pattern: "test", color: UIColor.blackColor()) { passedText = $0 }
        let text = RDSActiveText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        text.handle()

        XCTAssertEqual(passedText, "test")
    }
}