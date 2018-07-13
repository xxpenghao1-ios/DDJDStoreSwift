//
//  GoodListViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/13.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa
///商品列表
class GoodListViewController:BaseViewController{

    /// 接收传入的状态 1表示搜索 2表示查询3级分类商品列表  3查询1元区商品 4查询配送商商品列表
    var flag:Int=0

    private var vm:GoodListViewModel!

    private var addCarVM=AddCarViewModel()

    ///跳转到购物车按钮
    private var btnPushCar:UIButton!

    private lazy var menu:JNDropDownMenu={
        let _menu = JNDropDownMenu(origin: CGPoint(x:0,y: 64),height:44,width:SCREEN_WIDTH)
        return _menu
    }()

    private lazy var table:UITableView={
        let _table=UITableView()
        _table.tableFooterView=UIView()
        _table.backgroundColor=UIColor.clear
        _table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        _table.register(UINib(nibName:"GoodListTableViewCell", bundle:nil), forCellReuseIdentifier:"goodListId")
        _table.emptyDataSetSource=self
        _table.emptyDataSetDelegate=self
        return _table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()

    }
    ///设置UI
    private func setUI(){
        self.view.addSubview(menu)
        table.frame=CGRect.init(x:0,y:menu.frame.maxY,width:SCREEN_WIDTH, height:SCREEN_HEIGH-NAV_HEIGHT-44-BOTTOM_SAFETY_DISTANCE_HEIGHT)
        self.view.addSubview(table)
        //空视图提示文字
        self.emptyDataSetTextInfo="亲,暂时没有该类商品"
        ///跳转到购物车按钮
        btnPushCar=UIButton(frame: CGRect.init(x:0, y:0, width:25,height:25))
        btnPushCar.setImage(UIImage(named:"pushCar"), for: UIControlState.normal)
        //        btnPushCar.addTarget(self,action:#selector(pushCar), for: UIControlEvents.touchUpInside)
        let pushCarItem=UIBarButtonItem(customView:btnPushCar)
        pushCarItem.tintColor=UIColor.colorItem()
        self.navigationItem.rightBarButtonItem=pushCarItem
    }
}
extension GoodListViewController:Refreshable{

    private func bindViewModel(){

        vm=GoodListViewModel(flag:flag)
        ///创建数据源
        let dataSources=RxTableViewSectionedReloadDataSource<SectionModel<String,GoodDetailModel>>(configureCell:{ [weak self] (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"goodListId") as? GoodListTableViewCell ?? GoodListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"goodListId")
            if indexPath.row % 2 == 0{
                cell.contentView.backgroundColor=UIColor.white
            }else{
                cell.contentView.backgroundColor=UIColor.viewBgdColor()
            }
            cell.pushGoodDetailClosure={ model in
                self?.pushGoodDetail(model:model)
            }
            ///点击加入购物车
            cell.btnAddCar.rx.tap.asObservable().subscribe({ (_) in
                self?.addCarVM.addCar(model:model, goodsCount:Int(cell.stepper.value),flag:2)
            }).disposed(by:self?.rx_disposeBag ?? DisposeBag())
            cell.updateCell(model:model)
            return cell
        })

        ///查询购物车商品数量
        addCarVM.queryCarSumCountPS.onNext(true)

        ///更新购物车item按钮数量
        addCarVM.queryCarSumCountBR.asObservable().subscribe(onNext: { [weak self] (count) in
            self?.btnPushCar.showBadge(with: WBadgeStyle.number, value: count, animationType: WBadgeAnimType.none)
        }).disposed(by:rx_disposeBag)

        ///绑定数据源
        vm.goodArrModelBR.asObservable()
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
extension GoodListViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
