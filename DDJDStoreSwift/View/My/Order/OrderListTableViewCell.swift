//
//  OrderListTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/5.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit
///订单列表cell
class OrderListTableViewCell: UITableViewCell {

    ///供应商名称
    @IBOutlet weak var lblSupplierName:UILabel!

    ///订单总价
    @IBOutlet weak var lblOrderPrice:UILabel!

    ///订单编号
    @IBOutlet weak var lblOrderSN:UILabel!

    ///3个商品图片
    @IBOutlet weak var imgView1:UIImageView!
    @IBOutlet weak var imgView2:UIImageView!
    @IBOutlet weak var imgView3:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgView1.isHidden=true
        imgView2.isHidden=true
        imgView3.isHidden=true
    }

    func updateCell(model:OrderModel){
        lblSupplierName.text=model.supplierName
        lblOrderPrice.text="￥\(model.orderPrice ?? "0")"
        lblOrderSN.text="订单号:\(model.orderSN ?? "")"
        if model.list != nil{//商品集合不为空
            for i in 0..<model.list!.count{
                let model=model.list![i]
                switch i{
                case 0:
                    imgView1.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)
                    imgView1.isHidden=false
                    break
                case 1:
                    imgView2.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)
                    imgView2.isHidden=false
                    break
                case 2:
                    imgView3.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)
                    imgView3.isHidden=false
                    return
                default:break
                }
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
