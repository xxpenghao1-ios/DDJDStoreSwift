//
//  EmptyData+Extension.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/7.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation

extension UIViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
//    //图片
//    public func image(forEmptyDataSet scrollView: UIScrollView) -> UIImage? {
//          return UIImage(named:"emptyDataSet_defualt")?.reSizeImage(reSize:CGSize(width:497/3, height:150/3))
//
//    }
//    //设置图片动画
//    public func imageAnimation(forEmptyDataSet scrollView: UIScrollView) -> CAAnimation? {
//        let animation=CABasicAnimation(keyPath:"transform")
//        animation.fromValue = NSValue(caTransform3D:CATransform3DIdentity)
//        animation.toValue = NSValue(caTransform3D:CATransform3DMakeRotation(CGFloat.pi/2, 0, 0, 1.0))
//        animation.duration = 0.25;
//        animation.isCumulative=true
//        animation.repeatCount = MAXFLOAT;
//        return animation
//    }
//    //文字提示
//    public func title(forEmptyDataSet scrollView: UIScrollView) -> NSAttributedString? {
//        var text=""
//        let attributes=[NSAttributedStringKey.font:UIFont.systemFont(ofSize: 14),NSAttributedStringKey.foregroundColor:self.emptyDataSetTextColor ?? UIColor.color666()] as [NSAttributedStringKey : Any]
//        if !emptyDataSetIsLoading{ //如果不是加载状态 显示提示信息
//            if MEMBERID == -1{
//                text="您还没有登录,相关数据需要登录后才能展示"
//            }else{
//                text=emptyDataSetTextInfo
//            }
//        }
//        return NSAttributedString(string:text, attributes:attributes)
//    }
//    //设置文字和图片间距
//    public func spaceHeight(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
//        return 0
//    }
//    //设置垂直偏移量
//    public func verticalOffset(forEmptyDataSet scrollView: UIScrollView) -> CGFloat {
//        return 0
//    }
//    //是否执行动画
//    public func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView) -> Bool {
//        return emptyDataSetIsLoading
//    }
//    //设置是否可以滑动 默认不可以
//    func emptyDataSetShouldAllowScroll(_ scrollView: UIScrollView) -> Bool {
//        return true
//    }
//    ///是否显示
//    public func emptyDataSetShouldDisplay(_ scrollView: UIScrollView) -> Bool {
//        return emptyDataSetIsDisplay
//    }
}
