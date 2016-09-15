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

        let attributedString = RDSActionTextRenderer.attributedStringFrom(label: label)
        let attributes = attributedString.attributes()

        XCTAssertEqual(attributedString.string, label.text)
        XCTAssertEqual(attributes[NSFontAttributeName] as? UIFont, label.font)
        XCTAssertEqual(attributes[NSForegroundColorAttributeName] as? UIColor, label.textColor)
    }

    func testAttributedStringFromLabelParagraph() {
        let label = UILabel()

        label.text = "text"
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center

        let attributes = RDSActionTextRenderer.attributedStringFrom(label: label).attributes()

        let style = attributes[NSParagraphStyleAttributeName] as! NSMutableParagraphStyle

        XCTAssertEqual(style.lineBreakMode, label.lineBreakMode)
        XCTAssertEqual(style.alignment, label.textAlignment)
    }

    func testAttributedStringFromLabelAttributedText() {
        let font = UIFont.systemFont(ofSize: 10)
        let firstColor = UIColor.red
        let secondColor = UIColor.blue
        let range = NSMakeRange(2, 2);

        let attributedText = NSMutableAttributedString(string: "test", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: firstColor])

        attributedText.addAttributes([NSForegroundColorAttributeName: secondColor], range: range)

        let label = UILabel()
        label.attributedText = attributedText

        let attributedString = RDSActionTextRenderer.attributedStringFrom(label: label)

        XCTAssertEqual(attributedString.string, "test")
        XCTAssertEqual(attributedString.attributes()[NSFontAttributeName] as? UIFont, font)
        XCTAssertEqual(attributedString.attributes()[NSForegroundColorAttributeName] as? UIColor, firstColor)
        XCTAssertEqual(attributedString.attributes(inRange: range)[NSForegroundColorAttributeName] as? UIColor, secondColor)
    }
}

extension NSAttributedString {
    func attributes(inRange:NSRange? = nil) -> [String:Any] {
        var range = inRange ?? NSRange(location: 0, length: 0)
        return string.characters.count == 0 ? [String:Any]() : attributes(at: range.location, effectiveRange: &range)
    }
}
