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

    ///更新item购物车按钮数量
    var updateCarCountItemClosure:((_ count:Int) -> Void)?

    private var vm:SpecialGoodViewModel!

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
        _table.register(UINib(nibName:"SpecialGoodTableViewCell", bundle:nil), forCellReuseIdentifier:"specialGoodId")
        _table.emptyDataSetDelegate=self
        _table.emptyDataSetSource=self
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
        self.emptyDataSetTextInfo="亲,暂时没有查询到特价活动"
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///查询购物车商品数量
        addCarVM?.queryCarSumCountPS.onNext(true)
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
extension SpecialViewController:Refreshable{

    private func bindViewModel(){

        vm=SpecialGoodViewModel(order:order)
        addCarVM=AddCarGoodCountViewModel()
        ///创建数据源
        let dataSources=RxTableViewSectionedReloadDataSource<SectionModel<String,GoodDetailModel>>(configureCell:{ [weak self] (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"specialGoodId") as? SpecialGoodTableViewCell ?? SpecialGoodTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"specialGoodId")
            cell.index=indexPath.row
            cell.updateCell(model:model)
            ///加入购物车车
            cell.addCarClosure={
                ///特价商品区id不一样 重新赋值
                model.goodsbasicinfoId=model.goodsId
                self?.addCarVM?.addCar(model:model, goodsCount:1, flag:1)
            }
            cell.pushGoodDetailClosure={
                self?.pushGoodDetail(model:model)
            }
            return cell
        })



        ///更新购物车item按钮数量
        addCarVM?.queryCarSumCountBR.asObservable().subscribe(onNext: { [weak self] (count) in
            self?.updateCarCountItemClosure?(count)
        }).disposed(by:rx_disposeBag)

        ///绑定数据源
        vm.specialArrModelBR.asObservable()
            .map({ [weak self] (dic) -> [SectionModel<String,GoodDetailModel>] in
            let emptyDataType=dic.keys.first ?? .noData
            self?.emptyDataType = emptyDataType
            self?.createTimer() ///加载定时器
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


}
extension SpecialViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    ///跳转到商品详情
    private func pushGoodDetail(model:GoodDetailModel){
        let vc=UIStoryboard(name:"GoodDetail", bundle:nil).instantiateViewController(withIdentifier:"GoodDetailVC") as! GoodDetailViewController
        model.goodsbasicinfoId=model.goodsId
        vc.model=model
        vc.flag=1
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
///倒计时
extension SpecialViewController{
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
        for model in vm.specialArrModel{//所有数据源每一秒减一
            let times=model.endTime?.components(separatedBy:".")
            if times != nil && Int(times![0]) > 0{///特价时间不为空 或者大于0
                var time=Int(times![0])
                time!-=1
                model.endTime=time!.description
            }else{
                model.endTime="0"
            }

        }
        //获取屏幕内可见的cell
        let cells=table.visibleCells
        for i in 0..<cells.count{
            let cell=cells[i] as? SpecialGoodTableViewCell
            if cell != nil{
                let model=vm.specialArrModel[cell!.index!]
                let time=Int(model.endTime!)
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
