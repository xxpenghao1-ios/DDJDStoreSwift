//
//  UIButton.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

/// 按钮
extension UIButton {
    ///创建按钮
    class func buildBtn(text:String,textColor:UIColor,font:CGFloat,backgroundColor:UIColor,cornerRadius:CGFloat?=nil) -> UIButton{
        let btn=UIButton()
        btn.setTitle(text, for: UIControlState.normal)
        btn.setTitleColor(textColor,for: UIControlState.normal)
        btn.titleLabel!.font=UIFont.systemFont(ofSize: font)
        btn.backgroundColor=backgroundColor
        if cornerRadius != nil{
            btn.layer.cornerRadius=cornerRadius!
        }
        return btn
    }
    /// 实现按钮半透明+不可点效果
    func disable(){
        self.isEnabled = false
        self.alpha = 0.5

    }
    /// 正常按钮+可点击效果
    func enable(){
        self.isEnabled = true
        self.alpha = 1
    }
}
extension Reactive where Base: UIButton {
    ///是否禁用按钮
    public var isDisable:Binder<Bool>{
        return Binder(self.base){ btn,b in
            b == true ? btn.enable(): btn.disable()
        }
    }
}
