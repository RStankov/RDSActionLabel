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

    lazy var textStorage = RDSAnnotatedTextStorage()

    private lazy var items = [RDSAnnotatedText]()
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
        matchers.append(RDSAnnotatedMatcher(pattern: pattern, color: color ?? self.textColor!, selectedColor: selectedColor, handle: handle));
        updateUI()
    }

    public override func drawTextInRect(rect: CGRect) {
        textStorage.drawTextInRect(rect)
    }

    public override func sizeThatFits(size: CGSize) -> CGSize {
        return textStorage.sizeThatFits(size)
    }

    public override func didMoveToSuperview() {
        updateUI()
    }

    private var selectedElement: RDSAnnotatedText? = nil {
        willSet {
            styleItem(selectedElement, isSelected: false)
        }

        didSet {
            styleItem(selectedElement, isSelected: true)
            setNeedsDisplay()
        }
    }

    func onTouch(gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
            case .Began, .Changed:
                selectedElement = elementAtLocation(gesture.locationInView(self))
            case .Cancelled, .Ended:
                selectedElement?.handle()
                selectedElement = nil
            default: ()
        }
    }

    private func elementAtLocation(location: CGPoint) -> RDSAnnotatedText? {
        guard let index = textStorage.indexForPoint(location) else { return nil }

        for element in items {
            if element.inRange(index) {
                return element
            }
        }

        return nil
    }

    private func updateUI() {
        guard let _ = superview else { return }

        items.removeAll()

        let attributedString = attributedText ?? NSAttributedString(string: text ?? "", attributes: [NSFontAttributeName: font!, NSForegroundColorAttributeName: textColor])

        textStorage.attributedString = attributedString

        let string = attributedString.string as NSString
        for word in string.componentsSeparatedByString(" ") {
            for matcher in matchers {
                if (matcher.isMatching(word)) {
                    let item = RDSAnnotatedText(range: string.rangeOfString(word), string: word, matcher: matcher)

                    items.append(item)
                    styleItem(item)
                }
            }
        }
    }

    private func styleItem(item: RDSAnnotatedText?, isSelected: Bool = false) {
        guard let item = item else { return }

        textStorage.setColor(item.color(isSelected), range: item.range)
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
