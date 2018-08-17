//
//  CollectionGoodViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/25.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
///我的收藏商品
class CollectionGoodViewController:BaseViewController{
    
    private var table:UITableView!
    ///跳转到购物车按钮
    private var btnPushCar:UIButton?

    private var vm=CollectionGoodViewModel()

    private var addCarVM=AddCarGoodCountViewModel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.requestCollectionGoodPS.onNext(true)
        ///查询购物车商品数量
        addCarVM.queryCarSumCountPS.onNext(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="我的收藏"
        table=UITableView(frame:self.view.bounds, style: UITableViewStyle.plain)
        table.tableFooterView=UIView.init(frame: CGRect.zero)
        table.emptyDataSetSource=self
        table.emptyDataSetDelegate=self
        table.backgroundColor=UIColor.clear
        table.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        table.register(UINib(nibName:"GoodListTableViewCell", bundle:nil), forCellReuseIdentifier:"goodListId")
        self.view.addSubview(table)
        self.emptyDataSetTextInfo="暂无收藏"
        ///跳转到购物车按钮
        btnPushCar=UIButton(frame: CGRect.init(x:0, y:0, width:25,height:25))
        btnPushCar!.setImage(UIImage(named:"pushCar"), for: UIControlState.normal)
        ///点击跳转购物车
        btnPushCar!.rx.tap.asDriver(onErrorJustReturn: ()).drive(onNext: { [weak self] (_) in
            let vc=UIStoryboard.init(name:"Car", bundle:nil).instantiateViewController(withIdentifier:"CarVC") as! CarViewController
            self?.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by:rx_disposeBag)
        let pushCarItem=UIBarButtonItem(customView:btnPushCar!)
        pushCarItem.tintColor=UIColor.colorItem()
        self.navigationItem.rightBarButtonItem=pushCarItem
        bindViewModel()
    }
}
extension CollectionGoodViewController:Refreshable{

    private func bindViewModel(){

        ///创建数据源
        let dataSources=RxTableViewSectionedReloadDataSource<SectionModel<String,GoodDetailModel>>(configureCell:{ [weak self] (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"goodListId") as? GoodListTableViewCell ?? GoodListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"goodListId")
            if indexPath.row % 2 == 0{
                cell.contentView.backgroundColor=UIColor.white
            }else{
                cell.contentView.backgroundColor=UIColor.viewBgdColor()
            }
            model.goodsbasicinfoId=model.collectionGoodId
            model.supplierId=model.collectionSupplierId
            model.subSupplier=model.collectionSubSupplierId
            ///跳转到商品详情
            cell.pushGoodDetailClosure={
                self?.pushGoodDetail(model:model)
            }
            ///加入购物车车
            cell.addCarClosure={ (goodCount) in
                self?.addCarVM.addCar(model:model, goodsCount:goodCount,flag:2)
            }
            ///选择商品数量
            cell.selectedGoodCountClosure={
                self?.selectedGoodCount(model:model,indexPath:indexPath)
            }
            cell.updateCell(model:model)
            return cell
        })

        ///更新购物车item按钮数量
        addCarVM.queryCarSumCountBR.asDriver(onErrorJustReturn:0).drive(onNext: { [weak self] (count) in
            self?.btnPushCar?.showBadge(with: WBadgeStyle.number, value: count, animationType: WBadgeAnimType.none)
        }).disposed(by:rx_disposeBag)

        ///绑定数据源
        vm.collectionGoodBR.asObservable()
            .map({ [weak self] (dic) -> [SectionModel<String,GoodDetailModel>] in
                let emptyDataType=dic.keys.first ?? .noData
                self?.emptyDataType = emptyDataType
                return dic[emptyDataType] ?? []
            }).bind(to:table.rx.items(dataSource:dataSources)).disposed(by:rx_disposeBag)

        table.rx.setDelegate(self).disposed(by:rx_disposeBag)

        ///刷新
        let refreshHeader=initRefreshHeader(table) { [weak self] in
            self?.vm.requestCollectionGoodPS.onNext(true)
        }
        ///加载更多
        let refreshFooter=initRefreshFooter(table) { [weak self] in
            self?.vm.requestCollectionGoodPS.onNext(false)
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
    /**
     弹出商品数量选择
     */
    func selectedGoodCount(model:GoodDetailModel,indexPath:IndexPath){
        let cell=self.table.cellForRow(at:indexPath) as? GoodListTableViewCell
        if cell == nil{
            return
        }
        var txt=UITextField()
        let alertController = UIAlertController(title:nil, message:"输入您要购买的数量", preferredStyle: UIAlertControllerStyle.alert);
        alertController.addTextField {
           [weak self] (textField: UITextField!) -> Void in
            txt=textField
            txt.keyboardType=UIKeyboardType.numberPad
            if model.goodsStock == -1{//判断库存 等于-1 表示库存充足 由于UI大小最多显示3位数
                txt.placeholder = "请输入\(model.miniCount ?? 1)~999之间\(model.goodsBaseCount ?? 1)的倍数"
            }else{
                txt.placeholder = "请输入\(model.miniCount ?? 1)~\(model.goodsStock ?? 0)之间\(model.goodsBaseCount ?? 1)的倍数"
            }
            txt.tag=indexPath.row
            self?.txtNotification(textField: txt)
        }

        //确定
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,handler:{ Void in
            cell!.stepper.value=Double(txt.text!)!
        })
        //取消
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        okAction.isEnabled = false
        self.present(alertController, animated: true, completion: nil)
    }
    ///输入框通知
    private func txtNotification(textField:UITextField){
        NotificationCenter.default.addObserver(self, selector: #selector(self.alertTextFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
    }
    //检测输入框的字符是否大于库存数量 是解锁确定按钮
    @objc func alertTextFieldDidChange(_ notification: Notification){
        let alertController = self.presentedViewController as! UIAlertController?
        if (alertController != nil) {
            let text = (alertController!.textFields?.first)! as UITextField
            ///获取对应model
            let model=self.vm.collectionGoodArr[text.tag]
            ///输入的最大输入数
            let goodsStock=model.goodsStock == -1 ? 999:(model.goodsStock ?? 0)
            let okAction = alertController!.actions.last
            if text.text != nil && text.text!.count > 0{
                ///当输入数量 是goodsBaseCount的倍数  并且小于等于库存数  大于等于最低起送数量才可以点击确定按钮
                okAction?.isEnabled = Int(text.text!)! % (model.goodsBaseCount ?? 1) == 0 && Int(text.text!)! <= goodsStock && Int(text.text!)! >= (model.miniCount ?? 1)
            }else{
                okAction?.isEnabled=false
            }
        }
    }
}

extension CollectionGoodViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
