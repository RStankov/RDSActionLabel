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
        let matcher = RDSActionMatcher(pattern: "test", color: UIColor.blackColor())
        let matcher2 = RDSActionMatcher(pattern: "test", color: UIColor.blackColor(), selectedColor: UIColor.redColor())

        XCTAssertEqual(matcher.color, matcher.selectedColor)
        XCTAssertEqual(matcher2.selectedColor, UIColor.redColor())
    }

    func testTextInRange() {
        let matcher = RDSActionMatcher(pattern: "test", color: UIColor.blackColor())
        let text = RDSActionText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        XCTAssert(text.inRange(5))
        XCTAssertFalse(text.inRange(20))
    }

    func testTextColor() {
        let matcher = RDSActionMatcher(pattern: "test", color: UIColor.blackColor(), selectedColor: UIColor.redColor())
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

    func testmatchWithPattern() {
        let matcher = RDSActionMatcher(pattern: "[a-z]+", color: UIColor.blackColor())


        XCTAssertEqual(matcher.match(" test "), [NSMakeRange(1, 4)]);
    }

    func testmatchWithMultiplematch() {
        let matcher = RDSActionMatcher(pattern: "word", color: UIColor.blackColor())


        XCTAssertEqual(matcher.match("word and word"), [NSMakeRange(0, 4), NSMakeRange(9, 4)]);
    }

    func testmatchWithMultilineString() {
        let matcher = RDSActionMatcher(pattern: "test", color: UIColor.blackColor())


        XCTAssertEqual(matcher.match("\n\n\n test"), [NSMakeRange(4, 4)]);
    }

    func testmatchWithNoResult() {
        let matcher = RDSActionMatcher(pattern: "[0-9]+", color: UIColor.blackColor())


        XCTAssertEqual(matcher.match("test"), []);
    }

    func testmatchWithUrlMatcher() {
        let matcher = RDSActionMatcher(pattern: "(?i)https?://(?:www\\.)?\\S+(?:/|\\b)", color: UIColor.blackColor())


        XCTAssertEqual(matcher.match(" http://example.com "), [NSMakeRange(1, 18)]);

    }
}