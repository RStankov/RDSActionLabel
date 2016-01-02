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

    private lazy var container = UIView()
    private func buildLabel() -> RDSAnnotatedLabel {
        let label = RDSAnnotatedLabel()

        container.addSubview(label)

        return label;
    }

    func testRenderWhenSetMatcher() {
        let label = buildLabel()

        label.textColor = UIColor.blackColor()
        label.text = "text"

        XCTAssertEqual(label.colorForText("text"), UIColor.blackColor())

        label.addMatcher("text", color: UIColor.redColor())

        XCTAssertEqual(label.colorForText("text"), UIColor.redColor())
    }

    func testRenderWhenSetTextColor() {
        let label = buildLabel()

        label.textColor = UIColor.blackColor()
        label.text = "text"

        XCTAssertEqual(label.colorForText("text"), UIColor.blackColor())

        label.textColor = UIColor.redColor()

        XCTAssertEqual(label.colorForText("text"), UIColor.redColor())

    }

    func testRenderWhenSetText() {
        let label = buildLabel()

        label.textColor = UIColor.blackColor()
        label.text = "text"

        label.addMatcher("new-text", color: UIColor.redColor())

        XCTAssertEqual(label.colorForText("text"), UIColor.blackColor())

        label.text = "new-text"

        XCTAssertEqual(label.colorForText("new-text"), UIColor.redColor())

    }

    func testRenderWhenSetFont() {
        let label = buildLabel()

        label.textColor = UIColor.blackColor()
        label.text = "text"
        label.font = UIFont.boldSystemFontOfSize(20)
        label.addMatcher("text", color: UIColor.redColor())

        XCTAssertEqual(label.fontForText("text"), label.font)

        label.font = UIFont.boldSystemFontOfSize(10)

        XCTAssertEqual(label.fontForText("text"), label.font)
    }

    func testRenderWhenSetAttributedText() {
        let label = buildLabel()

        let font = UIFont.boldSystemFontOfSize(20)

        label.attributedText = NSAttributedString(string: "label text", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.blackColor()])
        label.addMatcher("text", color: UIColor.redColor())

        XCTAssertEqual(label.fontForText("label"), font)
        XCTAssertEqual(label.fontForText("text"), font)

        XCTAssertEqual(label.colorForText("label"), UIColor.blackColor())
        XCTAssertEqual(label.colorForText("text"), UIColor.redColor())
    }
}

extension RDSAnnotatedLabel {
    func colorForText(text:String) -> UIColor {
        var range = NSRange(location: 0, length: 0)
        let attr  = textStorage.attributedString
        let index = (attr.string as NSString).rangeOfString(text).location

        return attr.attribute(NSForegroundColorAttributeName, atIndex: index, effectiveRange: &range) as! UIColor
    }

    func fontForText(text:String) -> UIFont {
        var range = NSRange(location: 0, length: 0)
        let attr  = textStorage.attributedString
        let index = (attr.string as NSString).rangeOfString(text).location

        return attr.attribute(NSFontAttributeName, atIndex: index, effectiveRange: &range) as! UIFont
    }
}
