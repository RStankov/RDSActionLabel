//
//  RDSAnnotatedLabel.swift
//  RDSAnnotatedLabel
//
//  Created by Radoslav Stankov on 12/28/15.
//  Copyright © 2015 Radoslav Stankov. All rights reserved.
//

import Foundation
import UIKit

public class RDSAnnotatedLabel: UILabel {
    override public var text: String? { didSet { updateUI() } }
    override public var attributedText: NSAttributedString? { didSet { updateUI() } }
    override public var font: UIFont! { didSet { updateUI() } }
    override public var textColor: UIColor! { didSet { updateUI() } }

    lazy var textRenderer = RDSAnnotatedTextRenderer()

    private lazy var matchedTexts = [RDSAnnotatedText]()
    private lazy var matchers = [RDSAnnotatedMatcher]()

    override public init(frame: CGRect) {
        super.init(frame: frame)

        commonInit()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        commonInit()
    }

    private func commonInit() {
        let touchRecognizer = UILongPressGestureRecognizer(target: self, action: "onTouch:")
        touchRecognizer.minimumPressDuration = 0.00001
        touchRecognizer.delegate = self
        addGestureRecognizer(touchRecognizer)

        userInteractionEnabled = true
    }

    public func addMatcher(pattern: String, color: UIColor? = nil, selectedColor: UIColor? = nil, handle: ((String) -> ())? = nil) {
        matchers.append(RDSAnnotatedMatcher(pattern: pattern, color: color ?? textColor!, selectedColor: selectedColor, handle: handle));
        updateUI()
    }

    public override func drawTextInRect(rect: CGRect) {
        textRenderer.drawTextInRect(rect)
    }

    public override func sizeThatFits(size: CGSize) -> CGSize {
        return textRenderer.sizeThatFits(size)
    }

    public override func didMoveToSuperview() {
        updateUI()
    }

    private var selectedText: RDSAnnotatedText? = nil {
        willSet {
            styleText(selectedText, isSelected: false)
        }

        didSet {
            styleText(selectedText, isSelected: true)
            setNeedsDisplay()
        }
    }

    func onTouch(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
            case .Began, .Changed:
                selectedText = textAtLocation(gesture.locationInView(self))
                break

            case .Cancelled, .Ended:
                selectedText?.handle()
                selectedText = nil
                break

            default:
                break
        }
    }

    private func textAtLocation(location: CGPoint) -> RDSAnnotatedText? {
        guard let index = textRenderer.indexForPoint(location) else { return nil }

        for text in matchedTexts {
            if text.inRange(index) {
                return text
            }
        }

        return nil
    }

    private func updateUI() {
        guard let _ = superview else { return }

        matchedTexts.removeAll()

        let attributedString = attributedText ?? NSAttributedString(string: text ?? "", attributes: [NSFontAttributeName: font!, NSForegroundColorAttributeName: textColor])

        textRenderer.attributedString = attributedString

        let string = attributedString.string as NSString
        for word in string.componentsSeparatedByString(" ") {
            for matcher in matchers {
                if (matcher.isMatching(word)) {
                    let text = RDSAnnotatedText(range: string.rangeOfString(word), string: word, matcher: matcher)

                    matchedTexts.append(text)
                    styleText(text)
                }
            }
        }
    }

    private func styleText(text: RDSAnnotatedText?, isSelected: Bool = false) {
        guard let text = text else { return }

        textRenderer.setColor(text.color(isSelected), range: text.range)
    }
}

extension RDSAnnotatedLabel: UIGestureRecognizerDelegate {
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOfGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
