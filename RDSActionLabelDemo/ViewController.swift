//
//  ViewController.swift
//  RDSActionLabelDemo
//
//  Created by Radoslav Stankov on 1/5/16.
//  Copyright © 2016 Radoslav Stankov. All rights reserved.
//

import UIKit


import RDSActionLabel

class ViewController: UIViewController {

    private let label = RDSActionLabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "Example comment addresed to @username about http://example.com #hash-1 #hash-2 \n\n custom text \n\n tap recordings: \n"
        label.textColor = UIColor.grayColor()
        label.font = UIFont.boldSystemFontOfSize(12)

        let hashtagColor = UIColor.redColor()
        let mentionColor = UIColor.magentaColor()
        let URLColor = UIColor.blueColor()
        let selectedColor = UIColor.purpleColor()

        label.match("custom text", handle: { self.alert("Custom", message: $0) })
        label.matchUsername(color: mentionColor, selectedColor: selectedColor, handle: { self.alert("Mention", message: $0) })
        label.matchHashtag(color: hashtagColor, selectedColor: selectedColor, handle: { self.alert("Hashtag", message: $0) })
        label.matchUrl(color: URLColor, selectedColor: selectedColor, handle: { self.alert("Url", message: $0) })

        label.frame = CGRect(x: 40, y: 40, width: view.frame.width - 80, height: view.frame.height - 80)

        view.addSubview(label)
    }

    func alert(title: String, message: String) {
        label.text = "\(label.text!) \n \"\(message)\" was tapped"

        let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))

        presentViewController(alert, animated: true, completion: nil)
    }
}
