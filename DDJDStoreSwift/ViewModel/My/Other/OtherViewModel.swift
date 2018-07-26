//
//  OtherViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/26.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
///其他页面vm
class OtherViewModel:NSObject{
    ///服务人员电话
    var telBR=BehaviorRelay<String?>(value:nil)
    ///服务人员名称
    var userNameBR=BehaviorRelay<String?>(value:nil)
    override init() {
        super.init()
    }
}
extension OtherViewModel{


}
