//
//  Array.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/29.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
extension Array{
    // 数组去重
    func filterDuplicates<E: Equatable>(_ filter: (Element) -> E) -> [Element] {
        var result = [Element]()
        for value in self {
            let key = filter(value)
            if !result.map({filter($0)}).contains(key) {
                result.append(value)
            }
        }
        return result
    }
}
