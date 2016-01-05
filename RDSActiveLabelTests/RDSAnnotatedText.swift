//
//  RDSActiveText.swift
//  RDSActiveLabel
//
//  Created by Radoslav Stankov on 1/2/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import XCTest

@testable import RDSActiveLabel

class RDSActiveTextTests: XCTestCase {
    private lazy var matcher = RDSActiveMatcher(pattern: "test", color: UIColor.blackColor(), selectedColor: UIColor.redColor())

    func testEquality() {
        let text = RDSActiveText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)
        let same = RDSActiveText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)
        let other = RDSActiveText(range: NSMakeRange(0, 11), string: "test", matcher: matcher)

        XCTAssert(text == same)
        XCTAssert(text != other)
    }

    func testTextInRange() {
        let text = RDSActiveText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        XCTAssert(text.inRange(5))
        XCTAssertFalse(text.inRange(20))
    }

    func testTextColor() {
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