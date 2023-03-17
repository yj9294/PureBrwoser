//
//  UI+Extension.swift
//  PureBrowser
//
//  Created by yangjian on 2023/3/2.
//

import Foundation
import UIKit


var AppEnterbackground = false

class AssetorKey {
    static var cornerRadiusKey: String?
    static var borderColorKey: String?
    static var borderWidthKey: String?
    static var placeholderColorKey: String?
}
extension UIView {
    
    @IBInspectable var cornerRadius: Double {
        set {
            self.layer.cornerRadius = newValue
            self.layer.masksToBounds = true
            objc_setAssociatedObject(self, &AssetorKey.cornerRadiusKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &AssetorKey.cornerRadiusKey) as? Double) ?? 0.0
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        set {
            self.layer.borderColor = newValue.cgColor
            objc_setAssociatedObject(self, &AssetorKey.borderColorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &AssetorKey.borderColorKey) as? UIColor) ?? .clear
        }
    }
    
    @IBInspectable var borderWidth: Double {
        set {
            self.layer.borderWidth = newValue
            objc_setAssociatedObject(self, &AssetorKey.borderWidthKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            (objc_getAssociatedObject(self, &AssetorKey.borderWidthKey) as? Double) ?? 0.0
        }
    }
    
}

func GetCurrentVC() -> UIViewController? {
    if var vc = UIApplication.shared.windows.first?.rootViewController {
        while (true) {
            if let tabbarVC = vc as? UITabBarController {
                vc = tabbarVC.selectedViewController!
            }
            if let nav = vc as? UINavigationController {
                vc = nav.topViewController!
            }
            if vc.presentedViewController != nil {
                vc = vc.presentedViewController!
            }
            
            if (!(vc is UITabBarController || vc is UINavigationController || vc.presentedViewController != nil)) {
                return vc
            }
        }
    }
    return nil
}

extension UIViewController {
    
    func alert(_ message: String?) {
        let vc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        GetCurrentVC()?.present(vc, animated: true)
        Task{
            if !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                vc.dismiss(animated: true)
            }
        }
    }
 
    class func loadStoryBoard() -> Self {
        let sb = UIStoryboard(name: "Main", bundle: .main)
        return sb.instantiateViewController(withIdentifier: "\(self)") as? Self ?? Self()
    }
    
    func alert(_ message: String) {
        let vc = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        self.present(vc, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            vc.dismiss(animated: true)
        }
    }
}

extension String {
    
    var isUrl: Bool {
        let url = "[a-zA-z]+://.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", url)
        return predicate.evaluate(with: self)
    }
    
}

