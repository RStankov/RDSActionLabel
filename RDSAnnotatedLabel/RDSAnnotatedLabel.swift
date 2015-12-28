//
//  RDSAnnotatedLabel.swift
//  RDSAnnotatedLabel
//
//  Created by Radoslav Stankov on 12/28/15.
//  Copyright © 2015 Radoslav Stankov. All rights reserved.
//

import Foundation
import UIKit


typealias RDSAnnotatedHandler = ((String) -> ())

let noopHandle:RDSAnnotatedHandler = { (arg:String) in }

class RDSAnnotatedMatcher {
    private let regexp:NSRegularExpression
    private let handle: RDSAnnotatedHandler

    let color: UIColor
    let selectedColor: UIColor

    init(pattern: String, color: UIColor, selectedColor: UIColor? = nil, handle: RDSAnnotatedHandler? = nil ) {
        self.regexp = try! NSRegularExpression(pattern: pattern, options: [.CaseInsensitive])

        self.color = color
        self.selectedColor = selectedColor ?? color

        if let handle = handle {
            self.handle = handle
        } else {
            self.handle = noopHandle
        }
    }

    func isMatching(string: String) -> Bool {
        let results = regexp.matchesInString(string, options: [], range: NSRange(location: 0, length: string.characters.count))
        return results.count > 0
    }
}

class RDSAnnotatedText : Equatable {
    private let matcher: RDSAnnotatedMatcher;
    private let string: String
    private let range: NSRange

    init(range: NSRange, string: String, matcher: RDSAnnotatedMatcher) {
        self.range = range
        self.string = string
        self.matcher = matcher;
    }

    func color(isSelected:Bool = false) -> UIColor {
        return isSelected ? matcher.selectedColor : matcher.color
    }

    func handle() {
        matcher.handle(string)
    }

    func inRange(index: Int) -> Bool {
        return index >= range.location && index <= range.location + range.length
    }
}

func ==(lhs: RDSAnnotatedText, rhs: RDSAnnotatedText) -> Bool {
    return lhs.range.location == rhs.range.location && lhs.range.length != rhs.range.length
}

public class RDSAnnotatedLabel: UILabel {
    override public var text: String? { didSet { updateUI() } }
    override public var attributedText: NSAttributedString? { didSet { updateUI() } }
    override public var font: UIFont! { didSet { updateUI() } }
    override public var textColor: UIColor! { didSet { updateUI() } }

    private lazy var textAttributes = [String : AnyObject]()
    private lazy var textStorage = NSTextStorage()
    private lazy var textContainer = NSTextContainer()
    private lazy var layoutManager = NSLayoutManager()

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
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0

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
        textContainer.size = rect.size

        let range = NSRange(location: 0, length: textStorage.length)
        layoutManager.drawBackgroundForGlyphRange(range, atPoint: rect.origin)
        layoutManager.drawGlyphsForGlyphRange(range, atPoint: rect.origin)
    }

    public override func sizeThatFits(size: CGSize) -> CGSize {
        let currentSize = textContainer.size

        defer { textContainer.size = currentSize }

        textContainer.size = size
        return layoutManager.usedRectForTextContainer(textContainer).size
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
        guard textStorage.length > 0 else { return nil }

        let boundingRect = layoutManager.boundingRectForGlyphRange(NSRange(location: 0, length: textStorage.length), inTextContainer: textContainer)
        guard boundingRect.contains(location) else { return nil }

        let index = layoutManager.glyphIndexForPoint(location, inTextContainer: textContainer)

        for element in items {
            if element.inRange(index) {
                return element
            }
        }

        return nil
    }

    private func updateUI() {
        items.removeAll()

        guard let _ = superview else { return }

        applyTextAttributes()
        applyitems()
    }

    private func applyitems() {
        let text = attributedText!.string as NSString
        for word in text.componentsSeparatedByString(" ") {
            for matcher in matchers {
                if (matcher.isMatching(word)) {
                    let item = RDSAnnotatedText(range: text.rangeOfString(word), string: word, matcher: matcher)

                    items.append(item)
                    styleItem(item)
                }
            }
        }
    }

    private func applyTextAttributes() {
        let mutAttrString = NSMutableAttributedString(attributedString: attributedText!)

        var range = NSRange(location: 0, length: 0)

        textAttributes = mutAttrString.attributesAtIndex(0, effectiveRange: &range)

        let paragraphStyle = textAttributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping

        textAttributes[NSParagraphStyleAttributeName] = paragraphStyle
        textAttributes[NSFontAttributeName] = font!
        textAttributes[NSForegroundColorAttributeName] = textColor

        mutAttrString.setAttributes(textAttributes, range: range)

        textStorage.setAttributedString(mutAttrString)
    }

    private func styleItem(item: RDSAnnotatedText?, isSelected: Bool = false) {
        guard let item = item else { return }

        var attributes = textAttributes;

        attributes[NSForegroundColorAttributeName] = item.color(isSelected)
        textStorage.addAttributes(attributes, range: item.range)
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
