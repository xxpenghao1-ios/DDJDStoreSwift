//
//  UITextField.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
///创建输入框
extension UITextField{
    class func buildTxt(font:CGFloat,placeholder:String,tintColor:UIColor,keyboardType:UIKeyboardType) -> UITextField{
        let txt=UITextField()
        txt.adapterFont=font
        txt.attributedPlaceholder=NSAttributedString(string:placeholder, attributes: [NSAttributedStringKey.foregroundColor:UIColor.RGBFromHexColor(hexString: "#cccccc")])
        txt.backgroundColor=UIColor.clear
        txt.clearButtonMode=UITextFieldViewMode.whileEditing
        txt.tintColor=tintColor
        txt.keyboardType=keyboardType
        return txt
    }
    ///适配字体  兼容不同屏幕字体大小  以iPhone6为中心  iPhone5 字体小2号  iPhone6以上Plus 大2号
    @objc @IBInspectable public var adapterFont:CGFloat{
        set {
            if iPhone_5{
                font=UIFont.systemFont(ofSize:newValue-2)
            }else if iPhone_6Plus{
                font=UIFont.systemFont(ofSize:newValue+2)
            }else{
                font=UIFont.systemFont(ofSize:newValue)
            }
        }
        get{
            return 0
        }
    }
}
