//
//  ExchangeRecordViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
///兑换记录
class ExchangeRecordViewController:BaseViewController{
    
    private var vm=IntegralViewModel()

    private lazy var table:UITableView={
        let _table=UITableView(frame:self.view.bounds, style: UITableViewStyle.plain)
        _table.tableFooterView=UIView.init(frame: CGRect.zero)
        _table.emptyDataSetSource=self
        _table.emptyDataSetDelegate=self
        _table.backgroundColor=UIColor.clear
        _table.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        _table.register(ExchangeRecordTableViewCell.self, forCellReuseIdentifier:"exchangeRecordId")
        return _table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="兑换记录"
        self.view.addSubview(table)
        bindViewModel()
        self.emptyDataSetTextInfo="暂无兑换记录"
    }
}
extension ExchangeRecordViewController:Refreshable{

    private func bindViewModel(){

        vm.requestExchangeRecordPS.onNext(true)

        let dataSource=RxTableViewSectionedReloadDataSource<SectionModel<String,ExchangeRecordModel>>(configureCell:{ (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"exchangeRecordId") as? ExchangeRecordTableViewCell ??  ExchangeRecordTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"exchangeRecordId")
            cell.updateCell(model:model)
            return cell
        })

        table.rx.setDelegate(self).disposed(by:rx_disposeBag)

        //绑定数据
        vm.exchangeRecordBR.asObservable().map({ [weak self] (dic) in
            let emptyDataType=dic.keys.first ?? .noData
            self?.emptyDataType = emptyDataType
            return dic[emptyDataType] ?? []
        }).bind(to:table.rx.items(dataSource: dataSource)).disposed(by:rx_disposeBag)

        ///刷新
        let refreshHeader=initRefreshHeader(table) { [weak self] in
            self?.vm.requestExchangeRecordPS.onNext(true)

        }
        ///加载更多
        let refreshFooter=initRefreshFooter(table) { [weak self] in
            self?.vm.requestExchangeRecordPS.onNext(false)
        }
        ///自动匹配当前刷新状态
        vm.autoSetRefreshHeaderStatus(header:refreshHeader, footer: refreshFooter).disposed(by:rx_disposeBag)
    }
}

extension ExchangeRecordViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
