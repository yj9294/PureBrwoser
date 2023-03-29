//
//  WebVC.swift
//  PureBrowser
//
//  Created by yangjian on 2023/3/8.
//

import UIKit

class WebVC: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var content: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        self.titleLabel.text = title
        textView.text = content
    }
 
    @IBAction func backAction() {
        self.dismiss(animated: true)
    }
}
