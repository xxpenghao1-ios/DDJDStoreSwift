//
//  NewGoodListTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/7.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit
///新品推荐Cell
class NewGoodListTableViewCell: UITableViewCell {
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
    ///商品建议零售价
    @IBOutlet weak var lblUitemPrice:UILabel!
    ///商品价格
    @IBOutlet weak var lblUpice:UILabel!
    ///商品库存
    @IBOutlet weak var lblStock:UILabel!
    ///加入购物车
    @IBOutlet weak var btnAddCar:UIButton!
    ///商品加减数量
    @IBOutlet weak var stepper: GMStepper!
    ///已售罄
    @IBOutlet weak var to_sell_out_ImgView:UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        ///默认隐藏已售罄图片
        to_sell_out_ImgView.isHidden=true
        ///设置文字大小
        stepper.labelFont=UIFont.systemFont(ofSize:16)
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

        ///默认值 最低起送量
        stepper.value=Double(model.miniCount ?? 1)
        ///最小值 最低起送量
        stepper.minimumValue=Double(model.miniCount ?? 1)
        ///每次加减值
        stepper.stepValue=Double(model.goodsBaseCount ?? 1)

        if model.goodsStock == -1{
            lblStock.text="库存充足"
            ///最大值 999
            stepper.maximumValue=999
        }else{
            lblStock.text="库存:\(model.goodsStock ?? 0)"
            ///最大值 库存数
            stepper.maximumValue=Double(model.goodsStock ?? 1)

            ///如果库存等于0或者空
            if model.goodsStock == nil || model.goodsStock == 0{
                showTo_sell_out_ImgView()
            }

        }

        lblGoodUnit.text=model.goodUnit

        lblUcode.text="/\(model.ucode ?? "")"

        lblUitemPrice.text=model.uitemPrice

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
