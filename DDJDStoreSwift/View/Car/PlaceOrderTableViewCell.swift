//
//  PlaceOrderTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/20.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit

///下单cell
class PlaceOrderTableViewCell: UITableViewCell {
    //商品名称
    @IBOutlet weak var lblGoodName: UILabel!
    //商品数量
    @IBOutlet weak var lblGoodCount: UILabel!
    //商品价格
    @IBOutlet weak var lblGoodPrice: UILabel!
    //商品图片
    @IBOutlet weak var goodImg: UIImageView!
    //商品单位
    @IBOutlet weak var lblUnit: UILabel!
    ///商品是否可退
    @IBOutlet weak var lblReturnGoods:UILabel!
    ///flag 1特价图片 3促销图片
    @IBOutlet weak var goodFlagImgView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        goodImg.layer.borderWidth=0.5
        goodImg.layer.borderColor=UIColor.cellBorderColor().cgColor
        // Initialization code
        ///默认隐藏是否退换提示
        lblReturnGoods.isHidden=true
    }
    func updateCell(model:GoodDetailModel){
        goodImg.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)
        lblGoodName.text=model.goodInfoName
        lblGoodPrice.text="￥\(model.uprice ?? "0")"
        lblGoodCount.text="x\(model.carNumber ?? 1)"
        lblUnit.text="/\(model.goodUnit ?? "")"
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
        if model.flag == 1{//如果是特价
            lblGoodPrice.text="￥\(model.prefertialPrice ?? "0")"
            ///显示特价图标
            goodFlagImgView.image=UIImage(named:"special_good")
            goodFlagImgView.isHidden=false
        }else if model.flag == 3{///如果是促销
            ///显示促销图标
            goodFlagImgView.image=UIImage(named:"promotion_good")
            goodFlagImgView.isHidden=false
        }else{///普通价格
            ///隐藏促销特价图片 防止重复显示
            goodFlagImgView.isHidden=true
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
