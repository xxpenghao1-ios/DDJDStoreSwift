//
//  OrderViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/5.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
///订单
class OrderViewController:BaseViewController{
    ///接收订单状态 1未发货 2已发货 3已完成
    var orderStatus:Int?

    private var vm:OrderViewModel!

    private lazy var table:UITableView={
        let _table=UITableView()
        _table.tableFooterView=UIView(frame: CGRect.zero)
        _table.backgroundColor=UIColor.clear
        _table.separatorInset = UIEdgeInsetsMake(0,0,0,0)
        _table.register(UINib(nibName:"OrderListTableViewCell", bundle:nil), forCellReuseIdentifier:"orderListId")
        return _table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        table.frame=CGRect.init(x:0,y:0, width:SCREEN_WIDTH, height:SCREEN_HEIGH-NAV_HEIGHT-44-BOTTOM_SAFETY_DISTANCE_HEIGHT)
        self.view.addSubview(table)
        vm=OrderViewModel(orderStatus:orderStatus)
        bindViewModel()
        self.table.mj_header.beginRefreshing()
    }
}
extension OrderViewController:Refreshable{

    private func bindViewModel(){
        ///创建数据源
        let dataSources=RxTableViewSectionedReloadDataSource<SectionModel<String,OrderModel>>(configureCell:{ (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"orderListId") as? OrderListTableViewCell ?? OrderListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"orderListId")
            cell.updateCell(model:model)
            return cell
        })

        ///绑定数据源
        vm.orderArrModelBR.asObservable().bind(to:table.rx.items(dataSource:dataSources)).disposed(by:rx_disposeBag)

        table.rx.setDelegate(self).disposed(by:rx_disposeBag)

        ///点击cell查看详情
        table.rx.modelSelected(OrderModel.self).subscribe(onNext: { [weak self] (model) in
            let vc=UIStoryboard(name:"OrderDetail", bundle:nil).instantiateViewController(withIdentifier:"OrderDetailVC") as! OrderDetailViewController
            vc.orderinfoId=model.orderinfoId
            self?.navigationController?.pushViewController(vc, animated:true)
        }).disposed(by:rx_disposeBag)
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
extension OrderViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 217
    }
}
