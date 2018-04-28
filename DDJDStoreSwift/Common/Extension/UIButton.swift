//
//  UIButton.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit

/// 按钮
extension UIButton {

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
}
