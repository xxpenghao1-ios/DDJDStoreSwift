//
//  MessageViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/4.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
///我的消息
class MessageViewController:BaseViewController{

    private let vm=MessageViewModel()

    private lazy var table:UITableView={
        let _table=UITableView()
        _table.tableFooterView=UIView.init(frame: CGRect.zero)
        _table.backgroundColor=UIColor.clear
        _table.separatorStyle = .none
        _table.register(UINib(nibName:"MessageTableViewCell",bundle:nil), forCellReuseIdentifier:"messageId")
        return _table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="我的消息"
        table.frame=self.view.bounds
        self.view.addSubview(table)
        bindViewModel()
    }
}
extension MessageViewController:Refreshable{

    private func bindViewModel(){

        ///创建数据源
        let dataSources=RxTableViewSectionedReloadDataSource<SectionModel<String,MessageModel>>(configureCell:{ (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"messageId") as? MessageTableViewCell ?? MessageTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"messageId")
            cell.updateCell(model:model)
            return cell
        })

        ///绑定数据源
        vm.messageArrBR.asObservable().bind(to:table.rx.items(dataSource:dataSources)).disposed(by:rx_disposeBag)

        table.rx.setDelegate(self).disposed(by:rx_disposeBag)

        ///刷新
        let refreshHeader=initRefreshHeader(table) { [weak self] in
            self?.vm.requestNewDataCommond.onNext(true)
        }
        ///加载更多
        let refreshFooter=initRefreshFooter(table) { [weak self] in
            self?.vm.requestNewDataCommond.onNext(false)
        }
        ///自动匹配当前刷新状态
        vm.autoSetRefreshHeaderStatus(header:refreshHeader, footer: refreshFooter).disposed(by:rx_disposeBag)
    }
}
extension MessageViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
