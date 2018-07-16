//
//  String.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation

extension String {
    ///截取字符串 从第几位开始 取到最后一位
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
    ///验证是否有表情符号
    var containsEmoji: Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case
            0x00A0...0x00AF,
            0x2030...0x204F,
            0x2120...0x213F,
            0x2190...0x21AF,
            0x2310...0x329F,
            0x1F000...0x1F9CF:
                return true
            default:
                continue
            }
        }
        return false
    }
    ///验证字符是否为空  true是  false不是
    public func isNil() -> Bool{
        if self == "" || self.count == 0{
            return true
        }else{
            return false
        }
    }
    /**
     //根据文字多少大小计算UILabel的宽高度

     - parameter font: UILabel大小
     - parameter size: UILabel的最大宽高

     - returns: 当前文本所占的宽高
     */
    func textSizeWithFont(font: UIFont, constrainedToSize size:CGSize) -> CGSize {
        var textSize:CGSize!
        if __CGSizeEqualToSize(size,CGSize.zero){
            let attributes=NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
            textSize=self.size(withAttributes:attributes as? [NSAttributedStringKey : Any])
        }else{
            let attributes=NSDictionary(object: font, forKey: NSAttributedStringKey.font as NSCopying)
            let stringRect = self.boundingRect(with:size, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes:attributes as? [NSAttributedStringKey : Any], context: nil)
            textSize = stringRect.size
        }
        return textSize
    }
    /*
     *去掉首尾空格
     */
    var removeHeadAndTailSpace:String {
        let whitespace = NSCharacterSet.whitespaces
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉首尾空格 包括后面的换行 \n
     */
    var removeHeadAndTailSpacePro:String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: whitespace)
    }
    /*
     *去掉所有空格
     */
    var removeAllSapce: String {
        return self.replacingOccurrences(of: " ", with: "", options: .literal, range: nil)
    }
    /*
     *去掉首尾空格 后 指定开头空格数
     */
    func beginSpaceNum(num: Int) -> String {
        var beginSpace = ""
        for _ in 0..<num {
            beginSpace += " "
        }
        return beginSpace + self.removeHeadAndTailSpacePro
    }
}
