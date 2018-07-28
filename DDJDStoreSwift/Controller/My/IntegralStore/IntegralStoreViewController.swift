//
//  IntegralStoreViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
///积分商城
class IntegralStoreViewController:BaseViewController{

    ///积分
    @IBOutlet weak var lblIntegral:UILabel!

    ///查看明细
    @IBOutlet weak var btnCheckTheDetails:UIButton!

    ///说明按钮
    @IBOutlet weak var btnExplain:UIButton!

    ///商品集合
    @IBOutlet weak var collection:UICollectionView!

    private var vm=IntegralViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="点单商城"
        setUI()
        bindViewModel()
    }
    
    ///设置ui
    private func setUI(){

        let rightItem=UIBarButtonItem(title:"兑换记录", style: .done, target:self, action:#selector(pushExchangeRecordVC))
        rightItem.tintColor=UIColor.color333()
        self.navigationItem.rightBarButtonItem=rightItem

        ///设置查看明细按钮圆角
        btnCheckTheDetails.layer.cornerRadius=15
        btnCheckTheDetails.layer.borderColor=UIColor.white.cgColor
        btnCheckTheDetails.layer.borderWidth=1

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset=UIEdgeInsets.init(top:5, left:10,bottom:15, right:10)
        //计算每列的宽度，需要在布局之前算好
        let columnWidth = (SCREEN_WIDTH - 30)/2
        flowLayout.itemSize = CGSize(width:columnWidth,height:columnWidth+85)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical//设置垂直显
        flowLayout.minimumLineSpacing=10
        flowLayout.minimumInteritemSpacing=10

        collection.collectionViewLayout=flowLayout
        collection.emptyDataSetSource=self
        collection.emptyDataSetDelegate=self
        collection.register(UINib(nibName:"IntegralGoodCollectionViewCell", bundle:nil), forCellWithReuseIdentifier:"integralGoodId")

        self.emptyDataSetTextInfo="暂无积分商品"

    }

    ///跳转到兑换记录页面
    @objc private func pushExchangeRecordVC(){
        let vc=ExchangeRecordViewController()
        self.navigationController?.pushViewController(vc, animated:true)
    }
}

extension IntegralStoreViewController:Refreshable{

    private func bindViewModel(){

        //查询积分商品
        vm.requestIntegralGoodListPS.onNext(true)

        //查询积分
        vm.requestSumIntegralPS.onNext(true)

        //获取积分
        vm.sumIntegralBR.subscribe(onNext: { [weak self] (integral) in
            self?.lblIntegral.text=integral.description
        }).disposed(by:rx_disposeBag)

        ///点击查看积分说明
        btnExplain.rx.tap.asObservable().throttle(1, scheduler:MainScheduler.instance) .subscribe(onNext: { [weak self] (_) in
            self?.showIntegralExplain(str:self?.vm.integralExplainBR.value)
        }).disposed(by:rx_disposeBag)

        ///点击跳转到积分记录页面
        btnCheckTheDetails.rx.tap.asObservable().throttle(1, scheduler:MainScheduler.instance) .subscribe(onNext: { [weak self] (_) in
            let vc=IntegralRecordViewController()
            self?.navigationController?.pushViewController(vc, animated:true)
        }).disposed(by:rx_disposeBag)
        
        ///积分兑换成功
        vm.integralExchangeSuccessPS.subscribe(onNext: { [weak self] (model) in

            let m=self?.vm.integralGoodListArr.first{ (m) in
                return m.integralMallId ?? 0 == model.integralMallId ?? 0
            }
            if m != nil{
                m!.goodsSurplusCount!-=1
            }
            self?.vm.integralGoodListBR.accept([.noData : [SectionModel.init(model:"", items:self?.vm.integralGoodListArr ?? [])]])
            self?.showExchangeIntegralGoodSuccessS(goodName:model.goodsName ?? "")

        }).disposed(by:rx_disposeBag)
        //创建分类数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource
            <SectionModel<String,IntegralGoodModel>>(
                configureCell: {  [weak self] (dataSource, collectionView, indexPath, model)  in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"integralGoodId",for:indexPath) as! IntegralGoodCollectionViewCell
                    cell.updateCell(model:model)
                    ///积分兑换
                    cell.exchangeIntegralGoodClosure={ 
                        self?.vm.integralExchangePS.onNext(model)
                    }
                    return cell
            })

        ///绑定数据
        vm.integralGoodListBR.asObservable().map({ [weak self] (dic) in
            let emptyDataType=dic.keys.first ?? .noData
            self?.emptyDataType = emptyDataType
            return dic[emptyDataType] ?? []
        }).bind(to:collection.rx.items(dataSource: dataSource)).disposed(by:rx_disposeBag)

        ///刷新
        let refreshHeader=initRefreshHeader(collection) { [weak self] in
            self?.vm.requestIntegralGoodListPS.onNext(true)

        }
        ///加载更多
        let refreshFooter=initRefreshFooter(collection) { [weak self] in
            self?.vm.requestIntegralGoodListPS.onNext(false)
        }
        ///自动匹配当前刷新状态
        vm.autoSetRefreshHeaderStatus(header:refreshHeader, footer: refreshFooter).disposed(by:rx_disposeBag)
    }

    ///弹出积分说明
    private func showIntegralExplain(str:String?){
        UIAlertController.showAlertYes(self, title:"点单即到", message:str, okButtonTitle:"知道了")
    }

    ///弹出兑换成功说明
    private func showExchangeIntegralGoodSuccessS(goodName:String){
        UIAlertController.showAlertYes(self, title:"点单即到", message:"兑换\(goodName)成功,商品将在您下次购买此配送商的商品下单成功后，自动加入订单中", okButtonTitle:"确定")
    }
}
