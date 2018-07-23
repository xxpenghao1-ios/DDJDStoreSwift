//
//  IntegralRecordViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
///积分记录
class IntegralRecordViewController:BaseViewController{

    private var vm=IntegralViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="积分记录"

    }
}
