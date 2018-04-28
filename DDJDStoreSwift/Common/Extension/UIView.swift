//
//  UIView.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/28.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import SnapKit
///定义一个布局协议
protocol Layoutable {
    func layoutMaker() ->(ConstraintMaker) -> Void
}
struct LeftSquareLayout : Layoutable {
    func layoutMaker() -> (ConstraintMaker) -> Void {
        return { maker in
            maker.leading.equalTo(self.superView).offset(8.0)
            maker.width.height.equalTo(self.length)
            maker.centerY.equalTo(self.superView)
        }
    }
    var length :CGFloat
    var superView : UIView
    init(length: CGFloat, superView:UIView) {
        self.length = length
        self.superView = superView
    }
}
extension UIView{
    ///UIView布局基于SnapKit
    func makeLayout(_ layouter:Layoutable) {
        snp.makeConstraints(layouter.layoutMaker())
    }
}
