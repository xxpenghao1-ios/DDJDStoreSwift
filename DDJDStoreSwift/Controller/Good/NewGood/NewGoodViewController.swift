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

    ///跳转购物车按钮
    private var btnPushCar:UIButton!

    private var vm=NewGoodViewModel()

    private var addCarVM=AddCarGoodCountViewModel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///查询购物车商品数量
        addCarVM.queryCarSumCountPS.onNext(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="新品推荐区"
        table.frame=self.view.bounds
        table.emptyDataSetSource=self
        table.emptyDataSetDelegate=self
        //空视图提示文字
        self.emptyDataSetTextInfo="亲,暂无新品"
        self.view.addSubview(table)
        ///跳转到购物车按钮
        btnPushCar=UIButton(frame: CGRect.init(x:0, y:0, width:25,height:25))
        btnPushCar.setImage(UIImage(named:"pushCar"), for: UIControlState.normal)
        ///点击跳转购物车
        btnPushCar.rx.tap.asDriver(onErrorJustReturn: ()).drive(onNext: { [weak self] (_) in
            let vc=UIStoryboard.init(name:"Car", bundle:nil).instantiateViewController(withIdentifier:"CarVC") as! CarViewController
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by:rx_disposeBag)
        let pushCarItem=UIBarButtonItem(customView:btnPushCar)
        pushCarItem.tintColor=UIColor.colorItem()
        self.navigationItem.rightBarButtonItem=pushCarItem
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
            cell.updateCell(model:model)
            cell.pushGoodDetailClosure={ 
                self?.pushGoodDetail(model:model)
            }
            ///加入购物车车
            cell.addCarClosure={ (goodCount) in
                self?.addCarVM.addCar(model:model,goodsCount:goodCount,flag:2)
            }
            return cell
        })



        ///更新购物车item按钮数量
        addCarVM.queryCarSumCountBR.asDriver(onErrorJustReturn:0).drive(onNext: { [weak self] (count) in
            self?.btnPushCar.showBadge(with: WBadgeStyle.number, value: count, animationType: WBadgeAnimType.none)
        }).disposed(by:rx_disposeBag)

        ///绑定数据源
        vm.newGoodArrModelBR.asObservable()
            .map({ [weak self] (dic) -> [SectionModel<String,GoodDetailModel>] in
                let emptyDataType=dic.keys.first ?? .noData
                self?.emptyDataType = emptyDataType
                return dic[emptyDataType] ?? []
            }).bind(to:table.rx.items(dataSource:dataSources)).disposed(by:rx_disposeBag)

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
    private func pushGoodDetail(model:GoodDetailModel){
        let vc=UIStoryboard(name:"GoodDetail", bundle:nil).instantiateViewController(withIdentifier:"GoodDetailVC") as! GoodDetailViewController
        vc.model=model
        vc.flag=2
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
extension NewGoodViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
