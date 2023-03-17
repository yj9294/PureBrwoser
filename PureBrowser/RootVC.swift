//
//  ViewController.swift
//  PureBrowser
//
//  Created by yangjian on 2023/3/2.
//

import UIKit

class RootVC: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: .launching, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else {return}
            self.selectedIndex = 0
        }
        NotificationCenter.default.addObserver(forName: .launched, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else {return}
            self.selectedIndex = 1
        }
        
        FirebaseUtil.log(property: .local)
        FirebaseUtil.log(event: .open)
        FirebaseUtil.log(event: .openCold)
    }

}

extension Notification.Name {
    static let launching = Notification.Name(rawValue: "launching")
    static let launched = Notification.Name(rawValue: "launched")
}
