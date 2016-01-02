//
//  RDSAnnotatedLabelTests.swift
//  RDSAnnotatedLabelTests
//
//  Created by Radoslav Stankov on 12/26/15.
//  Copyright © 2015 Radoslav Stankov. All rights reserved.
//

import XCTest
@testable import RDSAnnotatedLabel

class RDSAnnotatedLabelTests: XCTestCase {

    // MARK: Private
    
    func testMatcherIsMatching() {
        let matcher = RDSAnnotatedMatcher(pattern: "[a-z]+", color: UIColor.blackColor())

        XCTAssert(matcher.isMatching("text"))
        XCTAssertFalse(matcher.isMatching("0987654321"))
    }

    func testMatcherSelectedColor() {
        let matcher = RDSAnnotatedMatcher(pattern: "test", color: UIColor.blackColor())
        let matcher2 = RDSAnnotatedMatcher(pattern: "test", color: UIColor.blackColor(), selectedColor: UIColor.redColor())

        XCTAssertEqual(matcher.color, matcher.selectedColor)
        XCTAssertEqual(matcher2.selectedColor, UIColor.redColor())
    }

    func testTextInRange() {
        let matcher = RDSAnnotatedMatcher(pattern: "test", color: UIColor.blackColor())
        let text = RDSAnnotatedText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        XCTAssert(text.inRange(5))
        XCTAssertFalse(text.inRange(20))
    }

    func testTextColor() {
        let matcher = RDSAnnotatedMatcher(pattern: "test", color: UIColor.blackColor(), selectedColor: UIColor.redColor())
        let text = RDSAnnotatedText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        XCTAssertEqual(text.color(), matcher.color)
        XCTAssertEqual(text.color(false), matcher.color)
        XCTAssertEqual(text.color(true), matcher.selectedColor)
    }

    func testTextHandle() {
        var passedText = "not called"
        let matcher = RDSAnnotatedMatcher(pattern: "test", color: UIColor.blackColor()) { passedText = $0 }
        let text = RDSAnnotatedText(range: NSMakeRange(0, 10), string: "test", matcher: matcher)

        text.handle()

        XCTAssertEqual(passedText, "test")
    }

    // MARK: Public

    func testMatchingText() {
        let label = buildLabel()

        label.addMatcher("test", color: UIColor.redColor())
        label.textColor = UIColor.blackColor()
        label.text = "this is test, here are some other words"

        XCTAssertEqual(label.colorForText("this"), UIColor.blackColor())
        XCTAssertEqual(label.colorForText("test"), UIColor.redColor())
    }

    private lazy var container = UIView()
    private func buildLabel() -> RDSAnnotatedLabel {
        let label = RDSAnnotatedLabel()

        container.addSubview(label)

        return label;
    }
}

extension RDSAnnotatedLabel {
    func colorForText(text:String) -> UIColor {
        var range = NSRange(location: 0, length: 0)
        let attr  = textStorage.attributedString
        let index = (attr.string as NSString).rangeOfString(text).location

        return attr.attribute(NSForegroundColorAttributeName, atIndex: index, effectiveRange: &range) as! UIColor
    }
}
