//
//  HomeVC.swift
//  PureBrowser
//
//  Created by yangjian on 2023/3/2.
//

import Foundation
import UIKit
import WebKit
import MobileCoreServices

class HomeVC: UIViewController {
    
    @IBOutlet weak var progressBackgroundView: UIImageView!
    @IBOutlet weak var progressContentView: UIView!
    @IBOutlet weak var progressContenWidthConstrant: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var stopSearchButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tabButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var settingView: UIView!
    @IBOutlet weak var settingLeftConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var alertView: UIView!
    
    var startDate: Date? = nil
    
    
    var progress: Double = 0.0 {
        didSet {
            if progress > 0, progress < 1.0 {
                progressBackgroundView.isHidden = false
                progressContentView.isHidden = false
            } else {
                progressBackgroundView.isHidden = true
                progressContentView.isHidden = true
            }
            
            progressContenWidthConstrant.constant = progress * ((view.window?.bounds.width ?? 375) - 48)
            progressContentView.layoutIfNeeded()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BrowserUtil.shared.addedWebView(from: self)
        observerViewStatus()
        
        FirebaseUtil.log(event: .homeShow)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BrowserUtil.shared.removeWebView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        BrowserUtil.shared.frame = contentView.frame
    }
    
}

extension HomeVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        if let text = searchTextField.text, text.count > 0 {
            BrowserUtil.shared.loadUrl(text, from: self)
            FirebaseUtil.log(event: .navigaSearch, params: ["lig": text])
        } else {
            self.alert("Please enter your search content.")
        }
        return true
    }
    
    @IBAction func clickSearchAction(sender: UIButton) {
        searchTextField.resignFirstResponder()
        let url = HomeItem.allCases[sender.tag].url
        searchTextField.text = url
        BrowserUtil.shared.loadUrl(url, from: self)
        FirebaseUtil.log(event: .navigaClick, params: ["lig": url])
    }
    
    @IBAction func seachAction() {
        searchTextField.resignFirstResponder()
        if let text = searchTextField.text, text.count > 0 {
            BrowserUtil.shared.loadUrl(text, from: self)
            FirebaseUtil.log(event: .navigaSearch, params: ["lig": text])
        } else {
            self.alert("Please enter your search content.")
        }
    }
    
    
    @IBAction func stopSearchAction() {
        searchTextField.text = ""
        BrowserUtil.shared.stopLoad()
    }
    
    @IBAction func lastAction() {
        BrowserUtil.shared.goBack()
    }
    
    @IBAction func nextAction() {
        BrowserUtil.shared.goForword()
    }
    
    @IBAction func alertCleanViewAction() {
        alertView.isHidden = false
    }
    
    @IBAction func tabAction(){
        let vc = TabVC.loadStoryBoard()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func settingAction() {
        self.settingView.alpha = 1
        settingLeftConstraint.constant = -264
        UIView.animate(withDuration: 0.25) {
            self.settingLeftConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func dismissSettingAction() {
        UIView.animate(withDuration: 0.25) {
            self.settingLeftConstraint.constant = -264
            self.view.layoutIfNeeded()
        } completion: { ret in
            if ret {
                self.settingView.alpha = 0
            }
        }
    }
    
    @IBAction func newAction() {
        BrowserUtil.shared.add()
        dismissSettingAction()
        observerViewStatus()
        FirebaseUtil.log(event: .tabNew, params: ["lig": "setting"])
    }
    
    @IBAction func shareAction() {
        dismissSettingAction()
        var url = "https://itunes.apple.com/cn/app/id6446673810"
        if !BrowserUtil.shared.item.isNavigation, let text = BrowserUtil.shared.item.webView.url?.absoluteString {
            url = text
        }
        let vc = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        GetCurrentVC()?.present(vc, animated: true)
        
        FirebaseUtil.log(event: .shareClick)
    }
    
    @IBAction func copyAction() {
        dismissSettingAction()
        if !BrowserUtil.shared.item.isNavigation, let text = BrowserUtil.shared.item.webView.url?.absoluteString {
            UIPasteboard.general.setValue(text, forPasteboardType: kUTTypePlainText as String)
            alert("Copy successed.")
        } else {
            UIPasteboard.general.setValue("", forPasteboardType: kUTTypePlainText as String)
            alert("Copy successed.")
        }
        FirebaseUtil.log(event: .copyClick)
    }
    
    @IBAction func rateAction() {
        dismissSettingAction()
        if let url = URL(string: "https://itunes.apple.com/cn/app/id6446673810") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func privacyAction() {
        dismissSettingAction()
        let vc = WebVC.loadStoryBoard()
        vc.title = "Privacy Policy"
        vc.content = """
Please read this policy carefully before using or accessing our services.
Information collection
When you download an application or use an application, website, or service, we will only receive standard non personal information typically provided by web browsers, such as browser type, language preferences, recommended websites, and the date and time of each visitor's request.
Your name, phone number, or email address.
We will collect your device ID.
We will not collect your specific location information. We will not save your access records and logs.
Information usage
To update and maintain our applications.
Used to maintain our products, including performing updates, protection, and troubleshooting, as well as providing support
Used to contact you when necessary
Information sharing
We may collaborate with third-party service providers,
Such third-party service providers may collect information, which may include personal information, in accordance with their own terms of service, privacy policies, and other applicable policies.
You acknowledge and agree that we are not responsible for the privacy practices or other behavior of any third-party websites, services, or providers that may be used or enabled in the application.
Children's Privacy
Our products and services are not intended for use by persons under the age of seventeen (17) and we ask that such people not provide personal information through our websites, services or applications.
Update
We may change this privacy policy from time to time. All changes will be reflected on this page. If you do not want to allow us to change the use of your personal information. You can stop using our websites and applications.
Contact us
ming1997317@outlook.com
"""
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func termsAction() {
        dismissSettingAction()
        let vc = WebVC.loadStoryBoard()
        vc.title = "Terms of Use"
        vc.content = """
Use of the application
1.  You are not allowed to post any illegal remarks using our app
2. You agree to receive our automatic updates and other services
3. You may not use our applications for unauthorized commercial purposes, nor may you use our applications and services for illegal purposes.".
4. We will not retain your access log information, and you accept that we are not responsible for the content you access.
Update
We may update these terms of use on this page.
Contact us
ming1997317@outlook.com
"""
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    
    @IBAction func dismissAlert() {
        alertView.isHidden = true
    }
    
    @IBAction func cleanAction() {
        dismissAlert()
        let vc = CleanVC.loadStoryBoard()
        vc.modalPresentationStyle = .fullScreen
        vc.handle = {
            Task{
                if !Task.isCancelled {
                    try await Task.sleep(nanoseconds: 200_000_000)
                    self.alert("Clean Successful.")
                }
            }
        }
        self.present(vc, animated: true)
    }
    
    func observerViewStatus() {
        let isLoading = BrowserUtil.shared.isLoading
        let loadingCount = BrowserUtil.shared.count
        stopSearchButton.isHidden = !isLoading
        searchButton.isHidden = isLoading
        
        tabButton.setTitle("\(loadingCount)", for: .normal)
        tabButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        tabButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)

        searchTextField.text = BrowserUtil.shared.url
        progress = BrowserUtil.shared.progrss
        
        nextButton.isEnabled = BrowserUtil.shared.canGoForword
        lastButton.isEnabled = BrowserUtil.shared.canGoBack
        
        BrowserUtil.shared.delegate = self
        BrowserUtil.shared.uiDelegate = self
        
        if BrowserUtil.shared.url == nil  {
            BrowserUtil.shared.removeWebView()
        }
        
        if BrowserUtil.shared.progrss == 0.1 {
            startDate = Date()
            FirebaseUtil.log(event: .webStart)
        }
        
        if BrowserUtil.shared.progrss == 1.0 {
            let time = Date().timeIntervalSince1970 - (startDate ?? Date()).timeIntervalSince1970
            if startDate != nil {
                FirebaseUtil.log(event: .webSuccess, params: ["lig": "\(ceil(time))"])
            }
            startDate = nil
        }
    }
}

extension HomeVC: WKUIDelegate, WKNavigationDelegate {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        observerViewStatus()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction) async -> WKNavigationActionPolicy {
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return .allow
    }
    
    /// 响应后是否跳转
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse) async -> WKNavigationResponsePolicy {
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return .allow
    }
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        /// 打开新的窗口
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        webView.load(navigationAction.request)
        lastButton.isEnabled = webView.canGoBack
        nextButton.isEnabled = webView.canGoForward
        return nil
    }
}

enum HomeItem: String, CaseIterable{
    case  facebook, google, youtube, twitter, instagram, amazon, gmail, yahoo
    var url: String {
        return "https://www.\(self.rawValue).com"
    }
}
