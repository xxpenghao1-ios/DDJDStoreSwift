//
//  IntegralGoodCollectionViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit

///积分商品cell
class IntegralGoodCollectionViewCell: UICollectionViewCell {

    ///兑换商品
    var exchangeIntegralGoodClosure:(() -> Void)?

    ///商品图片
    @IBOutlet weak var imgView:UIImageView!

    ///商品名称
    @IBOutlet weak var lblGoodName:UILabel!

    ///积分
    @IBOutlet weak var lblIntegral:UILabel!

    ///兑换按钮
    @IBOutlet weak var btn:UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
    
        btn.layer.cornerRadius=25/2

    }
    ///兑换积分商品
    @IBAction func exchangeIntegerGood(_ sender: UIButton) {
        exchangeIntegralGoodClosure?()
    }
    func updateCell(model:IntegralGoodModel){

        imgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodsPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)

        lblGoodName.text=(model.goodsName ?? "")+"(剩余兑换:\(model.goodsSurplusCount ?? 0))"

        lblIntegral.text=model.exchangeIntegral?.description

        if model.goodsSurplusCount == nil || model.goodsSurplusCount < 1{
            btn.setTitle("兑换完毕", for: UIControlState.normal)
            btn.backgroundColor=UIColor.RGBFromHexColor(hexString:"e3e3e3")
            btn.isEnabled=false
        }else{
            btn.setTitle("立即兑换", for: UIControlState.normal)
            btn.backgroundColor=UIColor.applicationMainColor()
            btn.isEnabled=true
        }
        
    }

}
