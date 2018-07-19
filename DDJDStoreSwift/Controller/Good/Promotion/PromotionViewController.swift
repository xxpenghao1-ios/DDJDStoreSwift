//
//  PromotionViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/13.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxDataSources
///促销商品区
class PromotionViewController:BaseViewController{
    
    ///接收查询状态  默认按销量
    var order="count"

    ///更新item购物车按钮数量
    var updateCarCountItemClosure:((_ count:Int) -> Void)?


    private var vm:PromotionGoodViewModel!

    ///加入购物车vm
    private var addCarVM:AddCarGoodCountViewModel?

    ///倒计时
    private var timer:Timer?

    ///是否是第一次加载页面  true是
    private var viewFlag=true


    ///table
    private lazy var table:UITableView={
        let _table=UITableView()
        _table.tableFooterView=UIView(frame: CGRect.zero)
        _table.backgroundColor=UIColor.clear
        _table.separatorInset = UIEdgeInsetsMake(0,0,0,0)
        _table.register(UINib(nibName:"PromotionGoodTableViewCell", bundle:nil), forCellReuseIdentifier:"promotionGoodId")
        _table.emptyDataSetDelegate=self
        _table.emptyDataSetSource=self
        _table.rowHeight = UITableViewAutomaticDimension;
        // 设置tableView的估算高度
        _table.estimatedRowHeight = 120;
        return _table
    }()

    ///跳转到购物车按钮
    private var btnPushCar:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()

    }
    ///设置UI
    private func setUI(){
        table.frame=CGRect.init(x:0,y:2, width:SCREEN_WIDTH, height:SCREEN_HEIGH-NAV_HEIGHT-44-BOTTOM_SAFETY_DISTANCE_HEIGHT-2)
        self.view.addSubview(table)
        //空视图提示文字
        self.emptyDataSetTextInfo="亲,暂时没有查询到促销活动"

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !viewFlag {
            table.mj_header.beginRefreshing()
        }
        viewFlag=false
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ///页面退出清除定时器
        removeTimer()
    }
}
///绑定vm
extension PromotionViewController:Refreshable{

    private func bindViewModel(){

        vm=PromotionGoodViewModel(order:order)
        addCarVM=AddCarGoodCountViewModel()
        ///创建数据源
        let dataSources=RxTableViewSectionedReloadDataSource<SectionModel<String,GoodDetailModel>>(configureCell:{ [weak self] (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"promotionGoodId") as? PromotionGoodTableViewCell ?? PromotionGoodTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"promotionGoodId")
            cell.index=indexPath.row
            cell.updateCell(model:model)
            ///加入购物车
            cell.addCarClosure={
                self?.addCarVM?.addCar(model:model,goodsCount:1, flag:3)
            }
            cell.pushGoodDetailClosure={
                self?.pushGoodDetail(model:model)
            }
            return cell
        })

        ///查询购物车商品数量
        addCarVM?.queryCarSumCountPS.onNext(true)

        ///更新购物车item按钮数量
        addCarVM?.queryCarSumCountBR.asObservable().subscribe(onNext: { [weak self] (count) in
            self?.updateCarCountItemClosure?(count)
        }).disposed(by:rx_disposeBag)

        ///绑定数据源
        vm.promotionArrModelBR.asObservable()
            .map({ [weak self] (dic) -> [SectionModel<String,GoodDetailModel>] in
                let emptyDataType=dic.keys.first ?? .noData
                self?.emptyDataType = emptyDataType
                self?.createTimer() ///加载定时器
                return dic[emptyDataType] ?? []
            }).bind(to:table.rx.items(dataSource:dataSources)).disposed(by:rx_disposeBag)

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
extension PromotionViewController{

    ///跳转到商品详情
    private func pushGoodDetail(model:GoodDetailModel){
        let vc=UIStoryboard(name:"GoodDetail", bundle:nil).instantiateViewController(withIdentifier:"GoodDetailVC") as! GoodDetailViewController
        vc.model=model
        vc.flag=3
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
///倒计时
extension PromotionViewController{
    /**
     创建定时器
     */
    func createTimer(){
        if timer == nil{
            timer=Timer(timeInterval:1, target:self, selector:#selector(timerEvent), userInfo:nil, repeats:true)
            //避免tableView滑动的时候卡死
            RunLoop.current.add(timer!,forMode:RunLoopMode.commonModes)
        }
    }
    /**
     定时器每次执行
     */
    @objc func timerEvent(){
        for model in vm.promotionArrModel{//所有数据源每一秒减一
            let times=model.promotionEndTime?.components(separatedBy:".")
            if times != nil && Int(times![0]) > 0{///特价时间不为空 或者大于0
                var time=Int(times![0])
                time!-=1
                model.promotionEndTime=time!.description
            }else{
                model.promotionEndTime="0"
            }

        }
        //获取屏幕内可见的cell
        let cells=table.visibleCells
        for i in 0..<cells.count{
            let cell=cells[i] as? PromotionGoodTableViewCell
            if cell != nil{
                let model=vm.promotionArrModel[cell!.index!]
                let time=Int(model.promotionEndTime!)
                if time > 0 {///如果结束时间大于0 显示倒计时
                    cell!.lblEndTime.text=lessSecondToDay(time!)
                }else{//活动结束
                    cell!.lblEndTime.text="活动已结束"
                    cell!.showGoodStateImgView(name:"to_sell_end")
                }
            }

        }
    }
    /**
     关闭定时器
     */
    func removeTimer(){
        timer?.invalidate()
        timer=nil
    }
}

