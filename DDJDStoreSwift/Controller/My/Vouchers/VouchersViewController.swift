//
//  VouchersViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/25.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
///代金券
class VouchersViewController:BaseViewController{
    ///如果有值 表示从订单页面跳转过来的  点击立即使用 返回使用代金券信息
    var orderFlag:Int?

    ///使用代金券 返回对应信息
    var useVouchersClosure:((_ model:VouchersModel) -> Void)?

    private lazy var table:UITableView={
        let _table=UITableView(frame:self.view.bounds, style: UITableViewStyle.plain)
        _table.tableFooterView=UIView.init(frame: CGRect.zero)
        _table.emptyDataSetSource=self
        _table.emptyDataSetDelegate=self
        _table.backgroundColor=UIColor.clear
        _table.separatorStyle = .none
        _table.register(UINib(nibName:"VouchersTableViewCell", bundle:nil), forCellReuseIdentifier:"vouchersId")
        return _table
    }()
    private var vm=VouchersViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="代金券"
        self.view.addSubview(table)
        self.emptyDataSetTextInfo="还木有可以使用的代金券"
        bindViewModel()
    }
}
extension VouchersViewController:Refreshable{

    private func bindViewModel(){

        vm.requestVouchersPS.onNext(true)

        ///创建数据源
        let dataSources=RxTableViewSectionedReloadDataSource<SectionModel<String,VouchersModel>>(configureCell:{ [weak self] (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"vouchersId") as? VouchersTableViewCell ?? VouchersTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"vouchersId")
            cell.updateCell(model:model)
            cell.immediateUseClosure={
                if self?.orderFlag == nil{///弹出提示信息
                    self?.showPromptInfo()
                }else{///使用代金券
                    self?.useVouchersClosure?(model)
                    self?.navigationController?.popViewController(animated:true)
                }
            }
            return cell
        })
        ///绑定数据源
        vm.vouchersBR.asObservable()
            .map({ [weak self] (dic) -> [SectionModel<String,VouchersModel>] in
                let emptyDataType=dic.keys.first ?? .noData
                self?.emptyDataType = emptyDataType
                return dic[emptyDataType] ?? []
            }).bind(to:table.rx.items(dataSource:dataSources)).disposed(by:rx_disposeBag)

        table.rx.setDelegate(self).disposed(by:rx_disposeBag)
        ///刷新
        let refreshHeader=initRefreshHeader(table) { [weak self] in
            self?.vm.requestVouchersPS.onNext(true)
        }
        ///加载更多
        let refreshFooter=initRefreshFooter(table) { [weak self] in
            self?.vm.requestVouchersPS.onNext(false)
        }
        ///自动匹配当前刷新状态
        vm.autoSetRefreshHeaderStatus(header:refreshHeader, footer: refreshFooter).disposed(by:rx_disposeBag)
    }
    ///弹出提示信息
    private func showPromptInfo(){
        UIAlertController.showAlertYes(self, title:"点单即到", message:"订单代金券可以在下单的时候使用", okButtonTitle:"知道了")
    }
}
extension VouchersViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
