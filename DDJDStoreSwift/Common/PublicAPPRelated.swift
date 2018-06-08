//
//  PublicAPPRelated.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/26.
//  Copyright © 2018年 zldd. All rights reserved.
//
import UIKit
///图片请求路径
let URL_IMG="http://www.hnddjd.com";
///c.hnddjd.com
///数据请求路径
let URL="http://www.hnddjd.com/front/";

/// 屏幕宽
let SCREEN_WIDTH=UIScreen.main.bounds.width

/// 屏幕高
let SCREEN_HEIGH=UIScreen.main.bounds.height

/// 导航栏高度
let NAV_HEIGHT:CGFloat=SCREEN_HEIGH==812.0 ? 88 : 64

/// 底部安全距离
let BOTTOM_SAFETY_DISTANCE_HEIGHT:CGFloat=SCREEN_WIDTH==812.0 ? 34 : 0

/// tabBar高度
let TAB_BAR_HEIGHT:CGFloat=SCREEN_HEIGH==812.0 ? 83 : 49

/// 全局缓存
let USER_DEFAULTS=UserDefaults.standard

/// 商品默认图片
let GOOD_DEFAULT_IMG="good_defualt"

/// 幻灯片默认图片
let SLIDE_DEFAULT="good_defualt"


let APP=UIApplication.shared.delegate as! AppDelegate

// 自定义打印方法
func phLog<T>(_ message : T, file : String = #file, funcName : String = #function, lineNum : Int = #line) {

    #if DEBUG

    let fileName = (file as NSString).lastPathComponent

    print("\(fileName):(row\(lineNum))-\(message)")

    #endif
}
