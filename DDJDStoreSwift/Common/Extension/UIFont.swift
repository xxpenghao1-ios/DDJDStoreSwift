//
//  UIFont.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
extension UIFont{

    ///ps字体转ios字体
    class func ps_systemFont(psOfSize:CGFloat) -> UIFont{
        let pt=(psOfSize/96)*72
        print(pt)
        let font=UIFont.systemFont(ofSize:pt)
        return font
    }
}
