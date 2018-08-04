//
//  UILabel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
/// 文本
extension UILabel{
    //创建文本
    class func buildLabel(text:String?=nil,textColor:UIColor,font:CGFloat,textAlignment:NSTextAlignment = .left) -> UILabel{
        let lbl=UILabel()
        lbl.text=text
        lbl.textColor=textColor
        lbl.font=UIFont.systemFont(ofSize:font)
        lbl.textAlignment=textAlignment
        return lbl
    }
    ///适配字体  兼容不同屏幕字体大小  已iPhone6为中心  iPhone5 字体小2号  iPhone6以上Plus 大2号
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
