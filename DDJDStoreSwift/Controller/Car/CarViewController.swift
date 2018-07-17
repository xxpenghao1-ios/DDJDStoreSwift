//
//  CarViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/17.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
///购物车按钮
class CarViewController:BaseViewController{

    private var vm=CarViewModel()

    private lazy var table:UITableView={
        let _table=UITableView(frame:self.view.bounds)
        return _table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="购物车"
        bindViewModel()
    }
}

extension CarViewController{

    private func bindViewModel(){

    }
}
