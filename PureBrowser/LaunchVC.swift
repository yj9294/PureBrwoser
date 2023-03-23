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
                GADHelper.share.show(.interstitial) { _ in
                    if self.progress >= 1.0 {
                        self.launched()
                    }
                }
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
    
    var duration = 16.0
    
    var isStop = false
    
    var isShow = false
    
    override func viewWillAppear(_ animated: Bool) {
        startLaunch()
    }
    
}

extension LaunchVC {
    
    func startLaunch() {
        duration = 2.5 / 0.6
        progress = 0.0
        isStop = false
        launch()
        GADHelper.share.load(.interstitial)
        GADHelper.share.load(.native)
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
        
        if isShow, GADHelper.share.isLoaded(.interstitial) {
            duration = 0.1
            isShow = false
        }
    }
    
    @objc private func delay() {
        duration = 16.0
        isShow = true
    }
    
}
