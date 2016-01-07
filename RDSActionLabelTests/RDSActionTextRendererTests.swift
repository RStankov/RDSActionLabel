//
//  RDSActionTextRenderer.swift
//  RDSActionLabel
//
//  Created by Radoslav Stankov on 1/7/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import XCTest

@testable import RDSActionLabel

class RDSActionTextRendererTests: XCTestCase {
    func testAttributedStringFromLabel() {
        let label = UILabel()

        label.text = "text"

        let attributedString = RDSActionTextRenderer.attributedStringFrom(label)
        let attributes = attributedString.attributes()

        XCTAssertEqual(attributedString.string, label.text)
        XCTAssertEqual(attributes[NSFontAttributeName] as? UIFont, label.font)
        XCTAssertEqual(attributes[NSForegroundColorAttributeName] as? UIColor, label.textColor)
    }

    func testAttributedStringFromLabelParagraph() {
        let label = UILabel()

        label.text = "text"
        label.lineBreakMode = .ByWordWrapping
        label.textAlignment = .Center

        let attributes = RDSActionTextRenderer.attributedStringFrom(label).attributes()

        let style = attributes[NSParagraphStyleAttributeName] as! NSMutableParagraphStyle

        XCTAssertEqual(style.lineBreakMode, label.lineBreakMode)
        XCTAssertEqual(style.alignment, label.textAlignment)
    }

    func testAttributedStringFromLabelAttributedText() {
        let label = UILabel()

        let font = UIFont.systemFontOfSize(10)
        let color = UIColor.redColor()

        label.attributedText = NSAttributedString(string: "test", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: color])

        let attributedString = RDSActionTextRenderer.attributedStringFrom(label)
        let attributes = attributedString.attributes()

        XCTAssertEqual(attributedString.string, "test")
        XCTAssertEqual(attributes[NSFontAttributeName] as? UIFont, font)
        XCTAssertEqual(attributes[NSForegroundColorAttributeName] as? UIColor, color)
    }
}

extension NSAttributedString {
    func attributes() -> [String:AnyObject] {
        var range = NSRange(location: 0, length: 0)
        return string.characters.count == 0 ? [String:AnyObject]() : attributesAtIndex(0, effectiveRange: &range)
    }
}