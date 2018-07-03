//
//  BaseViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/26.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
///父类
class BaseViewController:UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.viewBgdColor()
        isLogin()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        phLog("内存报警了")
        ///清除缓存
        KingfisherManager.shared.cache.clearMemoryCache()
        KingfisherManager.shared.cache.clearDiskCache()
    }
}
///验证登录缓存信息
extension BaseViewController{
    ///是否登录
    private func isLogin(){
        if storeId == nil || storeId == nil || substationId == nil{
            UIAlertController.showAlertYes(self,title:"提示", message:"您的登录信息已过期,请重新登录", okButtonTitle:"确定") { (action) in
                APP.jumpToLoginVC()
            }
        }
    }
}
