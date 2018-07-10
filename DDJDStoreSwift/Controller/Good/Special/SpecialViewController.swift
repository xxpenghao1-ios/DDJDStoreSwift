//
//  SpecialViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/10.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
///特价页面
class SpecialViewController:BaseViewController {
    ///接收查询状态  默认按销量
    var order="count"

    private var vm:SpecialGoodViewModel!

    private lazy var table:UITableView={
        let _table=UITableView()
        _table.tableFooterView=UIView(frame: CGRect.zero)
        _table.backgroundColor=UIColor.clear
        _table.separatorInset = UIEdgeInsetsMake(0,0,0,0)
        _table.register(UINib(nibName:"SpecialGoodTableViewCell", bundle:nil), forCellReuseIdentifier:"specialGoodId")
//        _table.emptyDataSetDelegate=self
//        _table.emptyDataSetSource=self
        return _table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        table.frame=CGRect.init(x:0,y:2, width:SCREEN_WIDTH, height:SCREEN_HEIGH-NAV_HEIGHT-44-BOTTOM_SAFETY_DISTANCE_HEIGHT-2)
        self.view.addSubview(table)

        ///空视图提示文字
//        self.emptyDataSetTextInfo="亲,暂时没有查询到特价活动"

        bindViewModel()

    }
}
///绑定vm
extension SpecialViewController:Refreshable{

    private func bindViewModel(){

        vm=SpecialGoodViewModel(order:order)

        ///创建数据源
        let dataSources=RxTableViewSectionedReloadDataSource<SectionModel<String,GoodDetailModel>>(configureCell:{ [weak self] (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"specialGoodId") as? SpecialGoodTableViewCell ?? SpecialGoodTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"specialGoodId")
//            if indexPath.row % 2 == 0{
//                cell.contentView.backgroundColor=UIColor.white
//            }else{
//                cell.contentView.backgroundColor=UIColor.viewBgdColor()
//            }
//            cell.pushGoodDetailClosure={ model in
//                self?.pushGoodDetail(model:model, imgView:cell.imgView)
//            }
            cell.updateCell(model:model)
            return cell
        })

        ///绑定数据源
        vm.specialArrModelBR.asObservable().bind(to:table.rx.items(dataSource:dataSources)).disposed(by:rx_disposeBag)

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
extension SpecialViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
