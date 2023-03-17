//
//  LaunchVC.swift
//  PureBrowser
//
//  Created by yangjian on 2023/3/2.
//

import Foundation
import UIKit

class LaunchVC: UIViewController {
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var progressLabel: UILabel!
    
    var progress = 0.0 {
        didSet {
            if progress > 1.0 {
                launched()
                progress = 1.0
            }
            if progress < 0.0 {
                progress = 0.0
            }
            widthConstraint.constant = 208 * progress
            progressLabel.text = "\(Int(progress * 100))%"
            view.layoutIfNeeded()
        }
    }
    
    var duration = 2.5
    
    var isStop = false
    
    override func viewWillAppear(_ animated: Bool) {
        startLaunch()
    }
    
}

extension LaunchVC {
    
    func startLaunch() {
        duration = 2.5
        progress = 0.0
        isStop = false
        launch()
    }
    
    func launched() {
        isStop = true
        NotificationCenter.default.post(name: .launched, object: nil)
    }
    
}
 
extension LaunchVC {
    
    @objc private func launch () {
        progress += 0.01 / duration
        if !isStop {
            perform(#selector(launch), with: nil, afterDelay: 0.01)
        }
    }
    
}
