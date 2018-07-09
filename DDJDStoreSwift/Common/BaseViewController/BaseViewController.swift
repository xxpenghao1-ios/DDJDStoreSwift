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
import RxCocoa
import RxSwift
///图片缓存信息
let cache=KingfisherManager.shared.cache
///父类
class BaseViewController:UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMyVCNav()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.viewBgdColor()
        ///去掉返回按钮文字
        let bark=UIBarButtonItem()
        bark.title=""
        bark.tintColor=UIColor.color333()
        self.navigationItem.backBarButtonItem=bark
        isLogin()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        phLog("内存报警了")
        ///清除缓存
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
}
///验证登录缓存信息
extension BaseViewController{
    ///是否登录
    private func isLogin(){
        if store_Id == nil || county_Id == nil || substation_Id == nil || member_Id == nil{
            UIAlertController.showAlertYes(self,title:"提示", message:"您的登录信息已过期,请重新登录", okButtonTitle:"确定") { (action) in
                APP.jumpToLoginVC()
            }
        }
    }
    ///清除用户缓存信息
    func clearUserDefault(){
        USER_DEFAULTS.removeObject(forKey:"storeId")
        USER_DEFAULTS.removeObject(forKey:"countyId")
        USER_DEFAULTS.removeObject(forKey:"county")
        USER_DEFAULTS.removeObject(forKey:"substationId")
        USER_DEFAULTS.removeObject(forKey:"storeName")
        USER_DEFAULTS.removeObject(forKey:"memberId")
        USER_DEFAULTS.synchronize()
    }
}

// MARK: - 设置导航栏颜色
extension BaseViewController{
    ///设置个人中心导航栏
    private func setMyVCNav(){
        if self.isKind(of:MyViewController.classForCoder()){
            ///底部黑线设置和 背景颜色一样
            self.navigationController?.navigationBar.shadowImage=UIImage.imageFromColor(UIColor.RGBFromHexColor(hexString:"ff1261"))

            ///设置导航栏颜色
            self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.RGBFromHexColor(hexString:"ff1261"))
        }else{
            ///还原导航栏底部黑线
            self.navigationController?.navigationBar.shadowImage=nil
            ///还原导航颜色
            self.navigationController?.navigationBar.lt_reset()
        }
    }

}

