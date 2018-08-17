//
//  CarViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/17.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa
///购物车
class CarViewController:BaseViewController{

    private var vm=CarViewModel()

    ///监听购物车商品变化
    private var addCarGoodCountVM=AddCarGoodCountViewModel()

    @IBOutlet weak var table:UITableView!
    ///结算
    @IBOutlet weak var btnSettlement:UIButton!
    ///全选
    @IBOutlet weak var btnCheckAll:UIButton!
    ///总价
    @IBOutlet weak var lblSumPrice:UILabel!
    ///底部view
    @IBOutlet weak var bottomView:UIView!

    ///清空购物车按钮
    private var rightBar:UIBarButtonItem!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///发送网络请求
        vm.requestNewDataCommond.onNext(true)
        ///每次进入页面查询购物车商品数量
        addCarGoodCountVM.queryCarSumCountPS.onNext(true)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ///告诉服务器更新购物车商品数量
        vm.updateCarGoodListPS.onNext(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="购物车"
        setUI()
        bindViewModel()
    }

    private func setUI(){

        ///默认隐藏底部view
        bottomView.isHidden=true
        ///设置圆角
        btnSettlement.layer.cornerRadius=35/2
        ///设置全部选择按钮
        btnCheckAll.setImage(UIImage.init(named:"car_selected"), for: UIControlState.selected)
        btnCheckAll.setImage(UIImage.init(named:"car_uncheck"), for: UIControlState.normal)
        ///默认选中
        btnCheckAll.isSelected=true

        table.register(UINib(nibName:"CarTableViewCell", bundle:nil), forCellReuseIdentifier:"carId")
        table.backgroundColor=UIColor.clear
        table.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        table.dataSource=self
        table.delegate=self
        table.emptyDataSetSource=self
        table.emptyDataSetDelegate=self
        table.estimatedSectionFooterHeight=0
        table.estimatedSectionHeaderHeight=0
        table.estimatedRowHeight=0
        table.tableHeaderView=UIView(frame:CGRect.init(x:0,y:0,width:0, height:6))
        table.tableFooterView=UIView(frame:CGRect.zero)
        self.emptyDataSetTextInfo="购物车空空如也"
        self.emptyDataType = .noData
        ///空视图不显示
        self.emptyDataIsHidden=false

        ///清空购物车按钮
        rightBar=UIBarButtonItem(title:"清空", style: UIBarButtonItemStyle.done,target:self, action:#selector(deleteAllCar))
    }


}
///页面操作
extension CarViewController{
    ///选择/取消 购物车每组
    @objc private func selectedSection(sender:UIButton){
        if sender.isSelected{
            sender.isSelected=false
        }else{
            sender.isSelected=true
        }
        self.vm.sectionIsSelected(section:sender.tag, isSelected: sender.isSelected)
    }
    ///跳转到商品列表 配送商城
    @objc private func pushGoodList(sender:UIButton){
        let carModel=self.vm.arr[sender.tag]
        self.pushSupplierGoodListVC(carModel:carModel)
    }
    ///跳转到配送商城
    private func pushSupplierGoodListVC(carModel:CarModel){
        let vc=GoodListViewController()
        vc.flag=4
        vc.titleStr=carModel.supplierName
        vc.subSupplierId=carModel.supplierId
        vc.isCarFlag=1
        vc.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated:true)
    }
    ///清空购物车
    @objc private func deleteAllCar(){
        UIAlertController.showAlertYesNo(self, title:"温馨提示",message: "您确定要清空购物车吗?", cancelButtonTitle:"取消",okButtonTitle:"确定") { [weak self] (_) in
            self?.vm.deleteShoppingCar(allDelete:true)
        }
    }
}
extension CarViewController{

