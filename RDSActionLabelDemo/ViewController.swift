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

    fileprivate lazy var label:RDSActionLabel = RDSActionLabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = "Example comment addresed to @username about http://example.com #hash-1 #hash-2 \n\n custom text \n\n tap recordings: \n"
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 12)

        let hashtagColor = UIColor.red
        let mentionColor = UIColor.magenta
        let URLColor = UIColor.blue
        let selectedColor = UIColor.purple

        label.match("custom text") { (match) in
            self.alert("Custom", match)
        }

        label.matchUsername(color: mentionColor, selectedColor: mentionColor) { (match) in
            self.alert("Mention", match)
        }

        label.matchHashtag(color: hashtagColor, selectedColor: selectedColor) { (match) in
            self.alert("Hashtag", match)
        }

        label.matchUrl(color: URLColor, selectedColor: selectedColor) { (match) in
            self.alert("URL", match)
        }

        label.frame = CGRect(x: 40, y: 40, width: view.frame.width - 80, height: view.frame.height - 80)

        view.addSubview(label)
    }

    func alert(_ title: String, _ message: String) {
        label.text = "\(label.text!) \n \"\(message)\" was tapped"

        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)

        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}
