//
//  OrderPageViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/5.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import WMPageController
///订单
class OrderPageViewController:WMPageController{
    ///接收订单状态
    var orderStatus:Int?
    private let titleArr=["未发货","已发货","已完成"]
    override func viewDidLoad() {
        setUpMenuView()
        super.viewDidLoad()
        self.title="进货订单"
        self.view.backgroundColor=UIColor.viewBgdColor()
        ///去掉返回按钮文字
        let bark=UIBarButtonItem()
        bark.title=""
        bark.tintColor=UIColor.color333()
        self.navigationItem.backBarButtonItem=bark
    }
    //设置显示几个页面
    override func numbersOfChildControllers(in pageController: WMPageController) -> Int {
        return titleArr.count
    }
    //设置显示标题数量
    override func numbersOfTitles(in menu: WMMenuView!) -> Int {
        return titleArr.count
    }
    //显示对应的标题
    override func pageController(_ pageController: WMPageController, titleAt index: Int) -> String {
        return titleArr[index]
    }
    //显示对应的页面
    override func pageController(_ pageController: WMPageController, viewControllerAt index: Int) -> UIViewController {
        let vc=OrderViewController()
        vc.orderStatus=index+1
        return vc
    }
    //设置menuView frame
    override func pageController(_ pageController: WMPageController, preferredFrameFor menuView: WMMenuView) -> CGRect {
        menuView.backgroundColor=UIColor.white
        return CGRect(x:0,y:NAV_HEIGHT,width:SCREEN_WIDTH,height:44)
    }
    //设置contentView frame
    override func pageController(_ pageController: WMPageController, preferredFrameForContentView contentView: WMScrollView) -> CGRect {
        return CGRect(x:0, y:44+NAV_HEIGHT,width:SCREEN_WIDTH,height:SCREEN_HEIGH-44-NAV_HEIGHT-BOTTOM_SAFETY_DISTANCE_HEIGHT)
    }
}
// MARK: - 设置页面
extension OrderPageViewController{
    //设置分页控件
    private  func setUpMenuView(){
        self.menuViewStyle = .line
        self.titleColorSelected = UIColor.applicationMainColor()
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 15;
        self.menuItemWidth=80
        self.progressHeight=2
        self.titleColorNormal = UIColor.color333()
        if orderStatus != nil{///如果订单状态不为空 跳转到对应状态页面
            self.selectIndex=Int32(orderStatus!-1)
        }
    }
}
