//
//  RDSActionLabelTests.swift
//  RDSActionLabel
//
//  Created by Radoslav Stankov on 1/2/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import XCTest

@testable import RDSActionLabel

class RDSActionMatcherTests: XCTestCase {
    func testMatcherSelectedColor() {
        let matcher = RDSActionMatcher(pattern: "test", color: UIColor.black)
        let matcher2 = RDSActionMatcher(pattern: "test", color: UIColor.black, selectedColor: UIColor.red)

        XCTAssertEqual(matcher.color, matcher.selectedColor)
        XCTAssertEqual(matcher2.selectedColor, UIColor.red)
    }

    func testTextInRange() {
        let matcher = RDSActionMatcher(pattern: "test", color: UIColor.black)
        let text = RDSActionText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        XCTAssert(text.inRange(index: 5))
        XCTAssertFalse(text.inRange(index: 20))
    }

    func testTextColor() {
        let matcher = RDSActionMatcher(pattern: "test", color: UIColor.black, selectedColor: UIColor.red)
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

    func testmatchWithPattern() {
        let matcher = RDSActionMatcher(pattern: "[a-z]+", color: UIColor.black)

        let result = matcher.match(" test ")

        let expectedRange = NSMakeRange(1, 4)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first!.length, expectedRange.length)
        XCTAssertEqual(result.first!.location, expectedRange.location)
    }

    func testmatchWithMultiplematch() {
        let matcher = RDSActionMatcher(pattern: "word", color: UIColor.black)

        let result = matcher.match("word and word")

        let firstRange = NSMakeRange(0, 4)

        let secondRange = NSMakeRange(9, 4)

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first!.length, firstRange.length)
        XCTAssertEqual(result.first!.location, firstRange.location)
        XCTAssertEqual(result.last!.length, secondRange.length)
        XCTAssertEqual(result.last!.location, secondRange.location)
    }

    func testmatchWithMultilineString() {
        let matcher = RDSActionMatcher(pattern: "test", color: UIColor.black)

        let result = matcher.match("\n\n\n test")

        let expectedRange = NSMakeRange(4, 4)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first!.length, expectedRange.length)
        XCTAssertEqual(result.first!.location, expectedRange.location)
    }

    func testmatchWithNoResult() {
        let matcher = RDSActionMatcher(pattern: "[0-9]+", color: UIColor.black)

        XCTAssertTrue(matcher.match("test").isEmpty)
    }

    func testmatchWithUrlMatcher() {
        let matcher = RDSActionMatcher(pattern: "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)", color: UIColor.black)

        let result = matcher.match(" http://example.com ")

        let expectedRange = NSMakeRange(1, 18)

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first!.length, expectedRange.length)
        XCTAssertEqual(result.first!.location, expectedRange.location)
    }
}
