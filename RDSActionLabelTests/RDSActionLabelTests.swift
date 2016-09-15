//
//  RDSActionLabelTests.swift
//  RDSActionLabelTests
//
//  Created by Radoslav Stankov on 12/26/15.
//  Copyright © 2015 Radoslav Stankov. All rights reserved.
//

import XCTest
import UIKit.UIGestureRecognizerSubclass

@testable import RDSActionLabel

class RDSActionLabelTests: XCTestCase {

    private lazy var container = UIView()
    private func buildLabel() -> RDSActionLabel {
        let label = RDSActionLabel()

        container.addSubview(label)

        return label;
    }

    func testRenderWhenSetMatcher() {
        let label = buildLabel()

        label.textColor = UIColor.black
        label.text = "text"

        XCTAssertEqual(label.colorForText(text: "text"), UIColor.black)

        label.match("text", color: UIColor.red)

        XCTAssertEqual(label.colorForText(text: "text"), UIColor.red)
    }

    func testRenderWhenSetTextColor() {
        let label = buildLabel()

        label.textColor = UIColor.black
        label.text = "text"

        XCTAssertEqual(label.colorForText(text: "text"), UIColor.black)

        label.textColor = UIColor.red

        XCTAssertEqual(label.colorForText(text: "text"), UIColor.red)

    }

    func testRenderWhenSetText() {
        let label = buildLabel()

        label.textColor = UIColor.black
        label.text = "text"

        label.match("new-text", color: UIColor.red)

        XCTAssertEqual(label.colorForText(text: "text"), UIColor.black)

        label.text = "new-text"

        XCTAssertEqual(label.colorForText(text: "new-text"), UIColor.red)

    }

    func testRenderWhenSetFont() {
        let label = buildLabel()

        label.textColor = UIColor.black
        label.text = "text"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.match("text", color: UIColor.red)

        XCTAssertEqual(label.fontForText(text: "text"), label.font)

        label.font = UIFont.boldSystemFont(ofSize: 10)

        XCTAssertEqual(label.fontForText(text: "text"), label.font)
    }

    func testRenderWhenSetAttributedText() {
        let label = buildLabel()

        let font = UIFont.boldSystemFont(ofSize: 20)

        label.attributedText = NSAttributedString(string: "label text", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: UIColor.black])
        label.match("text", color: UIColor.red)

        XCTAssertEqual(label.fontForText(text: "label"), font)
        XCTAssertEqual(label.fontForText(text: "text"), font)

        XCTAssertEqual(label.colorForText(text: "label"), UIColor.black)
        XCTAssertEqual(label.colorForText(text: "text"), UIColor.red)
    }

    func testTappingOnMatchedText() {
        var passedText = "not called"

        let label = buildLabel()

        label.text = "tapped"
        label.match("tapped", color: UIColor.red) { passedText = $0 }

        let gesture = TestGesture()

        gesture.simulateState(state: .began, locationInView: CGPoint(x: 2, y: 3))

        label.onTouch(gesture: gesture)

        gesture.simulateState(state: .ended)

        label.onTouch(gesture: gesture)

        XCTAssertEqual(passedText, "tapped");
    }

    func testTappingOutsideMatchedText() {
        var passedText = "not called"

        let label = buildLabel()

        label.text = "tapped"
        label.match("tapped", color: UIColor.red) { passedText = $0 }

        let gesture = TestGesture()


        gesture.simulateState(state: .began, locationInView: CGPoint(x: 2000, y: 3000))

        label.onTouch(gesture: gesture)

        gesture.simulateState(state: .ended)

        label.onTouch(gesture: gesture)

        XCTAssertEqual(passedText, "not called");
    }

    func testHighlightingOnMatchedText() {
        let label = buildLabel()

        label.text = "text"
        label.match("text", color: UIColor.black, selectedColor: UIColor.red)

        let gesture = TestGesture()

        gesture.simulateState(state: .began, locationInView: CGPoint(x: 2, y: 3))

        label.onTouch(gesture: gesture)

        XCTAssertEqual(label.colorForText(text: "text"), UIColor.red)
    }

    func testMatchURL() {
        let label = buildLabel()

        label.textColor = UIColor.black
        label.text = " http://example.com text"
        label.matchUrl(color: UIColor.red)

        XCTAssertEqual(label.colorForText(text: "text"), UIColor.black)
        XCTAssertEqual(label.colorForText(text: "http://example.com"), UIColor.red)
    }

    func testMatchUsername() {
        let label = buildLabel()

        label.textColor = UIColor.black
        label.text = " @username text"
        label.matchUsername(color: UIColor.red)

        XCTAssertEqual(label.colorForText(text: "text"), UIColor.black)
        XCTAssertEqual(label.colorForText(text: "@username"), UIColor.red)
    }

    func testMatchHashtag() {
        let label = buildLabel()

        label.textColor = UIColor.black
        label.text = " #tag text"
        label.matchHashtag(color: UIColor.red)

        XCTAssertEqual(label.colorForText(text: "text"), UIColor.black)
        XCTAssertEqual(label.colorForText(text: "#tag"), UIColor.red)
    }
}

class TestGesture : UILongPressGestureRecognizer {
    private var simulatedLocationInView = CGPoint.zero

    func simulateState(state: UIGestureRecognizerState) {
        simulateState(state: state, locationInView: CGPoint.zero)
    }

    func simulateState(state: UIGestureRecognizerState, locationInView: CGPoint) {
        self.state = state
        self.simulatedLocationInView = locationInView
    }

    override func location(in view: UIView?) -> CGPoint {
        return simulatedLocationInView
    }
}

extension RDSActionLabel {
    func colorForText(text:String) -> UIColor {
        var range = NSRange(location: 0, length: 0)
        let attr  = textRenderer.attributedString
        let index = (attr.string as NSString).range(of: text).location

        return attr.attribute(NSForegroundColorAttributeName, at: index, effectiveRange: &range) as! UIColor
    }

    func fontForText(text:String) -> UIFont {
        var range = NSRange(location: 0, length: 0)
        let attr  = textRenderer.attributedString
        let index = (attr.string as NSString).range(of: text).location

        return attr.attribute(NSFontAttributeName, at: index, effectiveRange: &range) as! UIFont
    }
}
