//
//  OrderDetailViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/5.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

///订单详情
class OrderDetailViewController:BaseViewController{

    ///声明闭包 取消订单成功告诉订单列表
    var cancelOrderClosure:(() -> Void)?

    ///声明闭包 确认收货成功告诉订单列表
    var confirmTheGoodsClosure:(() -> Void)?

    ///接收订单Id
    var orderinfoId:Int?

    ///订单编号
    @IBOutlet weak var lblOrderSN:UILabel!

    ///订单状态
    @IBOutlet weak var lblOrderStatus:UILabel!

    ///联系店铺名称
    @IBOutlet weak var lblStoreName:UILabel!

    ///店铺联系方式
    @IBOutlet weak var lblPhone_tel:UILabel!

    ///店铺地址
    @IBOutlet weak var lblStoreAddress:UILabel!

    ///订单总价
    @IBOutlet weak var lblOrderPrice:UILabel!

    ///订单按钮 取消订单 确认收货  根据状态来定
    @IBOutlet weak var btn:UIButton!

    @IBOutlet weak var table:UITableView!

    private var vm:OrderDetailViewModel!
    ///保存商品数组
    private var arr=[OrderGoodModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="订单详情"
        ///设置按钮圆角
        btn.layer.cornerRadius=35/2

        table.separatorInset = UIEdgeInsetsMake(0,0,0,0)
        ///注册cel
        table.register(UINib(nibName:"OrderDetailGoodTableViewCell", bundle:nil), forCellReuseIdentifier:"orderDetailGoodId")
        ///初始化vm
        vm=OrderDetailViewModel(orderinfoId:orderinfoId)
        ///绑定vm
        bindViewModel()
    }
}
///绑定vm
extension OrderDetailViewController{

    private func bindViewModel(){

        ///获取订单详情数据
        vm.orderDetailModelBR.asObservable().subscribe(onNext: { [weak self] (model) in
            self?.lblPhone_tel.text=model.phone_tel
            self?.lblOrderSN.text=model.orderSN
            self?.lblStoreName.text=model.storeName
            self?.lblStoreAddress.text=model.address
            self?.lblOrderPrice.text="￥\(model.orderPrice ?? "0")"
            if model.orderStatus == 1{
                self?.lblOrderStatus.text="未发货"
                self?.btn.setTitle("取消订单", for: UIControlState.normal)
                self?.cancelOrder()
            }else if model.orderStatus == 2{
                self?.lblOrderStatus.text="已发货"
                self?.btn.setTitle("确认收货", for: UIControlState.normal)
                self?.confirmTheGoods()
            }else if model.orderStatus == 3{
                self?.lblOrderStatus.text="已完成"
                self?.btn.isHidden=true
            }
            self?.arr=model.listAndroid ?? [OrderGoodModel]()
            self?.table.reloadData()
            },onError:{ [weak self] (error) in
                PHProgressHUD.showError(error.localizedDescription)
                self?.navigationController?.popViewController(animated:true)
            }).disposed(by:rx_disposeBag)

        ///取消订单结果
        vm.cancelOrderResult?.subscribe(onNext: { [weak self] (result) in
            if result{//取消订单成功 返回订单列表
                self?.cancelOrderClosure?() ///订单列表刷新数据
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by:rx_disposeBag)

        ///确认收货结果
        vm.confirmTheGoodsResult?.subscribe(onNext: { [weak self] (result) in
            if result{//确认收货成功 返回订单列表
                self?.confirmTheGoodsClosure?() ///订单列表刷新数据
                self?.confirmTheGoodsSuccess()
            }
        }).disposed(by:rx_disposeBag)
    }
    ///取消订单
    private func cancelOrder(){
        ///调用取消订单
        btn.rx.tap.asObservable().throttle(1, scheduler:MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            self?.confirmCancelTheOrder()
        }).disposed(by:rx_disposeBag)
    }

    ///确定取消订单吗
    private func confirmCancelTheOrder(){
        UIAlertController.showAlertYesNo(self, title:"提示", message:"您确定要取消订单吗?", cancelButtonTitle:"取消", okButtonTitle:"确定", okHandler: {  [weak self] (action) in
            self?.vm.cancelOrderPS.onNext(true)
        })
    }

    ///确认收货
    private func confirmTheGoods(){
        ///调用确认收货
        btn.rx.tap.asObservable().throttle(1, scheduler:MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            self?.vm.confirmTheGoodsPS.onNext(true)
        }).disposed(by:rx_disposeBag)
    }

    ///确认收货成功
    private func confirmTheGoodsSuccess(){
        UIAlertController.showAlertYesNo(self, title:"点单即到", message:"确认收货成功,您可以对本次订单评分", cancelButtonTitle:"返回", okButtonTitle:"去评价", okHandler: { [weak self] (_) in
            let vc=UIStoryboard(name:"OrderEvaluation", bundle:nil).instantiateViewController(withIdentifier:"OrderEvaluationVC") as! OrderEvaluationViewController
            vc.supplierName=self?.vm.orderDetailModelBR.value.supplierName
            vc.orderInfoId=self?.vm.orderDetailModelBR.value.orderinfoId
            self?.navigationController?.pushViewController(vc, animated:true)
        }) { [weak self] (_) in
            self?.navigationController?.popViewController(animated:true)
        }
    }
}

extension OrderDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return arr.count
        }else{
            return vm.orderOtherTitleArr.count
        }

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell=table.dequeueReusableCell(withIdentifier:"orderDetailGoodId") as? OrderDetailGoodTableViewCell ?? OrderDetailGoodTableViewCell(style: UITableViewCellStyle.default,reuseIdentifier:"orderDetailGoodId")
            if arr.count > 0{
                cell.updateCell(model:arr[indexPath.row])
            }
            return cell
        }else{
            let cell=table.dequeueReusableCell(withIdentifier:"orderDetailId") ?? UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"orderDetailId")
            cell.textLabel?.font=UIFont.systemFont(ofSize:14)
            cell.textLabel?.textColor=UIColor.color333()
            cell.detailTextLabel?.font=UIFont.systemFont(ofSize:14)
            cell.detailTextLabel?.textColor=UIColor.textColor()
            if indexPath.row == 2 || indexPath.row == 3 || indexPath.row == 4{
                cell.accessoryType = .disclosureIndicator
            }else{
                cell.accessoryType = .none
            }
            ///获取key
            cell.textLabel?.text=vm.orderOtherTitleArr[indexPath.row]
            if vm.orderOtherTitleArrValue.count > 0{//value
                cell.detailTextLabel?.text=vm.orderOtherTitleArrValue[indexPath.row]
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        }else{
            return 50
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
            lblSupplierName!.text=vm.orderDetailModelBR.value.supplierName
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
            return 5
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1{
            tableView.deselectRow(at:indexPath, animated:true)
            if indexPath.row == 2{//联系卖家
                let tel=vm.orderOtherTitleArrValue[indexPath.row]
                if tel != nil{
                    UIApplication.shared.openURL(Foundation.URL(string :"tel://\(tel!)")!)
                }
            }else if indexPath.row == 3{
                UIAlertController.showAlertYes(self, title:"卖家留言", message:vm.orderOtherTitleArrValue[indexPath.row], okButtonTitle:"确定")
            }
            else if indexPath.row == 4{
                UIAlertController.showAlertYes(self, title:"买家留言", message:vm.orderOtherTitleArrValue[indexPath.row], okButtonTitle:"确定")
            }
        }
    }
}
