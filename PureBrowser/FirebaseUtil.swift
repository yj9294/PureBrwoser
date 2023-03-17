//
//  FirebaseUtil.swift
//  PureBrowser
//
//  Created by yangjian on 2023/3/8.
//

import Foundation
import Firebase

class FirebaseUtil: NSObject {
    static func log(event: AnaEvent, params: [String: Any]? = nil) {
        
        if event.first {
            if UserDefaults.standard.bool(forKey: event.rawValue) == true {
                return
            } else {
                UserDefaults.standard.set(true, forKey: event.rawValue)
            }
        }
        
        #if DEBUG
        #else
        Analytics.logEvent(event.rawValue, parameters: params)
        #endif
        
        NSLog("[Event] \(event.rawValue) \(params ?? [:])")
    }
    
    static func log(property: AnaProperty, value: String? = nil) {
        
        var value = value
        
        if property.first {
            if UserDefaults.standard.string(forKey: property.rawValue) != nil {
                value = UserDefaults.standard.string(forKey: property.rawValue)!
            } else {
                UserDefaults.standard.set(Locale.current.regionCode ?? "us", forKey: property.rawValue)
            }
        }
#if DEBUG
#else
        Analytics.setUserProperty(value, forName: property.rawValue)
#endif
        NSLog("[Property] \(property.rawValue) \(value ?? "")")
    }
}

enum AnaProperty: String {
    /// 設備
    case local = "ay_ys"
    
    var first: Bool {
        switch self {
        case .local:
            return true
        }
    }
}

enum AnaEvent: String {
    
    var first: Bool {
        switch self {
        case .open:
            return true
        default:
            return false
        }
    }
    
    case open = "lun_ys"
    case openCold = "er_ys"
    case openHot = "ew_ys"
    case homeShow = "eq_ys"
    case navigaClick = "ws_ys"
    case navigaSearch = "wa_ys"
    case cleanClick = "bu_ys"
    case cleanSuccess = "xian_ys"
    case cleanAlert = "dd_ys"
    case tabShow = "dl_ys"
    case tabNew = "acv_ys"
    case shareClick = "xmo_ys"
    case copyClick = "qws_ys"
    case webStart = "zxc_ys"
    case webSuccess = "bnm_ys"
}
