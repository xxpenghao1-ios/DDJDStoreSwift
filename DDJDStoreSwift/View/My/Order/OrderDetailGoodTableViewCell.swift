//
//  OrderDetailGoodTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/6.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit
///订单商品详情cell
class OrderDetailGoodTableViewCell: UITableViewCell {
    ///商品图片
    @IBOutlet weak var imgView:UIImageView!
    ///商品名称
    @IBOutlet weak var lblGoodName:UILabel!
    ///商品价格
    @IBOutlet weak var lblGoodUpice:UILabel!
    ///商品单位
    @IBOutlet weak var lblGoodUnit:UILabel!
    ///商品数量
    @IBOutlet weak var lblGoodCount:UILabel!
    ///商品是否可退
    @IBOutlet weak var lblReturnGoods:UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        imgView.layer.borderWidth=0.5
        imgView.layer.borderColor=UIColor.cellBorderColor().cgColor
        // Initialization code
        ///默认隐藏是否退换提示
        lblReturnGoods.isHidden=true
    }
    ///更新cell数据
    func updateCell(model:OrderGoodModel){
        imgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)
        lblGoodName.text=model.goodInfoName
        lblGoodUpice.text="￥\(model.goodsUprice ?? 0)"
        lblGoodCount.text="x\(model.goodsSumCount ?? 0)"
        lblGoodUnit.text="/\(model.goodUnit ?? "")"
        if model.returnGoodsFlag != nil{
            if model.returnGoodsFlag == 1{
                lblReturnGoods.text="该商品可以退换"
            }else if model.returnGoodsFlag == 2{
                lblReturnGoods.text="该商品不可退换"
            }else{
                lblReturnGoods.text=""
            }
            lblReturnGoods.isHidden=false
        }

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
