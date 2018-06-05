//
//  ViewModelType.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/28.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
///协议
protocol ViewModelType {
    associatedtype Input //输入
    associatedtype Output //输出
    func transform(input: Input) -> Output
}
