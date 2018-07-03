//
//  TabBarViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/12.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
///tabVC
class TabBarViewController:UITabBarController{
    override func viewDidLoad() {
        super.viewDidLoad()
        //首页
        addChildViewController(IndexViewController(),title: "首页", imageName: "1")
        //分类
        addChildViewController(ClassifyPageViewController(), title:"分类", imageName:"2")
        ///个人中心
        addChildViewController(MyViewController(), title:"个人中心", imageName:"4")
        self.tabBar.tintColor=UIColor.applicationMainColor()
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
