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
        let font = UIFont.systemFontOfSize(10)
        let firstColor = UIColor.redColor()
        let secondColor = UIColor.blueColor()
        let range = NSMakeRange(2, 2);

        let attributedText = NSMutableAttributedString(string: "test", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: firstColor])

        attributedText.addAttributes([NSForegroundColorAttributeName: secondColor], range: range)

        let label = UILabel()
        label.attributedText = attributedText

        let attributedString = RDSActionTextRenderer.attributedStringFrom(label)

        XCTAssertEqual(attributedString.string, "test")
        XCTAssertEqual(attributedString.attributes()[NSFontAttributeName] as? UIFont, font)
        XCTAssertEqual(attributedString.attributes()[NSForegroundColorAttributeName] as? UIColor, firstColor)
        XCTAssertEqual(attributedString.attributes(range)[NSForegroundColorAttributeName] as? UIColor, secondColor)
    }
}

extension NSAttributedString {
    func attributes(inRange:NSRange? = nil) -> [String:AnyObject] {
        var range = inRange ?? NSRange(location: 0, length: 0)
        return string.characters.count == 0 ? [String:AnyObject]() : attributesAtIndex(range.location, effectiveRange: &range)
    }
}