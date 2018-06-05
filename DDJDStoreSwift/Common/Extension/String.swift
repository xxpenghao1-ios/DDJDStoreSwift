//
//  String.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation

extension String {
    ///截取字符串 重第几位开始
    public func substring(from index: Int) -> String {
        if self.count > index {
            let startIndex = self.index(self.startIndex, offsetBy: index)
            let subString = self[startIndex..<self.endIndex]

            return String(subString)
        } else {
            return self
        }
    }
    ///验证字符串长度  true满足条件 false不满足
    public func validateStrCount(count:Int) -> Bool{
        if self.count == count{
            return true
        }else{
            return false
        }
    }

    ///验证字符是否为空  true是  false不是
    public func isNil() -> Bool{
        if self == "" || self.count == 0{
            return true
        }else{
            return false
        }
    }
}
