//
//  PurchaseRecordsTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/25.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit
///购买记录
class PurchaseRecordsTableViewCell: UITableViewCell {
    ///跳转到商品详情
    var pushGoodDetailClosure:(() -> Void)?
    ///加入购物车
    var addCarClosure:(() -> Void)?
    ///商品图片
    @IBOutlet weak var imgView:UIImageView!
    ///商品名称
    @IBOutlet weak var lblGoodName:UILabel!
    ///商品单位
    @IBOutlet weak var lblGoodUnit:UILabel!
    ///商品规格
    @IBOutlet weak var lblUcode:UILabel!
    ///商品价格
    @IBOutlet weak var lblUpice:UILabel!
    ///商品库存
    @IBOutlet weak var lblStock:UILabel!
    ///加入购物车
    @IBOutlet weak var btnAddCar:UIButton!
    ///已售罄
    @IBOutlet weak var to_sell_out_ImgView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        ///默认隐藏已售罄图片
        to_sell_out_ImgView.isHidden=true
        ///设置圆角
        btnAddCar.layer.cornerRadius=15
        ///点击图片跳转页面
        imgView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(pushGoodDetail)))
        ///加入购物车
        btnAddCar.addTarget(self, action:#selector(addCar), for: UIControlEvents.touchUpInside)
    }
    ///更新cell
    func updateCell(model:GoodDetailModel){
        ///每次更新数据先隐藏已售罄图片
        hideTo_sell_out_ImgView()

        imgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)

        lblGoodName.text=model.goodInfoName

        if model.goodsStock == -1{
            lblStock.text="库存充足"
        }else{
            lblStock.text="库存:\(model.goodsStock ?? 0)"

            ///如果库存等于0或者空
            if model.goodsStock == nil || model.goodsStock == 0{
                showTo_sell_out_ImgView()
            }

        }

        lblGoodUnit.text=model.goodUnit

        lblUcode.text="/\(model.ucode ?? "")"

        lblUpice.text="￥\(model.uprice ?? "0")"

    }
    ///显示已售罄图片
    private func showTo_sell_out_ImgView(){
        imgView.isUserInteractionEnabled=false
        to_sell_out_ImgView.isHidden=false
        btnAddCar.isHidden=true
    }
    ///隐藏已售罄图片
    private func hideTo_sell_out_ImgView(){
        imgView.isUserInteractionEnabled=true
        to_sell_out_ImgView.isHidden=true
        btnAddCar.isHidden=false

    }
    ///跳转到商品详情
    @objc private func pushGoodDetail(){
        self.pushGoodDetailClosure?()
    }
    ///加入购物车
    @objc private func addCar(){
        self.addCarClosure?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
