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
}
