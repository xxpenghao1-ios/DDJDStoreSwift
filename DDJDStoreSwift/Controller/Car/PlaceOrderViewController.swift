//
//  PlaceOrderViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/20.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
///下单页面
class PlaceOrderViewController:BaseViewController{
    ///接收购物车传入商品集合
    var goodArr=[GoodDetailModel]()
    ///接收购物车商品总价
    var sumPirce:String="0"
    //收货人姓名
    @IBOutlet weak var lblShippName: UILabel!
    //电话号码
    @IBOutlet weak var lblTel: UILabel!
    //收货地址
    @IBOutlet weak var lblAddress: UILabel!
    //修改收货地址View
    @IBOutlet weak var updateAddresView: UIView!
    //table
    @IBOutlet weak var table: UITableView!
    //总金额
    @IBOutlet weak var lblSumPrice: UILabel!
    //商品总数量
    @IBOutlet weak var lblSumCount: UILabel!
    //提交订单
    @IBOutlet weak var btnSubmit: UIButton!


    ///买家附言输入框
    private lazy var txtBuyPS:UITextField={
        let _txt=UITextField.buildTxt(font:14, placeholder:"选填,请对本次交易留言", tintColor: UIColor.color666(),keyboardType: UIKeyboardType.default)
        _txt.textColor=UIColor.color666()
        _txt.tag=555
        return _txt
    }()
    
    ///获取收货地址信息
    private var addressVM=AddressViewModel()

    private var vm=PlaceOrderViewModel()


    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///获取收货地址信息 每次进入页面获取收货地址信息
        addressVM.requestNewDataCommond.onNext(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="确认订单"
        setUI()
        bindViewModel()
    }

