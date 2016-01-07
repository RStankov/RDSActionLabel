//
//  RDSActionLabel.swift
//  RDSActionLabel
//
//  Created by Radoslav Stankov on 12/28/15.
//  Copyright © 2015 Radoslav Stankov. All rights reserved.
//

import Foundation
import UIKit

@objc public class RDSActionLabel: UILabel {
    override public var text: String? { didSet { updateUI() } }
    override public var attributedText: NSAttributedString? { didSet { updateUI() } }
    override public var font: UIFont! { didSet { updateUI() } }
    override public var textColor: UIColor! { didSet { updateUI() } }
    override public var textAlignment: NSTextAlignment { didSet { updateUI() } }
    override public var lineBreakMode: NSLineBreakMode { didSet { updateUI() } }

    lazy var textRenderer = RDSActionTextRenderer()

    private lazy var matchedTexts = [RDSActionText]()
    private lazy var matchers = [RDSActionMatcher]()

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

        lineBreakMode = .ByWordWrapping

        userInteractionEnabled = true
    }

    public func match(pattern: String, color: UIColor? = nil, selectedColor: UIColor? = nil, handle: RDSActionHandler? = nil) {
        matchers.append(RDSActionMatcher(pattern: pattern, color: color ?? textColor!, selectedColor: selectedColor, handle: handle));
        updateUI()
    }

    public func matchUrl(color color: UIColor? = nil, selectedColor: UIColor? = nil, handle: RDSActionHandler? = nil) {
        match("(?i)https?://(?:www\\.)?\\S+(?:/|\\b)", color: color ?? textColor!, selectedColor: selectedColor, handle: handle)
    }

    public func matchUsername(color color: UIColor? = nil, selectedColor: UIColor? = nil, handle: RDSActionHandler? = nil) {
        match("@\\w+", color: color ?? textColor!, selectedColor: selectedColor, handle: handle)
    }

    public func matchHashtag(color color: UIColor? = nil, selectedColor: UIColor? = nil, handle: RDSActionHandler? = nil) {
        match("#[A-Z0-9_-]+", color: color ?? textColor!, selectedColor: selectedColor, handle: handle)
    }

    public override func drawTextInRect(rect: CGRect) {
        textRenderer.drawTextInRect(rect)
    }

    public override func sizeThatFits(size: CGSize) -> CGSize {
        return textRenderer.sizeThatFits(size)
    }

    public override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateUI()
    }

    private var selectedText: RDSActionText? = nil {
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

    private func textAtLocation(location: CGPoint) -> RDSActionText? {
        guard let index = textRenderer.indexForPoint(location) else { return nil }

        for text in matchedTexts where text.inRange(index) {
            return text
        }

        return nil
    }

    private func updateUI() {
        if superview == nil {
            return
        }

        matchedTexts.removeAll()

        textRenderer.attributedString = RDSActionTextRenderer.attributedStringFrom(self)

        let string = textRenderer.attributedString.string as NSString

        for matcher in matchers {
            for range in matcher.match(string as String) {
                let text = RDSActionText(range: range, string: string.substringWithRange(range), matcher: matcher)

                matchedTexts.append(text)
                styleText(text)
            }
        }
    }

    private func styleText(text: RDSActionText?, isSelected: Bool = false) {
        guard let text = text else { return }

        textRenderer.setColor(text.color(isSelected), range: text.range)
    }
}

extension RDSActionLabel: UIGestureRecognizerDelegate {
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