    private func bindViewModel(){
        ///刷新数据
        vm.arrPS.asDriver(onErrorJustReturn:false).drive(onNext: { [weak self] (_) in
            if self?.vm.arr.count > 0{//如果有数据显示底部view 显示清空按钮
                self?.bottomView.isHidden=false
                self?.navigationItem.rightBarButtonItem=self?.rightBar
            }else{
                self?.bottomView.isHidden=true
                self?.navigationItem.rightBarButtonItem=nil
            }
            ///显示空视图
            self?.emptyDataIsHidden=true
            self?.table.reloadData()
        }).disposed(by:rx_disposeBag)

        ///更新商品总价
        vm.sumPriceBR.asDriver(onErrorJustReturn:"0").drive(onNext: { [weak self] (sumPrice) in
            self?.lblSumPrice.text="￥\(sumPrice)"
        }).disposed(by:rx_disposeBag)

        ///全选按钮是否选中 true选中
        vm.updateAllSelectedStatePS.asDriver(onErrorJustReturn:true).drive(onNext: { [weak self] (isSelected) in
            self?.btnCheckAll.isSelected=isSelected
        }).disposed(by:rx_disposeBag)

        ///全部选择/或者全部取消
        btnCheckAll.rx.tap.asDriver(onErrorJustReturn:()).drive(onNext: { [weak self] (_) in
            if self?.btnCheckAll.isSelected == true{
                self?.btnCheckAll.isSelected=false
            }else{
                self?.btnCheckAll.isSelected=true
            }
            self?.vm.allSelected(isSelected:self?.btnCheckAll.isSelected)
        }).disposed(by:rx_disposeBag)

        ///查询购物车商品数量设置角标
        addCarGoodCountVM.queryCarSumCountBR.asDriver(onErrorJustReturn:0).drive(onNext: { [weak self] (count) in
            if count > 0{
                self?.tabBarItem.badgeValue=count.description
            }else{
                self?.tabBarItem.badgeValue=nil
            }
            ///tab页面更新购物车角标数据
            NotificationCenter.default.post(name:NSNotification.Name(rawValue:"postBadgeValue"), object: 4, userInfo: ["carCount":count])
        }).disposed(by:rx_disposeBag)

        ///去结算
        btnSettlement.rx.tap.asDriver(onErrorJustReturn:()).drive(onNext: { [weak self] (_) in
            self?.pushPlaceOrder()
        }).disposed(by:rx_disposeBag)
    }
    ///跳转到商品详情
    private func pushGoodDetail(model:GoodDetailModel){
        let vc=UIStoryboard(name:"GoodDetail", bundle:nil).instantiateViewController(withIdentifier:"GoodDetailVC") as! GoodDetailViewController
        vc.model=model
        vc.flag=model.flag ?? 2
        vc.isCarFlag=1
        vc.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated:true)
    }
    ///跳转到下单页面
    private func pushPlaceOrder(){

        let goodArr=self.vm.settlementGoodArr()

        if goodArr.count == 0{
            PHProgressHUD.showInfo("请选择要下单的商品")
            return
        }else{
            ///获取每组小计小于最低起送价的 组信息
            let noCarArr = vm.arr.filter({ (carModel)  in
                
                let sumPrice=Double(carModel.sumPrice ?? "0")!
                let lowestMoney=Double(carModel.lowestMoney ?? "0")!

                ///获取选中商品
                let goodArrSelected=carModel.listGoods!.filter({ (goodModel) in
                    ///返回 选中的商品 并且库存不等于0的商品
                    return goodModel.isSelected == 1 && goodModel.goodsStock != 0
                })
                ///返回 每组选中的商品大于0 总价小于最低起送价
                return goodArrSelected.count > 0 && sumPrice < lowestMoney

            })
            if noCarArr.count == 0{///如果没有跳转到下单页面
                let vc=UIStoryboard.init(name:"PlaceOrder", bundle:nil).instantiateViewController(withIdentifier:"PlaceOrderVC") as! PlaceOrderViewController
                vc.goodArr=goodArr
                vc.sumPirce=vm.sumPriceBR.value
                vc.hidesBottomBarWhenPushed=true
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                ///每次只拿第一个不满足条件的组
                let carModel=noCarArr[0]
                let sumPrice=Double(carModel.sumPrice ?? "0")!
                let lowestMoney=Double(carModel.lowestMoney ?? "0")!
                ///如果每组商品小计 小于最低起送价 不能下单 给出提示
                UIAlertController.showAlertYesNo(self, title:"点单即到", message:"\(carModel.supplierName ?? "")配送最低起送额是\(lowestMoney)元,您还需要购买\(lowestMoney - sumPrice)元才能结算", cancelButtonTitle:"知道了", okButtonTitle:"去凑单", okHandler: { [weak self]  Void in
                    self?.pushSupplierGoodListVC(carModel:carModel)
                })
            }
        }
    }
}

