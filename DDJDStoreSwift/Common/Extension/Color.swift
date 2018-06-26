
//
//  Color.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
extension UIColor{
    ///主题色
    class func applicationMainColor() -> UIColor {
        return UIColor.RGBFromHexColor(hexString:"e33e68")
    }
    //商品详情边框颜色
    class func goodDetailBorderColor() ->UIColor {
        return UIColor(red:236/255, green:236/255, blue:236/255, alpha: 1)
    }
    ///价钱颜色
    class func priceColor() -> UIColor{
        return UIColor.RGBFromHexColor(hexString:"ff1261")
    }
    //页面背景颜色
    class func viewBgdColor() ->UIColor{
        return UIColor(red: 246/255, green:246/255, blue:246/255, alpha: 1.0)
    }
    //文字颜色
    class func textColor() ->UIColor {
        return UIColor(red: 104/255, green:104/255, blue:104/255, alpha: 1.0);
    }
    //商品价格颜色
    class func goodPriceColor() ->UIColor {
        return UIColor(red:225/255, green:45/255, blue:45/255, alpha:1)
    }
    //边框颜色
    class func borderColor() ->UIColor {
        return UIColor.RGBFromHexColor(hexString:"e2e2e4")
    }
    class func cellBorderColor() -> UIColor{
        return UIColor(red:222/255, green:223/255, blue:225/255, alpha:1)
    }
    //导航栏底部边线颜色
    class func navLineColor() -> UIColor{
        return UIColor.RGBFromHexColor(hexString:"e5e5e5")
    }
    //底部抢单视图颜色
    class func orderBottom() -> UIColor{
        return UIColor(red:32/255, green:32/255, blue:32/255, alpha: 1.0);
    }
    class func color666() -> UIColor{
        return UIColor.RGBFromHexColor(hexString:"666666")
    }
    class func color999() -> UIColor{
        return UIColor.RGBFromHexColor(hexString:"999999")
    }
    class func color333() -> UIColor{
        return UIColor.RGBFromHexColor(hexString:"333333")
    }
}
//extension UIColor {
//    public class func RGBFromHexColor(hexString: String, alpha: CGFloat? = 1.0) -> UIColor {
//
//        var cString = hexString.trimmingCharacters(in:.whitespacesAndNewlines).uppercased()
//        if (cString.hasPrefix("#")) {
//            cString = String(cString[cString.index(after: cString.startIndex)..<cString.endIndex])
//
//        }
//        if (cString.count != 6) {
//            return UIColor.clear
//        }
//        let rString = cString[..<cString.index(cString.startIndex, offsetBy: 2)]
//        let gString = cString[cString.index(cString.startIndex, offsetBy: 2)..<cString.index(cString.startIndex, offsetBy: 4)]
//        let bString = cString[cString.index(cString.endIndex, offsetBy: -2)..<cString.endIndex]
//
//        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
//        Scanner(string: String(rString)).scanHexInt32(&r)
//        Scanner(string: String(gString)).scanHexInt32(&g)
//        Scanner(string: String(bString)).scanHexInt32(&b)
//        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: alpha!)
//    }
//
//}

extension UIColor{
    class func RGBFromHexColor(hexString: String) -> UIColor{

        var cString: String = hexString.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)

        if cString.count < 6 {
            return UIColor.black
        }
        if cString.hasPrefix("0X") {

            cString = cString.substring(from:2)

        }
        if cString.hasPrefix("#") {
            cString = cString.substring(from:1)
        }
        if cString.count != 6 {
            return UIColor.black
        }

        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)

        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)


        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: 1)


    }
}


