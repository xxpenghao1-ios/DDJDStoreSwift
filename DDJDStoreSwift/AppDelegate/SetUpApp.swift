//
//  SetUpApp.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
import IQKeyboardManagerSwift
///设置app
extension AppDelegate{
    ///设置app
    internal func setApp(){
        setNav()
        setThirdPartyFramework()
        ///初始化
        PHProgressHUD.initProgressHUD()
    }
    ///设置导航栏
    private func setNav(){
        //导航栏背景色
        UINavigationBar.appearance().barTintColor=UIColor.white
//        //导航栏文字颜色
//        UINavigationBar.appearance().titleTextAttributes=NSDictionary(object:UIColor.black, forKey:NSAttributedStringKey.foregroundColor as NSCopying) as? [NSAttributedStringKey : Any]
//        //设置导航栏不透明
//        //UINavigationBar.appearance().isTranslucent=false
//
//        UINavigationBar.appearance().tintColor=UIColor.
    }
}
///设置第三方框架
extension AppDelegate{
    internal func setThirdPartyFramework(){
        //开启键盘框架
        IQKeyboardManager.shared.enable = true
    }
}
