//
//  PromotionPageViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/13.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import WMPageController
///促销
class PromotionPageViewController:WMPageController{
    private let titleArr=["销量","价格"]
    private var btnPushCar:UIButton?
    override func viewDidLoad() {
        setUpMenuView()
        super.viewDidLoad()
        self.title="促销商品区"
        self.view.backgroundColor=UIColor.viewBgdColor()
        ///去掉返回按钮文字
        let bark=UIBarButtonItem()
        bark.title=""
        bark.tintColor=UIColor.color333()
        self.navigationItem.backBarButtonItem=bark
        ///跳转到购物车按钮
        btnPushCar=UIButton(frame: CGRect.init(x:0, y:0, width:25,height:25))
        btnPushCar?.setImage(UIImage(named:"pushCar"), for: UIControlState.normal)
        btnPushCar?.addTarget(self,action:#selector(pushCar), for: UIControlEvents.touchUpInside)
        let pushCarItem=UIBarButtonItem(customView:btnPushCar!)

        pushCarItem.tintColor=UIColor.colorItem()
        self.navigationItem.rightBarButtonItem=pushCarItem
    }
    ///跳转到购物车
    @objc private func pushCar(){
        let vc=UIStoryboard.init(name:"Car", bundle:nil).instantiateViewController(withIdentifier:"CarVC") as! CarViewController
        self.navigationController?.pushViewController(vc, animated: true)
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
        let vc=PromotionViewController()
        vc.order=index == 0 ? "count":"price"
        vc.updateCarCountItemClosure={ (count) in
            self.btnPushCar?.showBadge(with: WBadgeStyle.number, value: count, animationType: WBadgeAnimType.none)
        }
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
extension PromotionPageViewController{
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

