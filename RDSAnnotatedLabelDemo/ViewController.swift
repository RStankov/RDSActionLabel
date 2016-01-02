//
//  ViewController.swift
//  RDSAnnotatedLabelDemo
//
//  Created by Radoslav Stankov on 12/28/15.
//  Copyright © 2015 Radoslav Stankov. All rights reserved.
//

import UIKit
import RDSAnnotatedLabel

class ViewController: UIViewController {

    private lazy var label:RDSAnnotatedLabel = RDSAnnotatedLabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "Word \n #hash-1 \n #hash-2 \n @username \n http://example.com \n other text"
        label.textColor = UIColor.grayColor()
        label.font = UIFont.boldSystemFontOfSize(15)

        let hashtagColor = UIColor.redColor()
        let hashtagSelectedColor = UIColor.purpleColor()
        let mentionColor = UIColor.greenColor()
        let mentionSelectedColor = UIColor.darkGrayColor()
        let URLColor = UIColor.blueColor()
        let URLSelectedColor = UIColor.darkTextColor()

        label.addMatcher("Word") { self.alert("Custom", message: $0) }
        label.addMatcher("^@\\w+", color: mentionColor, selectedColor: mentionSelectedColor) { self.alert("Mention", message: $0) }
        label.addMatcher("#\\w+", color: hashtagColor, selectedColor: hashtagSelectedColor) { self.alert("Hashtag", message: $0) }
        label.addMatcher("(?i)https?://(?:www\\.)?\\S+(?:/|\\b)", color: URLColor, selectedColor: URLSelectedColor) { self.alert("URL", message: $0) }

        label.frame = CGRect(x: 40, y: 40, width: view.frame.width - 80, height: view.frame.height - 80)
        view.addSubview(label)
    }

    func alert(title: String, message: String) {
        let vc = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        vc.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
        presentViewController(vc, animated: true, completion: nil)

        label.text = "\(label.text!) \n was tapped"
    }


}

