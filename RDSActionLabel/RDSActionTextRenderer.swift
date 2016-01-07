//
//  RDSActionTextStorage.swift
//  RDSActionLabel
//
//  Created by Radoslav Stankov on 1/2/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import Foundation

class RDSActionTextRenderer {
    private lazy var textStorage = NSTextStorage()
    private lazy var textContainer = NSTextContainer()
    private lazy var layoutManager = NSLayoutManager()

    class func attributedStringFrom(label: UILabel) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineBreakMode = label.lineBreakMode
        paragraphStyle.alignment = label.textAlignment

        let attributedString = NSAttributedString(string: label.text ?? "", attributes: [NSFontAttributeName: label.font!, NSForegroundColorAttributeName: label.textColor, NSParagraphStyleAttributeName: paragraphStyle])

        return attributedString
    }

    var attributedString: NSAttributedString {
        get {
            return textStorage
        }

        set(value) {
            textStorage.setAttributedString(value)
        }
    }

    init() {
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.lineFragmentPadding = 0
    }

    func drawTextInRect(rect: CGRect) {
        textContainer.size = rect.size

        let range = NSRange(location: 0, length: textStorage.length)

        layoutManager.drawBackgroundForGlyphRange(range, atPoint: rect.origin)
        layoutManager.drawGlyphsForGlyphRange(range, atPoint: rect.origin)
    }

    func setColor(color: UIColor, range: NSRange) {
        textStorage.addAttributes([NSForegroundColorAttributeName:color], range: range)
    }

    func sizeThatFits(size: CGSize) -> CGSize {
        let currentSize = textContainer.size

        defer { textContainer.size = currentSize }

        textContainer.size = size
    
        return layoutManager.usedRectForTextContainer(textContainer).size
    }

    func indexForPoint(location: CGPoint) -> Int? {
        if textStorage.length == 0 {
            return nil
        }

        let boundingRect = layoutManager.boundingRectForGlyphRange(NSRange(location: 0, length: textStorage.length), inTextContainer: textContainer)
        guard boundingRect.contains(location) else { return nil }

        return layoutManager.glyphIndexForPoint(location, inTextContainer: textContainer)
    }
}