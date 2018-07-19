//
//  CarTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/18.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit
///购物车cell
class CarTableViewCell: UITableViewCell {
    ///跳转到商品详情
    var pushGoodDetailClosure:(() -> Void)?
    ///更新商品数量
    var updateCarNumberClosure:((_ carNumber:Int) -> Void)?
    ///更新购物车商品选中状态
    var updateCarGoodSelectedStateClosure:((_ isSelected:Bool) -> Void)?
    ///购物车是否选中
    @IBOutlet weak var btnSelectedGood:UIButton!
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
    ///商品加减数量
    @IBOutlet weak var stepper:UIView!
    ///商品数量
    @IBOutlet weak var lblCarNumber:UILabel!
    ///添加商品数量
    @IBOutlet weak var btnAddCount:UIButton!
    ///减少商品数量
    @IBOutlet weak var btnSubtractCount:UIButton!
    ///商品状态图片  已售罄
    @IBOutlet weak var goodStateImgView:UIImageView!
    ///flag 1特价图片 3促销图片
    @IBOutlet weak var goodFlagImgView:UIImageView!

    ///最低起送量 默认1
    private var minCarNumberCount:Int=1
    ///最大商品数量 默认1
    private var maxCarNumberCount:Int=0
    ///每次加减数量 默认1
    private var goodsBaseCount:Int=1
    ///保存商品信息
    private var goodModel:GoodDetailModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        ///设置圆角
        stepper.layer.cornerRadius=5
        stepper.layer.masksToBounds=true
        ///默认隐藏
        goodFlagImgView.isHidden=true

        ///默认隐藏
        goodStateImgView.isHidden=true

        ///设置购物车选择按钮
        btnSelectedGood.setImage(UIImage.init(named:"car_selected"), for: UIControlState.selected)

        btnSelectedGood.setImage(UIImage.init(named:"car_uncheck"), for: UIControlState.normal)

        ///商品选中
        btnSelectedGood.addTarget(self, action:#selector(carGoodIsSelected), for: UIControlEvents.touchUpInside)

        ///添加商品数量
        btnAddCount.addTarget(self, action:#selector(addGoodCount),for:.touchUpInside)

        ///减少商品数量
        btnSubtractCount.addTarget(self, action:#selector(subtractGoodCount),for:.touchUpInside)

        ///点击图片跳转页面
        imgView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(pushGoodDetail)))


    }
    func updateCell(model:GoodDetailModel){

        self.goodModel=model

        hideGoodStateImgView()

        imgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)

        lblUpice.text="￥\(model.uprice ?? "0")"

        lblGoodUnit.text=model.goodUnit

        lblUcode.text="/\(model.ucode ?? "")"

        ///默认值
        lblCarNumber.text="\(model.carNumber ?? 1)"

        ///最低起送量
        minCarNumberCount=model.miniCount ?? 1
        ///每次加减数量
        goodsBaseCount=model.goodsBaseCount ?? 1

        if model.isSelected == 1{///选中
            btnSelectedGood.isSelected=true
        }else{///未选中
            btnSelectedGood.isSelected=false
        }

        if model.flag == 1{//如果是特价
            lblGoodName.text=(model.goodInfoName ?? "")+"(限购~~\(model.eachCount ?? 0)\(model.goodUnit ?? ""))"
            setStock(stock: model.goodsStock)
            lblUpice.text="￥\(model.prefertialPrice ?? "0")"
            ///显示特价图标
            goodFlagImgView.image=UIImage(named:"special_good")
            goodFlagImgView.isHidden=false
            ///最大购买数量
            maxCarNumberCount=model.eachCount ?? 0
        }else if model.flag == 3{///如果是促销
            lblGoodName.text=(model.goodInfoName ?? "")+"(限购~~\(model.promotionStoreEachCount ?? 0)\(model.goodUnit ?? ""))"
            setStock(stock: model.goodsStock)
            ///显示促销图标
            goodFlagImgView.image=UIImage(named:"promotion_good")
            goodFlagImgView.isHidden=false
            ///最大购买数量
            maxCarNumberCount=model.promotionStoreEachCount ?? 0
        }else{///普通价格
            ///隐藏促销特价图片 防止重复显示
            goodFlagImgView.isHidden=true

            setStock(stock: model.goodsStock)

            lblGoodName.text=model.goodInfoName
            ///最大购买数量
            maxCarNumberCount=model.goodsStock == -1 ? 999 : (model.goodsStock ?? 0)
        }

    }
    ///显示商品状态提示图片 禁止进入商品详情页面 购物车商品加减数量隐藏
    func showGoodStateImgView(name:String){
        imgView.isUserInteractionEnabled=false
        goodStateImgView.image=UIImage(named:name)
        goodStateImgView.isHidden=false
        stepper.isHidden=true
        btnSelectedGood.isHidden=true
    }
    ///隐藏商品状态提示图片 可以进入商品详情页面 购物车商品加减数量显示
    private func hideGoodStateImgView(){
        imgView.isUserInteractionEnabled=true
        goodStateImgView.isHidden=true
        stepper.isHidden=false
        btnSelectedGood.isHidden=false
    }
    ///处理库存
    private func setStock(stock:Int?){
        if stock == nil || stock! == 0{
            showGoodStateImgView(name:"to_sell_out")
            lblStock.text="库存:0"
        }else{
            if stock == -1{
                lblStock.text="库存充足"
            }else{
                lblStock.text="库存:\(stock!)"
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
///事件
extension CarTableViewCell{
    ///跳转到商品详情
    @objc private func pushGoodDetail(){
        self.pushGoodDetailClosure?()
    }

    ///购物车商品选中
    @objc func carGoodIsSelected(sender:UIButton){
        if sender.isSelected{
            sender.isSelected=false
            self.updateCarGoodSelectedStateClosure?(false)
        }else{
            sender.isSelected=true
            self.updateCarGoodSelectedStateClosure?(true)
        }
    }
    ///添加商品数量
    @objc private func addGoodCount(){
        if goodModel == nil{
            return
        }

        if goodModel!.carNumber!+goodsBaseCount <= maxCarNumberCount{ //如果当前商品加上每次加减数量后小于等于最大购买数量  更新商品数量

            goodModel!.carNumber!+=goodsBaseCount

            self.updateCarNumberClosure?(goodModel!.carNumber!)

            ///更新购物车BadgeValue(购物车加减执行 true加 false减)
            APP.tab?.carAddSubtractUpdateCarBadgeValue.onNext([true:goodsBaseCount])
        }
    }
    ///减少商品数量
    @objc private func subtractGoodCount(){
        if goodModel == nil{
            return
        }
        if goodModel!.carNumber! > minCarNumberCount{ //如果大于最最低起送量
            
            goodModel!.carNumber!-=goodsBaseCount

            self.updateCarNumberClosure?(goodModel!.carNumber!)

            ///更新购物车BadgeValue(购物车加减执行 true加 false减)
            APP.tab?.carAddSubtractUpdateCarBadgeValue.onNext([false:goodsBaseCount])
        }
    }

}
