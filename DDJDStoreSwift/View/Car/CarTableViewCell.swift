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
    @IBOutlet weak var stepper: GMStepper!
    ///商品状态图片  已售罄
    @IBOutlet weak var goodStateImgView:UIImageView!
    ///flag 1特价图片 3促销图片
    @IBOutlet weak var goodFlagImgView:UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        ///设置文字大小
        stepper.labelFont=UIFont.systemFont(ofSize:16)
        ///默认隐藏
        goodFlagImgView.isHidden=true

        ///默认隐藏
        goodStateImgView.isHidden=true

        ///设置购物车选择按钮
        btnSelectedGood.setImage(UIImage.init(named:"car_selected"), for: UIControlState.selected)

        btnSelectedGood.setImage(UIImage.init(named:"car_uncheck"), for: UIControlState.normal)

        ///点击图片跳转页面
        imgView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(pushGoodDetail)))
    }
    func updateCell(model:GoodDetailModel){

        hideGoodStateImgView()

        imgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)

        lblUpice.text="￥\(model.uprice ?? "0")"

        lblGoodUnit.text=model.goodUnit

        lblUcode.text="/\(model.ucode ?? "")"

        ///默认值
        stepper.value=Double(model.carNumber ?? 1)
        ///最小值 最低起送量
        stepper.minimumValue=Double(model.miniCount ?? 1)
        ///每次加减值
        stepper.stepValue=Double(model.goodsBaseCount ?? 1)

        if model.isSelected == 1{///选中
            btnSelectedGood.isSelected=true
        }else{///未选中
            btnSelectedGood.isSelected=false
        }

        if model.flag == 1{//如果是特价
            lblGoodName.text=(model.goodInfoName ?? "")+"(限购~~\(model.eachCount ?? 0)\(model.goodUnit ?? ""))"
            setStock(stock:model.goodsCount)
            lblUpice.text="￥\(model.prefertialPrice ?? "0")"
            ///显示特价图标
            goodFlagImgView.image=UIImage(named:"special_good")
            goodFlagImgView.isHidden=false
            ///最大值 限购数
            stepper.maximumValue=Double(model.eachCount ?? 1)
        }else if model.flag == 3{///如果是促销
            lblGoodName.text=(model.goodInfoName ?? "")+"(限购~~\(model.promotionStoreEachCount ?? 0)\(model.goodUnit ?? ""))"
            setStock(stock:model.promotionEachCount)
            ///显示促销图标
            goodFlagImgView.image=UIImage(named:"promotion_good")
            goodFlagImgView.isHidden=false
            ///最大值 限购数
            stepper.maximumValue=Double(model.promotionStoreEachCount ?? 1)
        }else{///普通价格

            setStock(stock: model.goodsStock)
            ///最大值 999
            stepper.maximumValue=Double(model.goodsStock == -1 ? 999 : (model.goodsStock ?? 1))
            
            lblGoodName.text=model.goodInfoName
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
        }else{
            if stock == -1{
                lblStock.text="库存充足"
            }else{
                lblStock.text="库存:\(stock!)"
            }
        }
    }
    ///跳转到商品详情
    @objc private func pushGoodDetail(){
        self.pushGoodDetailClosure?()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
