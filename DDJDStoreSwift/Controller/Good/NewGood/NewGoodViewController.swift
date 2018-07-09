//
//  NewGoodViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/7.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

///新品推荐
class NewGoodViewController:BaseViewController{

    private lazy var table:UITableView={
        let _table=UITableView()
        _table.tableFooterView=UIView()
        _table.backgroundColor=UIColor.clear
        _table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        _table.register(UINib(nibName:"NewGoodListTableViewCell", bundle:nil), forCellReuseIdentifier:"newGoodListId")
        return _table
    }()

    let vm=NewGoodViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="新品推荐"
        table.frame=self.view.bounds
        self.view.addSubview(table)
        bindViewModel()
    }
}
extension NewGoodViewController:Refreshable{

    private func bindViewModel(){

        ///创建数据源
        let dataSources=RxTableViewSectionedReloadDataSource<SectionModel<String,GoodDetailModel>>(configureCell:{ [weak self] (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"newGoodListId") as? NewGoodListTableViewCell ?? NewGoodListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"newGoodListId")
            if indexPath.row % 2 == 0{
                cell.contentView.backgroundColor=UIColor.white
            }else{
                cell.contentView.backgroundColor=UIColor.viewBgdColor()
            }
            cell.pushGoodDetailClosure={ model in
                self?.pushGoodDetail(model:model, imgView:cell.imgView)
            }
            cell.updateCell(model:model)
            return cell
        })

        ///绑定数据源
        vm.newGoodArrModelBR.asObservable().bind(to:table.rx.items(dataSource:dataSources)).disposed(by:rx_disposeBag)

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
    ///跳转到商品详情
    private func pushGoodDetail(model:GoodDetailModel,imgView:UIImageView){
        let vc=UIStoryboard(name:"GoodDetail", bundle:nil).instantiateViewController(withIdentifier:"GoodDetailVC") as! GoodDetailViewController
        vc.model=model
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
extension NewGoodViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
