//
//  MJRefresh.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import MJRefresh
///自定义刷新控件
class PHNormalHeader:MJRefreshNormalHeader{
    override func prepare() {
        super.prepare()
        // 隐藏时间
        self.lastUpdatedTimeLabel.isHidden=true
        // 隐藏状态
        self.stateLabel.isHidden = true;
    }
}
///自定义加载控件
class PHNormalFooter:MJRefreshAutoStateFooter{
    override func prepare() {
        super.prepare()
        self.stateLabel.textColor=UIColor.color999()
    }
}
