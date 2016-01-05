//
//  ViewController.swift
//  RDSActiveLabelDemo
//
//  Created by Radoslav Stankov on 1/5/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import UIKit

import RDSActiveLabel

class ViewController: UIViewController {

    private lazy var label:RDSActiveLabel = RDSActiveLabel()

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

        label.match("Word") { self.alert("Custom", message: $0) }
        label.matchUsername(color: mentionColor, selectedColor: mentionSelectedColor) { self.alert("Mention", message: $0) }
        label.matchHashtag(color: hashtagColor, selectedColor: hashtagSelectedColor) { self.alert("Hashtag", message: $0) }
        label.matchUrl(color: URLColor, selectedColor: URLSelectedColor) { self.alert("URL", message: $0) }

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
