//
//  ClassifyPageViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/30.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import WMPageController
///分类
class ClassifyPageViewController:WMPageController{
    ///接收1级分类
    var model:GoodsCategoryModel?
    private let titleArr=["按品项","按品牌"]
    override func viewDidLoad() {
        setUpMenuView()
        super.viewDidLoad()
        self.title=model?.goodsCategoryName ?? "分类"
        self.view.backgroundColor=UIColor.viewBgdColor()
        ///去掉返回按钮文字
        let bark=UIBarButtonItem()
        bark.title=""
        bark.tintColor=UIColor.color333()
        self.navigationItem.backBarButtonItem=bark
        if model?.goodsCategoryName == "休闲零食"{
            self.navigationItem.rightBarButtonItem=UIBarButtonItem(title:"1元区", style: UIBarButtonItemStyle.done, target:self, action:#selector(pushGoodList1YuanArea))
        }
    }
    ///跳转到1元区
    @objc private func pushGoodList1YuanArea(){
        let vc=GoodListViewController()
        vc.flag=3
        vc.goodsCategoryId=model?.goodsCategoryId
        vc.titleStr="\(model?.goodsCategoryName ?? "")1元区"
        self.navigationController?.pushViewController(vc,animated:true)
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
        if index == 0{
            let vc=UIStoryboard(name:"Classify", bundle:nil).instantiateViewController(withIdentifier:"ClassifyVC") as! ClassifyViewController
            vc.goodsCategoryId=model?.goodsCategoryId
            return vc
        }else{
            let vc=BrandViewController()
            vc.goodsCategoryId=model?.goodsCategoryId
            return vc
        }
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
extension ClassifyPageViewController{
    //设置分页控件
    private  func setUpMenuView(){
        self.menuViewStyle = .line
        self.titleColorSelected = UIColor.applicationMainColor()
        self.titleSizeNormal = 15;
        self.titleSizeSelected = 15;
        self.menuItemWidth=80
        self.progressHeight=2
        self.titleColorNormal = UIColor.color333()
    }
}
