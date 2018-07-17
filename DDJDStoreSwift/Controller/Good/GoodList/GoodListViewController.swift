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

    ///接收分类3级id
    var goodsCategoryId:Int?

    ///接收配送商id
    var subSupplierId:Int?

    ///接收页面title名称
    var titleStr:String?

    private var vm:GoodListViewModel!

    private var addCarVM=AddCarViewModel()

    ///监听返回按钮
    override func navigationShouldPopOnBackButton() -> Bool {
        if flag == 1{///如果搜索页面进来  或者扫码页面进来 直接返回搜索页面 跳过扫码页面
            for vc:UIViewController in (self.navigationController?.viewControllers)!{
                if vc.isKind(of:SearchViewController.classForCoder()){
                    self.navigationController?.popToViewController(vc, animated:true)
                }
            }
        }
        return false
    }

    ///跳转到购物车按钮
    private var btnPushCar:UIButton!

    private lazy var menu:JNDropDownMenu={
        let _menu = JNDropDownMenu(origin: CGPoint(x:0,y:NAV_HEIGHT),height:44,width:SCREEN_WIDTH)
        _menu.datasource=self
        _menu.delegate=self
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
        self.title=titleStr
        setUI()
        bindViewModel()
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

        vm=GoodListViewModel(flag:flag,goodsCategoryId:goodsCategoryId, subSupplierId:subSupplierId, searchCondition:titleStr)
        ///创建数据源
        let dataSources=RxTableViewSectionedReloadDataSource<SectionModel<String,GoodDetailModel>>(configureCell:{ [weak self] (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"goodListId") as? GoodListTableViewCell ?? GoodListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"goodListId")
            if indexPath.row % 2 == 0{
                cell.contentView.backgroundColor=UIColor.white
            }else{
                cell.contentView.backgroundColor=UIColor.viewBgdColor()
            }
            ///跳转到商品详情
            cell.pushGoodDetailClosure={
                self?.pushGoodDetail(model:model)
            }
            ///加入购物车车
            cell.addCarClosure={
                self?.addCarVM.addCar(model:model, goodsCount:Int(cell.stepper.value),flag:2)
            }
            ///选择商品数量
            cell.selectedGoodCountClosure={
                self?.selectedGoodCount(model:model,indexPath:indexPath)
            }
            cell.updateCell(model:model)
            return cell
        },sectionIndexTitles:{ [weak self] _ in
            if self?.flag == 1{//如果是搜索不显示字母
                return nil
            }else{
                if self?.vm.goodArrModel.count > 0{ ///如果有数据显示按字母搜索
                    return self?.vm.indexSet
                }
            }
            return nil
        },sectionForSectionIndexTitle:{ [weak self] (_,title,index) in
            self?.vm.order="seachLetter"
            self?.vm.seachLetter=title
            self?.table.mj_header.beginRefreshing()
            return index
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
    /**
     弹出商品数量选择
     */
    func selectedGoodCount(model:GoodDetailModel,indexPath:IndexPath){
        let cell=self.table.cellForRow(at:indexPath) as? GoodListTableViewCell
        if cell == nil{
            return
        }
        let alertController = UIAlertController(title:nil, message:"输入您要购买的数量", preferredStyle: UIAlertControllerStyle.alert);
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.keyboardType=UIKeyboardType.numberPad
            if model.goodsStock == -1{//判断库存 等于-1 表示库存充足 由于UI大小最多显示3位数
                textField.placeholder = "请输入\(model.miniCount ?? 1)~999之间\(model.goodsBaseCount ?? 1)的倍数"
            }else{
                textField.placeholder = "请输入\(model.miniCount ?? 1)~\(model.goodsStock ?? 0)之间\(model.goodsBaseCount ?? 1)的倍数"
            }
            textField.tag=indexPath.row
            NotificationCenter.default.addObserver(self, selector: #selector(self.alertTextFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
        }
        //确定
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,handler:{ Void in
            let text=(alertController.textFields?.first)! as UITextField
            cell!.stepper.value=Double(text.text!)!
        })
        //取消
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        okAction.isEnabled = false
        self.present(alertController, animated: true, completion: nil)
    }
    //检测输入框的字符是否大于库存数量 是解锁确定按钮
    @objc func alertTextFieldDidChange(_ notification: Notification){
        let alertController = self.presentedViewController as! UIAlertController?
        if (alertController != nil) {
            let text = (alertController!.textFields?.first)! as UITextField
            ///获取对应model
            let model=self.vm.goodArrModel[text.tag]
            ///输入的最大输入数
            let goodsStock=model.goodsStock == -1 ? 999:(model.goodsStock ?? 0)
            let okAction = alertController!.actions.last! as UIAlertAction
            if text.text?.count > 0{
                ///当输入数量 是goodsBaseCount的倍数  并且小于等于库存数  大于等于最低起送数量才可以点击确定按钮
                okAction.isEnabled = Int(text.text!)! % (model.goodsBaseCount ?? 1) == 0 && Int(text.text!)! <= goodsStock && Int(text.text!)! >= (model.miniCount ?? 1)
            }else{
                okAction.isEnabled=false
            }
        }
    }
}
extension GoodListViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}
// MARK: -DOP协议
extension GoodListViewController:JNDropDownMenuDataSource,JNDropDownMenuDelegate{
    func numberOfColumns(in menu: JNDropDownMenu) -> NSInteger {
        return 3
    }

    func numberOfRows(in column: NSInteger, for forMenu: JNDropDownMenu) -> Int {
        switch column {
        case 0:
            return 3
        case 1:
            return 3
        default:
            return 1
        }
    }
    func titleForRow(at indexPath: JNIndexPath, for forMenu: JNDropDownMenu) -> String {
        if indexPath.column == 0{
            if indexPath.row == 0{
                return "销量"
            }else if indexPath.row == 1{
                return "销量从高到低"
            }else{
                return "销量从低到高"
            }
        }else if indexPath.column == 1{
            if indexPath.row == 0{
                return "价格"
            }else if indexPath.row == 1{
                return "价格从高到低"
            }else{
                return "价格从低到高"
            }
        }else{
            return "字母A-Z"
        }
    }

    func didSelectRow(at indexPath: JNIndexPath, for forMenu: JNDropDownMenu) {
        if indexPath.column == 0{
            if indexPath.row == 0{
                vm.order="count"
            }else if indexPath.row == 1{
                vm.order="count"
                vm.tag=2
            }else if indexPath.row == 2{
                vm.order="count"
                vm.tag=1
            }
        }else if indexPath.column == 1{
            if indexPath.row == 0{
                vm.order="price"
            }else if indexPath.row == 1{
                vm.order="price"
                vm.tag=2
            }else{
                vm.order="price"
                vm.tag=1
            }
        }else{
            vm.order="letter"
        }
        self.table.mj_header.beginRefreshing()
    }
}

