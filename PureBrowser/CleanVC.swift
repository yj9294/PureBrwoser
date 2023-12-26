//
//  CleanVC.swift
//  PureBrowser
//
//  Created by yangjian on 2023/3/8.
//

import UIKit

class CleanVC: UIViewController {

    @IBOutlet weak var animationIcon: UIImageView!
    
    var handle: (()->Void)? = nil
    
    var timer: Timer? = nil
    
    var progress = 0.0
    var duration = 15.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseUtil.log(event: .cleanSuccess)
        
        BrowserUtil.shared.clean(from: self)
        starAnimation()
        GADHelper.share.load(.interstitial)
        GADHelper.share.load(.native)
        Task {
            if !Task.isCancelled {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                
                self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(loadingAD), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func loadingAD() {
        self.progress += 0.01 / duration
        if GADHelper.share.isLoaded(.interstitial) {
            self.duration = 0.1
        }
        if self.progress > 1.0 {
            self.timer?.invalidate()
            GADHelper.share.show(.interstitial, from: self) { _ in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.stopAnimation()
                    self.dismiss(animated: true)
                    FirebaseUtil.log(event: .cleanAlert)
                    self.handle?()
                }
            }
        }
    }


    func starAnimation() {
        let anim = CABasicAnimation(keyPath: "transform.rotation")
        anim.toValue = 2 * Double.pi
        anim.repeatCount = MAXFLOAT
        anim.duration = 1
        anim.isRemovedOnCompletion = false
        animationIcon.layer.add(anim, forKey: "rot")
    }
    
    func stopAnimation() {
        animationIcon.layer.removeAllAnimations()
    }
}
