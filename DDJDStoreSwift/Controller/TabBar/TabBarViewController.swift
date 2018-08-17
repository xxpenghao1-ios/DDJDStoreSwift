//
//  TabBarViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/12.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SwiftyJSON
///tabVC
class TabBarViewController:UITabBarController{

    ///更新购物车BadgeValue
    var updateCarBadgeValue=PublishSubject<Bool>()
    
    ///监听购物车商品变化
    private var addCarGoodCountVM=AddCarGoodCountViewModel()

    private var carVC=UIStoryboard.init(name:"Car", bundle:nil).instantiateViewController(withIdentifier:"CarVC") as! CarViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        //首页
        addChildViewController(IndexViewController(),title: "首页", imageName: "1")
        //分类
        addChildViewController(ClassifyPageViewController(), title:"分类", imageName:"2")

        //购物车
        addChildViewController(carVC, title:"购物车", imageName:"3")
        ///个人中心
        addChildViewController(MyViewController(), title:"个人中心", imageName:"4")
        self.tabBar.tintColor=UIColor.applicationMainColor()

        bindViewModel()

        //接收通知 更新购物车角标
        NotificationCenter.default.addObserver(self, selector:#selector(updateBadgeValue), name:NSNotification.Name(rawValue: "postBadgeValue"), object:nil)
    }
    /**
     初始化子控制器

     - parameter childController: 需要初始化的子控制器
     - parameter title:           子控制器的标题
     - parameter imageName:       子控制器的图片
     */
    private func addChildViewController(_ childController: UIViewController, title:String?, imageName:String) {

        // 1.设置子控制器对应的数据
        childController.tabBarItem.image = UIImage(named:imageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        childController.tabBarItem.selectedImage = UIImage(named:"selected_"+imageName)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)


        // 2.设置底部工具栏标题
        childController.tabBarItem.title=title

        // 3.给子控制器包装一个导航控制器
        let nav = UINavigationController()
        nav.addChildViewController(childController)

        // 4.将子控制器添加到当前控制器上
        addChildViewController(nav)
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}
extension TabBarViewController{
    /**
     收到通知更新角标

     - parameter notification:NSNotification
     */
    @objc func updateBadgeValue(_ notification:Notification){
        if notification.object != nil{
            let obj=notification.object as! Int
            if obj == 2{///购物车商品增加
                if notification.userInfo != nil{
                    let userInfo=JSON(notification.userInfo!)
                    let count=self.addCarGoodCountVM.queryCarSumCountBR.value+userInfo["carCount"].intValue
                    self.addCarGoodCountVM.queryCarSumCountBR.accept(count)
                }
            }else if obj == 3{ ///减少
                if notification.userInfo != nil{
                    let userInfo=JSON(notification.userInfo!)
                    let count=self.addCarGoodCountVM.queryCarSumCountBR.value-userInfo["carCount"].intValue
                    self.addCarGoodCountVM.queryCarSumCountBR.accept(count)

                }
            }else if obj == 4{///更新
                if notification.userInfo != nil{
                    let userInfo=JSON(notification.userInfo!)
                    let count=userInfo["carCount"].intValue
                    self.addCarGoodCountVM.queryCarSumCountBR.accept(count)
                }
            }else {//读取服务器购物车总数量
                updateCarBadgeValue.onNext(true)
            }
        }

    }
    private func bindViewModel(){

        ///更新购物商品数量 默认加载一次
        updateCarBadgeValue.startWith(true).delay(1, scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (b) in
            if b{
                ///查询购物车商品数量
                self?.addCarGoodCountVM.queryCarSumCountPS.onNext(true)
            }
        }).disposed(by:rx_disposeBag)

        ///查询购物车商品数量结果
        addCarGoodCountVM.queryCarSumCountBR.subscribe(onNext: { [weak self] (count) in
            if count > 0{
                self?.carVC.tabBarItem.badgeValue=count.description
            }else{
                self?.carVC.tabBarItem.badgeValue=nil
            }
        }).disposed(by:rx_disposeBag)
    }
}
