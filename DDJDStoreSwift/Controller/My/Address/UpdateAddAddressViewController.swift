//
//  UpdateAddAddressViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/20.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation

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

    override func viewDidLoad() {
        super.viewDidLoad()
        if addressModel != nil{
            self.title="修改收货地址"
        }else{
            self.title="添加收货地址"
        }
        isDefault.transform=CGAffineTransform(scaleX: 0.75, y: 0.75)
        isDefault.onTintColor = UIColor.applicationMainColor()
    }
}
