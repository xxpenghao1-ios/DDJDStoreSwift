//
//  UpdateAddAddressViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/20.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
///修改添加收货地址
class UpdateAddAddressViewController:BaseViewController{
    ///修改接收地址信息 nil添加
    var addressModel:AddressModel?
    //收货人姓名
    @IBOutlet weak var txtName: UITextField!
    //收货人电话
    @IBOutlet weak var txtTel: UITextField!
    //收货地址
    @IBOutlet weak var lblAddress: UILabel!
    //详细地址
    @IBOutlet weak var txtDetailsAddress: UITextField!
    //是否是默认地址
    @IBOutlet weak var isDefault: UISwitch!
    ///提交
    @IBOutlet weak var btnSubmit: UIButton!

    private var vm=UpdateAddAddressViewModel()

    ///省
    private var province=""

    ///市
    private var city=""

    ///区
    private var county=""

    override func viewDidLoad() {
        super.viewDidLoad()
        if addressModel != nil{
            self.title="修改收货地址"
            setData()
        }else{
            self.title="添加收货地址"
        }
        isDefault.transform=CGAffineTransform(scaleX: 0.75, y: 0.75)
        isDefault.onTintColor = UIColor.applicationMainColor()
        lblAddress.isUserInteractionEnabled=true
        lblAddress.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(showAddressSelectedVC)))
        bindViewModel()
        //接收地区选择的通知
        NotificationCenter.default.addObserver(self, selector:#selector(updateAddress), name: NSNotification.Name(rawValue: "postUpdateAddress"), object: nil)

    }
    /**
     实现地区选择协议

     - parameter str: 选中的省市区
     */
    @objc func updateAddress(_ obj:Notification) {
        let myAddress=obj.object as? String
        let addressArr=myAddress!.components(separatedBy: "-")
        province=addressArr[0]
        city=addressArr[1]
        county=addressArr[2]
        lblAddress.text=province+city+county
    }
    ///弹出地址选择
    @objc private func showAddressSelectedVC(){
        let vc=ShowAddressViewController()
        let nav=UINavigationController(rootViewController:vc)
        self.present(nav, animated:true, completion:nil)
    }
    deinit{
        NotificationCenter.default.removeObserver(self)
    }
}

extension UpdateAddAddressViewController{

    ///修改收货地址调用
    private func setData(){
        province=addressModel!.province ?? ""
        city=addressModel!.city ?? ""
        county=addressModel!.county ?? ""
        txtName.text=addressModel!.shippName
        txtTel.text=addressModel!.phoneNumber
        txtDetailsAddress.text=addressModel!.detailAddress
        lblAddress.text=province+city+county
        isDefault.isOn=addressModel!.defaultFlag == 1 ? true:false
    }
    private func bindViewModel(){

        btnSubmit.rx.tap.throttle(1, scheduler:MainScheduler.instance).subscribe(onNext: { (_) in
            weak var weakSelf=self
            if weakSelf == nil{
                return
            }
            if weakSelf!.addressModel == nil{
                weakSelf!.vm.addAddress(flag:weakSelf!.isDefault.isOn == true ? 1:2, province: weakSelf!.province, city:weakSelf!.city, county: weakSelf!.county, detailAddress:weakSelf!.txtDetailsAddress!.text ?? "", phoneNumber: weakSelf!.txtTel.text ?? "", shippName:weakSelf!.txtName.text ?? "")
            }else{
                weakSelf!.vm.updateAddress(flag:weakSelf!.isDefault.isOn == true ? 1:2, province: weakSelf!.province, city:weakSelf!.city, county: weakSelf!.county, detailAddress:weakSelf!.txtDetailsAddress!.text ?? "", phoneNumber: weakSelf!.txtTel.text ?? "", shippName:weakSelf!.txtName.text ?? "",shippAddressId:weakSelf!.addressModel!.shippAddressId ?? 0)
            }
        }).disposed(by:rx_disposeBag)

        ///操作成功返回上一页
        vm.resultPS.subscribe(onNext: { [weak self] (b) in
            if b{
                self?.navigationController?.popViewController(animated: true)
            }
        }).disposed(by:rx_disposeBag)
    }
}
