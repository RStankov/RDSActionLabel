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

        if let attributedString = label.attributedText {
            let mutableString = attributedString.mutableCopy() as! NSMutableAttributedString

            mutableString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSMakeRange(0, mutableString.string.characters.count))

            return attributedString
        }

        return NSAttributedString(string: label.text ?? "", attributes: [NSFontAttributeName: label.font!, NSForegroundColorAttributeName: label.textColor, NSParagraphStyleAttributeName: paragraphStyle])
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

    func drawTextInRect(_ rect: CGRect) {
        textContainer.size = rect.size

        let range = NSRange(location: 0, length: textStorage.length)

        layoutManager.drawBackground(forGlyphRange: range, at: rect.origin)
        layoutManager.drawGlyphs(forGlyphRange: range, at: rect.origin)
    }

    func setColor(_ color: UIColor, range: NSRange) {
        textStorage.addAttributes([NSForegroundColorAttributeName:color], range: range)
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        let currentSize = textContainer.size

        defer { textContainer.size = currentSize }

        textContainer.size = size

        return layoutManager.usedRect(for: textContainer).size
    }

    func indexForPoint(_ location: CGPoint) -> Int? {
        if textStorage.length == 0 {
            return nil
        }

        let boundingRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: textStorage.length), in: textContainer)
        guard boundingRect.contains(location) else { return nil }
        
        return layoutManager.glyphIndex(for: location, in: textContainer)
    }
}
