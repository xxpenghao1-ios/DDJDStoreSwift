//
//  AddressListTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/20.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit
///收货地址list cell
class AddressListTableViewCell: UITableViewCell {

    /// 姓名
    @IBOutlet weak var lblName: UILabel!

    ///电话
    @IBOutlet weak var lblPhone: UILabel!

    /// 省市区
    @IBOutlet weak var lblAddress: UILabel!

    /// 详细地址
    @IBOutlet weak var lblDetailAddress: UILabel!

    /// 默认地址
    @IBOutlet weak var lblDefaultAddress: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        lblDefaultAddress.isHidden=true
    }
    /**
     更新cell

     */
    func updateCell(model:AddressModel){
        lblName.text=model.shippName
        lblPhone.text=model.phoneNumber
        lblAddress.text=(model.province ?? "")+(model.city ?? "")+(model.county ?? "")
        lblDetailAddress.text=model.detailAddress
        if model.defaultFlag == 1{
            lblDefaultAddress.isHidden=false
        }else{
            lblDefaultAddress.isHidden=true
        }
    }
    
}
