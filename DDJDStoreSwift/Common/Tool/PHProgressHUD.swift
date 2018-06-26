//
//  PHProgressHUD.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/28.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import SVProgressHUD

public enum HUDType {
    case success
    case error
    case loading
    case info
    case progress
}

class PHProgressHUD: NSObject {
    class func initProgressHUD() {
        SVProgressHUD.setForegroundColor(UIColor(white: 1, alpha: 1))
        SVProgressHUD.setBackgroundColor(UIColor(white: 0.15, alpha: 0.85))
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 14.0))
        SVProgressHUD.setDefaultMaskType(.none)
        SVProgressHUD.setMinimumDismissTimeInterval(2)
    }

    class func showSuccess(_ status: String) {
        self.showProgressHUD(type: .success, status: status)
    }
    class func showError(_ status: String) {
        self.showProgressHUD(type: .error, status: status)
    }
    class func showLoading(_ status: String) {
        self.showProgressHUD(type: .loading, status: status)
    }
    class func showInfo(_ status: String) {
        self.showProgressHUD(type: .info, status: status)
    }
    class func showProgress(_ status: String, _ progress: CGFloat) {
        self.showProgressHUD(type: .success, status: status, progress: progress)
    }
    class func dismissHUD(_ delay: TimeInterval = 0) {
        SVProgressHUD.dismiss(withDelay: delay)
    }
}

extension PHProgressHUD {
    fileprivate class func showProgressHUD(type: HUDType,status:String, progress: CGFloat = 0) {
        switch type {
        case .success:
            SVProgressHUD.showSuccess(withStatus: status)
        case .error:
            SVProgressHUD.showError(withStatus: status)
        case .loading:
            SVProgressHUD.show(withStatus:status)
            SVProgressHUD.setDefaultMaskType(.clear)
        case .info:
            SVProgressHUD.showInfo(withStatus: status)
        case .progress:
            SVProgressHUD.showProgress(Float(progress), status: status)
        }
    }
}
