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
        txt.font=UIFont.systemFont(ofSize:font)
        txt.attributedPlaceholder=NSAttributedString(string:placeholder, attributes: [NSAttributedStringKey.foregroundColor:UIColor.RGBFromHexColor(hexString: "#cccccc")])
        txt.backgroundColor=UIColor.clear
        txt.clearButtonMode=UITextFieldViewMode.whileEditing
        txt.tintColor=tintColor
        txt.keyboardType=keyboardType
        return txt
    }
}