extension CarViewController:UITableViewDelegate,UITableViewDataSource{


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=table.dequeueReusableCell(withIdentifier:"carId") as? CarTableViewCell ?? CarTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"carId")
        if vm.arr.count > 0{
            let model=vm.arr[indexPath.section].listGoods![indexPath.row]
            cell.updateCell(model:model)
            ///跳转到商品详情
            cell.pushGoodDetailClosure={ [weak self] in
                self?.pushGoodDetail(model:model)
            }
            ///更新商品数量
            cell.updateCarNumberClosure={ [weak self] (carNumber) in
                self?.vm.arr[indexPath.section].listGoods![indexPath.row].carNumber=carNumber
                ///重新计算商品总价 每组商品单价
                self?.vm.setSumPriceArrModel(arr:self?.vm.arr ?? [])

            }
            ///更新单个商品选中状态
            cell.updateCarGoodSelectedStateClosure={ [weak self] (isSelected) in
                ///更新单个商品选中状态
                self?.vm.arr[indexPath.section].listGoods![indexPath.row].isSelected=isSelected == true ? 1:2
                ///重新计算商品总价 每组商品单价
                self?.vm.setSumPriceArrModel(arr:self?.vm.arr ?? [])

            }
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.arr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.arr[section].listGoods!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if vm.arr.count == 0{
            return nil
        }else{
            return setCellHeaderView(section:section)
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if vm.arr.count == 0{
            return nil
        }else{
            return setCellFooterView(section:section)
        }
    }
    //返回头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    //返回尾部高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 56
    }
    //删除操作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{
            self.vm.deleteShoppingCar(index:indexPath)
        }
    }
    //把delete 该成中文
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "删除"
    }
    ///头部
    private func setCellHeaderView(section:Int) -> UIView{
        let view=UIView.init(frame: CGRect.init(x:0, y:0, width:SCREEN_WIDTH, height:50))
        let carModel=vm.arr[section]
        ///设置背景色
        view.backgroundColor=UIColor.white

        //给选择图片加上按钮实现点击切换
        var btnSelectImg=view.viewWithTag(section) as? UIButton
        if btnSelectImg == nil{
            btnSelectImg=UIButton(frame:CGRect(x:10,y:15,width:20,height: 20));
            //选择图片
            let selectImg=UIImage(named:"car_uncheck");
            let selectImgSelected=UIImage(named:"car_selected");
            btnSelectImg?.setImage(selectImg, for:UIControlState.normal)
            btnSelectImg?.setImage(selectImgSelected, for:.selected);
            btnSelectImg?.tag=section
            btnSelectImg?.addTarget(self, action:#selector(selectedSection), for: UIControlEvents.touchUpInside)
            view.addSubview(btnSelectImg!);
        }
        ///供应商名称
        var lblSupplierName=view.viewWithTag(22) as? UILabel
        if lblSupplierName == nil{
         lblSupplierName=UILabel(frame:CGRect(x:btnSelectImg!.frame.maxX+5,y:15,width:200,height:20))
            lblSupplierName!.font=UIFont.systemFont(ofSize:14)
            lblSupplierName!.tag=22
            view.addSubview(lblSupplierName!)
        }

        ///起送金额
        var lblLowestMoney=view.viewWithTag(33) as? UILabel
        if lblLowestMoney == nil{
            lblLowestMoney=UILabel.buildLabel(textColor:UIColor.color333(), font:14, textAlignment:.right)
            lblLowestMoney!.frame=CGRect.init(x:SCREEN_WIDTH-160, y:15, width:150,height: 20)
            lblLowestMoney!.tag=33
            view.addSubview(lblLowestMoney!)
        }
        ///给各个控件赋值
        lblSupplierName!.text=carModel.supplierName
        lblLowestMoney!.text="满\(carModel.lowestMoney  ?? "0")元起送"
        ///设置分组是否选中
        if carModel.isSelected == 1{//如果等于1选中
            btnSelectImg!.isSelected=true
        }else{
            btnSelectImg!.isSelected=false
        }
        return view
    }
    ///尾部
    private func setCellFooterView(section:Int) -> UIView{
        let view=UIView.init(frame: CGRect.init(x:0, y:0, width:SCREEN_WIDTH, height:56))
        let carModel=vm.arr[section]

        view.backgroundColor=UIColor.white

        ///边线
        var broderView=view.viewWithTag(111)
        if broderView == nil{
            broderView=UIView(frame: CGRect.init(x:0, y:50, width:SCREEN_WIDTH,height:6))
            broderView!.tag=111
            broderView!.backgroundColor=UIColor.viewBgdColor()
            view.addSubview(broderView!)
        }

        ///去凑单按钮
        var btn=view.viewWithTag(section) as? UIButton
        if btn == nil{
            btn=UIButton.buildBtn(text:"去凑单", textColor:UIColor.white, font:14, backgroundColor:UIColor.applicationMainColor(), cornerRadius:5)
            btn!.tag=section
            ///默认隐藏
            btn!.isHidden=true
            btn!.addTarget(self,action:#selector(pushGoodList), for: UIControlEvents.touchUpInside)

            view.addSubview(btn!)
        }

        ///每组商品提示信息
        var lblName=view.viewWithTag(333) as? UILabel
        if lblName == nil{
            lblName=UILabel.buildLabel(textColor:UIColor.priceColor(), font:14, textAlignment:.left)
            lblName?.tag=333
            view.addSubview(lblName!)
        }

        ///小计
        var lblTotal=view.viewWithTag(444) as? UILabel
        if lblTotal == nil{
            lblTotal=UILabel.buildLabel(textColor:UIColor.priceColor(), font:14, textAlignment:.right)
            lblTotal?.tag=444
            view.addSubview(lblTotal!)
        }

        if Double(carModel.sumPrice!) < Double(carModel.lowestMoney ?? "0"){//如果小计小于最低起送额
            lblName!.text="还需\(PriceComputationsUtil.decimalNumberWithString(multiplierValue:carModel.lowestMoney ?? "0", multiplicandValue:carModel.sumPrice!,type:.subtraction, position:2))元起送"
            btn!.isHidden=false
        }else{
            lblName!.text="您已达到配送标准"
            btn!.isHidden=true
        }

        let size=lblName!.text!.textSizeWithFont(font: UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 300,height: 20))

        lblName!.frame=CGRect(x: 15,y:15,width: size.width,height: 20)

        btn!.frame=CGRect(x:lblName!.frame.maxX+5,y:10,width: 60,height: 30)

        lblTotal!.frame=CGRect(x:lblName!.frame.maxX+65,y:10,width: SCREEN_WIDTH-lblName!.frame.maxX-10-65,height: 30)

        lblTotal!.text="小计:\(carModel.sumPrice!)"

        return view

    }

}
