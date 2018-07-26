//
//  DDJDStoreSwift-Bridging-Header.h
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/28.
//  Copyright © 2018年 zldd. All rights reserved.
//

// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

///旋转木马效果
#import "iCarousel.h"

///导航栏颜色控制
#import "UINavigationBar+Awesome.h"

///空视图提示
#import "UIScrollView+EmptyDataSet.h"

///小红点
#import "WZLBadgeImport.h"

/// 重写导航栏返回事件
#import "UIViewController+BackButtonHandler.h"

#import "UITextView+Placeholder.h"
