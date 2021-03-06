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

    private lazy var table:UITableView={
        let _table=UITableView(frame:self.view.bounds, style: UITableViewStyle.plain)
        _table.tableFooterView=UIView.init(frame: CGRect.zero)
        _table.emptyDataSetSource=self
        _table.emptyDataSetDelegate=self
        _table.backgroundColor=UIColor.clear
        _table.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        _table.register(IntegralRecordTableViewCell.self, forCellReuseIdentifier:"integralRecordId")
        return _table
    }()

    private var vm=IntegralViewModel()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="点单币记录"
        self.view.addSubview(table)
        bindViewModel()
        self.emptyDataSetTextInfo="还木有点单币使用记录"

    }
}
extension IntegralRecordViewController:Refreshable{

    private func bindViewModel(){

        vm.requestIntegralRecordPS.onNext(true)

        let dataSource=RxTableViewSectionedReloadDataSource<SectionModel<String,IntegralRecordModel>>(configureCell:{ (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"integralRecordId") as? IntegralRecordTableViewCell ??  IntegralRecordTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"integralRecordId")
            cell.updateCell(model:model)
            return cell
        })

        table.rx.setDelegate(self).disposed(by:rx_disposeBag)

        //绑定数据
        vm.integralRecordBR.asObservable().map({ [weak self] (dic) in
            let emptyDataType=dic.keys.first ?? .noData
            self?.emptyDataType = emptyDataType
            return dic[emptyDataType] ?? []
        }).bind(to:table.rx.items(dataSource: dataSource)).disposed(by:rx_disposeBag)

        ///刷新
        let refreshHeader=initRefreshHeader(table) { [weak self] in
            self?.vm.requestIntegralRecordPS.onNext(true)

        }
        ///加载更多
        let refreshFooter=initRefreshFooter(table) { [weak self] in
            self?.vm.requestIntegralRecordPS.onNext(false)
        }
        ///自动匹配当前刷新状态
        vm.autoSetRefreshHeaderStatus(header:refreshHeader, footer: refreshFooter).disposed(by:rx_disposeBag)
    }
}

extension IntegralRecordViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}
