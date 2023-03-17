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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseUtil.log(event: .cleanSuccess)
        
        BrowserUtil.shared.clean(from: self)
        starAnimation()
        Task {
            if !Task.isCancelled {
                try await Task.sleep(nanoseconds: 2_000_000_000)
                self.stopAnimation()
                self.dismiss(animated: true)
                FirebaseUtil.log(event: .cleanAlert)
                self.handle?()
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
