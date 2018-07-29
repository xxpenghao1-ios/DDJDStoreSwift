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
import SVProgressHUD
///图片缓存信息
let cache=KingfisherManager.shared.cache
///父类
class BaseViewController:UIViewController{

    /*****默认加载页参数*****/

    //空视图提示信息 默认为空
    var emptyDataSetTextInfo=""
    ///空视图 默认加载状态
    var emptyDataType:EmptyDataType = .loading
    ///空视图是否显示 默认显示
    var emptyDataIsHidden=true

    /******************************/

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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if SVProgressHUD.isVisible(){//退出页面如果还存在0.5后隐藏
            SVProgressHUD.dismiss(withDelay:0.5)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        phLog("内存报警了")
        ///清除缓存
        cache.clearMemoryCache()
        cache.clearDiskCache()
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
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
        ///清除推送信息
        PHJPushHelper.removeTagAndAlias()
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

            setStatusBarBackgroundColor(color:UIColor.RGBFromHexColor(hexString:"ff1261"))
        }else{
            ///还原导航栏底部黑线
            self.navigationController?.navigationBar.shadowImage=nil
            ///还原导航颜色
            self.navigationController?.navigationBar.lt_reset()

            setStatusBarBackgroundColor(color:UIColor.white)
        }
    }
    //设置状态栏背景颜色
    func setStatusBarBackgroundColor(color : UIColor) {
        let statusBarWindow : UIView = UIApplication.shared.value(forKey: "statusBarWindow") as! UIView
        let statusBar : UIView = statusBarWindow.value(forKey: "statusBar") as! UIView
        if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
            statusBar.backgroundColor = color
        }
    }
}
///空视图展示 对应视图
public enum EmptyDataType{
    ///加载状态
    case loading
    ///无网络
    case noNewWork
    ///没有数据
    case noData
    ///数据出错了
    case dataError
}
///空视图提示
extension BaseViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    ///图片
    func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
        switch emptyDataType {
        case .loading:
            return UIImage(named:"loading")?.reSizeImage(reSize:CGSize(width:45,height:45))
        case .noNewWork:
            return UIImage(named:"network_error")
        case .noData:
            return UIImage(named:"data_nil")
        case .dataError:
            return UIImage(named:"data_error")
        }
    }
    //设置图片动画
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
        let animation=CABasicAnimation(keyPath:"transform")
        animation.fromValue = NSValue(caTransform3D:CATransform3DIdentity)
        animation.toValue = NSValue(caTransform3D:CATransform3DMakeRotation(CGFloat.pi/2, 0, 0, 1.0))
        animation.duration = 0.25;
        animation.isCumulative=true
        animation.repeatCount = MAXFLOAT;
        return animation
    }
    //文字提示
    func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
        var text=""
        let attributes=[NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:UIColor.color666()] as [NSAttributedStringKey : Any]
        switch emptyDataType {
        case .loading:
            text="正在努力的加载中..."
        case .noNewWork:
            text="世界上最远的距离是没有网络"
        case .noData:
            text=self.emptyDataSetTextInfo
        case .dataError:
            text="获取数据出错了,刷新试试"
        }
        return NSAttributedString(string:text, attributes:attributes)
    }
    //设置文字和图片间距
    func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 0
    }
    //设置垂直偏移量
    func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
        return 0
    }
    //是否执行动画
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
        if emptyDataType == .loading{
            return true
        }else{
            return false
        }
    }
    //设置是否可以滑动 默认不可以
    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
        if emptyDataType == .loading{
            return false
        }else{
            return true
        }
    }
    ///是否显示
    func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
        return emptyDataIsHidden
    }
}
