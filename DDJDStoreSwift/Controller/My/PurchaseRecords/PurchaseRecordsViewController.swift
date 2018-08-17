//
//  PurchaseRecordsViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/25.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxDataSources
import RxCocoa
import RxSwift
///购买记录
class PurchaseRecordsViewController:BaseViewController{

    private var table:UITableView!
    ///跳转到购物车按钮
    private var btnPushCar:UIButton?

    private var vm=PurchaseRecordsViewModel()

    private var addCarVM=AddCarGoodCountViewModel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///查询购物车商品数量
        addCarVM.queryCarSumCountPS.onNext(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="购买记录"
        table=UITableView(frame:self.view.bounds, style: UITableViewStyle.plain)
        table.tableFooterView=UIView.init(frame: CGRect.zero)
        table.emptyDataSetSource=self
        table.emptyDataSetDelegate=self
        table.backgroundColor=UIColor.clear
        table.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        table.register(UINib(nibName:"PurchaseRecordsTableViewCell", bundle:nil), forCellReuseIdentifier:"purchaseRecordsId")
        self.view.addSubview(table)
        self.emptyDataSetTextInfo="暂无购买记录"
        ///跳转到购物车按钮
        btnPushCar=UIButton(frame: CGRect.init(x:0, y:0, width:25,height:25))
        btnPushCar!.setImage(UIImage(named:"pushCar"), for: UIControlState.normal)
        ///点击跳转购物车
        btnPushCar!.rx.tap.asDriver(onErrorJustReturn:()).drive(onNext: { [weak self] (_) in
            let vc=UIStoryboard.init(name:"Car", bundle:nil).instantiateViewController(withIdentifier:"CarVC") as! CarViewController
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by:rx_disposeBag)

        let pushCarItem=UIBarButtonItem(customView:btnPushCar!)
        pushCarItem.tintColor=UIColor.colorItem()
        self.navigationItem.rightBarButtonItem=pushCarItem
        bindViewModel()
    }
}
extension PurchaseRecordsViewController:Refreshable{

    private func bindViewModel(){
        vm.requestPurchaseRecordsPS.onNext(true)
        ///创建数据源
        let dataSources=RxTableViewSectionedReloadDataSource<SectionModel<String,GoodDetailModel>>(configureCell:{ [weak self] (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"purchaseRecordsId") as? PurchaseRecordsTableViewCell ?? PurchaseRecordsTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"purchaseRecordsId")
            if indexPath.row % 2 == 0{
                cell.contentView.backgroundColor=UIColor.white
            }else{
                cell.contentView.backgroundColor=UIColor.viewBgdColor()
            }
            model.uprice=model.subSupplierUprice
            ///跳转到商品详情
            cell.pushGoodDetailClosure={
                self?.pushGoodDetail(model:model)
            }
            ///加入购物车车
            cell.addCarClosure={
                self?.addCarVM.addCar(model:model,goodsCount:model.miniCount ?? 1,flag:2)
            }
            cell.updateCell(model:model)
            return cell
        })

        ///更新购物车item按钮数量
        addCarVM.queryCarSumCountBR.asDriver(onErrorJustReturn:0).drive(onNext: { [weak self] (count) in
            self?.btnPushCar?.showBadge(with: WBadgeStyle.number, value: count, animationType: WBadgeAnimType.none)
        }).disposed(by:rx_disposeBag)

        ///绑定数据源
        vm.purchaseRecordsBR.asObservable()
            .map({ [weak self] (dic) -> [SectionModel<String,GoodDetailModel>] in
                let emptyDataType=dic.keys.first ?? .noData
                self?.emptyDataType = emptyDataType
                return dic[emptyDataType] ?? []
            }).bind(to:table.rx.items(dataSource:dataSources)).disposed(by:rx_disposeBag)

        table.rx.setDelegate(self).disposed(by:rx_disposeBag)

        ///刷新
        let refreshHeader=initRefreshHeader(table) { [weak self] in
            self?.vm.requestPurchaseRecordsPS.onNext(true)
        }
        ///加载更多
        let refreshFooter=initRefreshFooter(table) { [weak self] in
            self?.vm.requestPurchaseRecordsPS.onNext(false)
        }
        ///自动匹配当前刷新状态
        vm.autoSetRefreshHeaderStatus(header:refreshHeader, footer: refreshFooter).disposed(by:rx_disposeBag)
    }

    ///跳转到商品详情
    private func pushGoodDetail(model:GoodDetailModel){
        let vc=UIStoryboard(name:"GoodDetail", bundle:nil).instantiateViewController(withIdentifier:"GoodDetailVC") as! GoodDetailViewController
        vc.model=model
        vc.flag=2
        vc.isCarFlag=1
        self.navigationController?.pushViewController(vc, animated:true)
    }
}

extension PurchaseRecordsViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
