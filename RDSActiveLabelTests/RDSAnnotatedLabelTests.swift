//
//  RDSAnnotatedLabelTests.swift
//  RDSAnnotatedLabelTests
//
//  Created by Radoslav Stankov on 12/26/15.
//  Copyright © 2015 Radoslav Stankov. All rights reserved.
//

import XCTest
import UIKit.UIGestureRecognizerSubclass

@testable import RDSActiveLabel

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

    func testTappingOnMatchedText() {
        var passedText = "not called"

        let label = buildLabel()

        label.text = "tapped"
        label.addMatcher("tapped", color: UIColor.redColor()) { passedText = $0 }

        let gesture = TestGesture()


        gesture.simulateState(.Began, locationInView: CGPointMake(2, 3))

        label.onTouch(gesture)

        gesture.simulateState(.Ended)

        label.onTouch(gesture)

        XCTAssertEqual(passedText, "tapped");
    }

    func testTappingOutsideMatchedText() {
        var passedText = "not called"

        let label = buildLabel()

        label.text = "tapped"
        label.addMatcher("tapped", color: UIColor.redColor()) { passedText = $0 }

        let gesture = TestGesture()


        gesture.simulateState(.Began, locationInView: CGPointMake(2000, 3000))

        label.onTouch(gesture)

        gesture.simulateState(.Ended)

        label.onTouch(gesture)

        XCTAssertEqual(passedText, "not called");
    }

    func testHighlightingOnMatchedText() {
        let label = buildLabel()

        label.text = "text"
        label.addMatcher("text", color: UIColor.blackColor(), selectedColor: UIColor.redColor())

        let gesture = TestGesture()

        gesture.simulateState(.Began, locationInView: CGPointMake(2, 3))

        label.onTouch(gesture)

        XCTAssertEqual(label.colorForText("text"), UIColor.redColor())
    }
}

class TestGesture : UILongPressGestureRecognizer {
    private var simulatedLocationInView = CGPointZero

    func simulateState(state: UIGestureRecognizerState) {
        simulateState(state, locationInView: CGPointZero)
    }

    func simulateState(state: UIGestureRecognizerState, locationInView: CGPoint) {
        self.state = state
        self.simulatedLocationInView = locationInView
    }

    override func locationInView(view: UIView?) -> CGPoint {
        return simulatedLocationInView
    }
}

extension RDSAnnotatedLabel {
    func colorForText(text:String) -> UIColor {
        var range = NSRange(location: 0, length: 0)
        let attr  = textRenderer.attributedString
        let index = (attr.string as NSString).rangeOfString(text).location

        return attr.attribute(NSForegroundColorAttributeName, atIndex: index, effectiveRange: &range) as! UIColor
    }

    func fontForText(text:String) -> UIFont {
        var range = NSRange(location: 0, length: 0)
        let attr  = textRenderer.attributedString
        let index = (attr.string as NSString).rangeOfString(text).location

        return attr.attribute(NSFontAttributeName, atIndex: index, effectiveRange: &range) as! UIFont
    }
}
