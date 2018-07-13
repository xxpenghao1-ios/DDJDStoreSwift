//
//  PromotionGoodTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/13.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit

///促销cell
class PromotionGoodTableViewCell: UITableViewCell {
    ///跳转到商品详情
    var pushGoodDetailClosure:((_ model:GoodDetailModel) -> Void)?
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
    ///商品销量
    @IBOutlet weak var lblSalesCount:UILabel!
    ///商品库存
    @IBOutlet weak var lblStock:UILabel!
    ///加入购物车
    @IBOutlet weak var btnAddCar:UIButton!
    ///活动剩余时间
    @IBOutlet weak var lblEndTime:UILabel!
    ///促销活动内容
    @IBOutlet weak var lblPromotionStr:UILabel!
    ///商品状态图片  已售罄/活动已结束
    @IBOutlet weak var goodStateImgView:UIImageView!
    ///保存特价model
    private var model:GoodDetailModel?
    ///行索引
    var index:Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        ///默认隐藏
        goodStateImgView.isHidden=true
        ///点击图片跳转页面
        imgView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(pushGoodDetail)))
    }
    func updateCell(model:GoodDetailModel){
        self.model=model
        ///每次更新数据先隐藏
        hideGoodStateImgView()

        imgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)

        //商品名称
        if model.promotionStoreEachCount == nil{
            lblGoodName.text=model.goodInfoName
        }else{
            lblGoodName.text=(model.goodInfoName ?? "")+"(限购~~\(model.promotionStoreEachCount!)\(model.goodUnit ?? ""))"
        }

        lblStock.text="库存:\(model.promotionEachCount ?? 0)"
        ///如果库存等于0或者空
        if model.promotionEachCount == nil || model.promotionEachCount == 0{
            showGoodStateImgView(name:"to_sell_out")
        }

        lblGoodUnit.text=model.goodUnit

        lblUcode.text="/\(model.ucode ?? "")"

        lblUpice.text="￥\(model.uprice ?? "0")"

        lblSalesCount.text="销量:\(model.salesCount ?? 0)"

        lblPromotionStr.text=model.goodsDes

        let times=model.promotionEndTime?.components(separatedBy:".")
        if times != nil && Int(times![0]) > 0{///促销时间不为空
            lblEndTime.text=lessSecondToDay(Int(times![0])!)
        }else{
            lblEndTime.text="活动已结束"
        }
    }
    ///显示商品状态提示图片 禁止进入商品详情页面 购物车按钮隐藏
    func showGoodStateImgView(name:String){
        imgView.isUserInteractionEnabled=false
        goodStateImgView.image=UIImage(named:name)
        goodStateImgView.isHidden=false
        btnAddCar.isHidden=true
    }
    ///隐藏商品状态提示图片 可以进入商品详情页面 购物车按钮显示
    private func hideGoodStateImgView(){
        imgView.isUserInteractionEnabled=true
        goodStateImgView.isHidden=true
        btnAddCar.isHidden=false
    }
    ///跳转到商品详情
    @objc private func pushGoodDetail(){
        if model != nil{
            self.pushGoodDetailClosure?(model!)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