    private func setUI(){

        table.dataSource=self
        table.delegate=self
        table.tableFooterView=UIView.init(frame:CGRect.init(x:0, y: 0, width: 0, height:6))
        table.backgroundColor=UIColor.clear
        table.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        table.register(UINib(nibName:"PlaceOrderTableViewCell", bundle: nil), forCellReuseIdentifier: "placeOrderId")

        ///修改收货地址
        updateAddresView.isUserInteractionEnabled=true
        updateAddresView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(pushAddressListVC)))

    }

    ///跳转到收货地址页面
    @objc private func pushAddressListVC(){
        let vc=AddressListViewController()
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
extension PlaceOrderViewController{

    private func bindViewModel(){

        ///是否有收货地址信息
        addressVM.defaultAddressModelBR.subscribe(onNext: { [weak self] (model) in
            self?.lblTel.text=model?.phoneNumber
            self?.lblShippName.text=model?.shippName
            let address=(model?.province ?? "")+(model?.city ?? "")+(model?.county ?? "")
            self?.lblAddress.text = address+(model?.detailAddress ?? "")
        }).disposed(by:rx_disposeBag)

        ///是否开启可以使用代金券 默认2关闭,1开启
        vm.cashcouponStatuBR.subscribe(onNext: { [weak self] (i) in
            if i == 1{
                self?.table.reloadSections([1],with:.none)
            }
        }).disposed(by:rx_disposeBag)

        ///分站店铺积分获取是否开启； 1开启，2关闭；
        vm.subStationBalanceStatuBR.subscribe(onNext:{ [weak self]  (i) in
            if i == 1{
                self?.table.reloadSections([1],with:.none)
            }
        }).disposed(by:rx_disposeBag)

        ///下单
        btnSubmit.rx.controlEvent(.touchUpInside).throttle(1, scheduler: MainScheduler.instance).subscribe(onNext: { (_) in
            weak var weakSelf=self
            if weakSelf == nil{
                return
            }
            weakSelf!.vm.submitOrder(goodsList:weakSelf!.goodArr.toJSONString() ?? "", pay_message:weakSelf!.txtBuyPS.text ?? "", cashCouponId:weakSelf!.vm.selectedVouchersModelBR.value?.cashCouponId, addressModel:weakSelf!.addressVM.defaultAddressModelBR.value, detailAddress:weakSelf!.lblAddress.text ?? "")
        }).disposed(by:rx_disposeBag)

        ///下单结果
        vm.submitSuccessBR.subscribe(onNext: { (b) in
            weak var weakSelf=self
            if weakSelf == nil{
                return
            }
            if b{ ///下单成功
                UIAlertController.showAlertYesNo(weakSelf!, title:"点单即到", message:"下单成功,您的货物会在24小时内送货上门,请注意查收。", cancelButtonTitle:"知道了", okButtonTitle:"查看订单", okHandler: { [weak self] (_) in
                    ///订单页面
                    let vc=OrderPageViewController()
                    vc.orderStatus=1
                    vc.carIsFlag=1
                    self?.navigationController?.pushViewController(vc,animated:true)
                }, cancelHandler: { [weak self] (_) in
                    ///返回导航根视图
                    self?.navigationController?.popToRootViewController(animated: true);
                })
                ///更新购物车角标
                APP.tab?.updateCarBadgeValue.onNext(true)
            }
        }).disposed(by:rx_disposeBag)

        ///商品总价
        lblSumPrice.text="￥\(sumPirce)"

        ///共多少件
        var sumCount=0
        let _=goodArr.map { (model) in
            sumCount+=(model.carNumber ?? 1)
        }
        lblSumCount.text="共\(sumCount)件"
    }
}
extension PlaceOrderViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell=table.dequeueReusableCell(withIdentifier:"placeOrderId") as? PlaceOrderTableViewCell ?? PlaceOrderTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"placeOrderId")
            cell.updateCell(model:goodArr[indexPath.row])
            return cell
        }else{
            let cell=table.dequeueReusableCell(withIdentifier:"id") ?? UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"id")
            cell.textLabel!.textColor=UIColor.color666()
            cell.textLabel!.font=UIFont.systemFont(ofSize:14)
            cell.detailTextLabel!.textColor=UIColor.color666()
            cell.detailTextLabel!.font=UIFont.systemFont(ofSize:14)
            cell.accessoryType = .none
            if indexPath.row == 0{
                cell.textLabel!.text="支付方式"
                cell.detailTextLabel!.text="货到付款"
            }else if indexPath.row == 1{
                cell.textLabel!.text="配送方式"
                cell.detailTextLabel!.text="人工送货"
            }else if indexPath.row == 2{
                cell.textLabel!.text="买家附言"
                cell.detailTextLabel!.text=nil
                if (cell.contentView.viewWithTag(555) as? UITextField) == nil{
                    txtBuyPS.frame=CGRect.init(x:80,y:10, width:SCREEN_WIDTH-95, height:30)
                    cell.contentView.addSubview(txtBuyPS)
                }
            }else if indexPath.row == 3{
                cell.textLabel!.text="代金券"
                if vm.cashcouponStatuBR.value == 2{
                    cell.detailTextLabel!.text="该区域暂未开通"
                }else{
                    if vm.selectedVouchersModelBR.value == nil{///如果还没有代价券信息 提示用户满多少可以使用代金券
                        cell.detailTextLabel!.text="满\(vm.cashcouponLowerLimitOfUseBR.value)元可以使用代金券"
                    }else{///如果有代金券信息  提示满多少 可以减多少元
                        cell.detailTextLabel!.text="满\(vm.cashcouponLowerLimitOfUseBR.value)立减\(vm.selectedVouchersModelBR.value!.cashCouponAmountOfMoney ?? 0)元"
                    }

                    cell.accessoryType = .disclosureIndicator
                }
            }else if indexPath.row == 4{
                cell.textLabel!.text="积分"
                if vm.subStationBalanceStatuBR.value == 2{
                    cell.detailTextLabel!.text="该区域暂未开通"
                }else{
                    cell.detailTextLabel!.text="本次下单获得\(sumPirce.components(separatedBy:".")[0])点单币"
                    cell.accessoryType = .disclosureIndicator
                }
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            return 120
        }else{
            return 50
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return goodArr.count
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0{
            var view=table.dequeueReusableHeaderFooterView(withIdentifier:"HeaderId")
            if view == nil{
                view=UITableViewHeaderFooterView(reuseIdentifier:"HeaderId")
                view?.contentView.backgroundColor=UIColor.white
            }
            ///供应商名称
            var lblSupplierName=view!.viewWithTag(11) as? UILabel
            if lblSupplierName == nil{
                lblSupplierName=UILabel.buildLabel(textColor:UIColor.color333(), font:15)
                lblSupplierName!.frame=CGRect.init(x:15, y:15, width:300, height:20)
                lblSupplierName!.tag=11
                view!.addSubview(lblSupplierName!)
            }
            lblSupplierName!.text="商品列表"
            return view
        }else{
            let view=UIView(frame: CGRect.zero)
            view.backgroundColor=UIColor.viewBgdColor()
            return view
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0{
            return 50
        }else{
            return 6
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 0.1
        }else{
            return 5
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated:true)
        if indexPath.section == 1{
            if indexPath.row == 3{///跳转到代金券页面
                if vm.cashcouponStatuBR.value == 1{///如果开通了使用代金券功能 跳转
                    useVouchers()
                }
            }else if indexPath.row == 4{
                if vm.subStationBalanceStatuBR.value == 1{///跳转到点单币商城中
                    let vc=UIStoryboard.init(name:"IntegralStore", bundle:nil).instantiateViewController(withIdentifier:"IntegralStoreVC") as! IntegralStoreViewController
                    self.navigationController?.pushViewController(vc, animated:true)
                }
            }
        }

    }

    ///使用代金券
    private func useVouchers(){
        if Double(self.sumPirce)! >= Double(self.vm.cashcouponLowerLimitOfUseBR.value){//总价必须大于代金券使用下限
            let vc=VouchersViewController()
            vc.orderFlag=1
            vc.useVouchersClosure={ [weak self] (model) in
                ///保存代金券信息
                self?.vm.selectedVouchersModelBR.accept(model)

                ///计算能省多少元钱
                let price=PriceComputationsUtil.decimalNumberWithString(multiplierValue:self?.sumPirce ?? "0", multiplicandValue:(model.cashCouponAmountOfMoney ?? 0).description, type: ComputationsType.subtraction, position:2)
                self?.lblSumPrice.text="￥\(price)(立省\(model.cashCouponAmountOfMoney ?? 0)元)"
                ///刷新代金券信息
                self?.table.reloadRows(at:[IndexPath(row:3,section: 1)], with: .none)
            }
            self.navigationController?.pushViewController(vc, animated:true)
        }else{
            PHProgressHUD.showInfo("订单金额要满\(self.vm.cashcouponLowerLimitOfUseBR.value)元才能使用代金券")
        }
    }
}
