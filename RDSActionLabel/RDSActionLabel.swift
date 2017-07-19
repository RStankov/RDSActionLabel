//
//  RDSActionLabel.swift
//  RDSActionLabel
//
//  Created by Radoslav Stankov on 12/28/15.
//  Copyright © 2015 Radoslav Stankov. All rights reserved.
//

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
        let touchRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(onTouch(gesture:)))
        touchRecognizer.minimumPressDuration = 0.00001
        touchRecognizer.delegate = self
        addGestureRecognizer(touchRecognizer)

        lineBreakMode = .byWordWrapping

        isUserInteractionEnabled = true
    }

    public func match(_ pattern: String, color: UIColor? = nil, selectedColor: UIColor? = nil, handle: RDSActionHandler? = nil) {
        matchers.append(RDSActionMatcher(pattern: pattern, color: color ?? textColor!, selectedColor: selectedColor, handle: handle));
        updateUI()
    }

    public func matchUrl(color: UIColor? = nil, selectedColor: UIColor? = nil, handle: RDSActionHandler? = nil) {
        match("(?i)https?://(?:www\\.)?\\S+(?:/|\\b)", color: color ?? textColor!, selectedColor: selectedColor, handle: handle)
    }

    public func matchUsername(color: UIColor? = nil, selectedColor: UIColor? = nil, handle: RDSActionHandler? = nil) {
        match("@\\w+", color: color ?? textColor!, selectedColor: selectedColor, handle: handle)
    }

    public func matchHashtag(color: UIColor? = nil, selectedColor: UIColor? = nil, handle: RDSActionHandler? = nil) {
        match("#[A-Z0-9_-]+", color: color ?? textColor!, selectedColor: selectedColor, handle: handle)
    }

    public override func drawText(in rect: CGRect) {
        textRenderer.drawTextInRect(rect)
    }

    public override func sizeThatFits(_ size: CGSize) -> CGSize {
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
        case .began, .changed:
            selectedText = textAtLocation(location: gesture.location(in: self))
            break

        case .cancelled, .ended:
            selectedText?.handle()
            selectedText = nil
            break

        default:
            break
        }
    }

    func textAtLocation(location: CGPoint) -> RDSActionText? {
        guard let index = textRenderer.indexForPoint(location) else { return nil }

        for text in matchedTexts where text.inRange(index: index) {
            return text
        }

        return nil
    }

    private func updateUI() {
        if superview == nil {
            return
        }

        matchedTexts.removeAll()

        textRenderer.attributedString = RDSActionTextRenderer.attributedStringFrom(label: self)

        let string = textRenderer.attributedString.string as NSString

        for matcher in matchers {
            for range in matcher.match(string as String) {
                let text = RDSActionText(range: range, string: string.substring(with: range), matcher: matcher)

                matchedTexts.append(text)
                styleText(text)
            }
        }
    }

    private func styleText(_ text: RDSActionText?, isSelected: Bool = false) {
        guard let text = text else { return }

        textRenderer.setColor(text.color(isSelected: isSelected), range: text.range)
    }
}

extension RDSActionLabel: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
