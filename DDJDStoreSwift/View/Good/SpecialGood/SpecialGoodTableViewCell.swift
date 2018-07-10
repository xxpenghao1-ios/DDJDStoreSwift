//
//  SpecialGoodTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/10.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit
///特价cell
class SpecialGoodTableViewCell: UITableViewCell {
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
    ///商品原价
    @IBOutlet weak var lblOldPrice:UILabel!
    ///商品销量
    @IBOutlet weak var lblSalesCount:UILabel!
    ///商品库存
    @IBOutlet weak var lblStock:UILabel!
    ///加入购物车
    @IBOutlet weak var btnAddCar:UIButton!
    ///商品状态图片  已售罄/活动已结束
    @IBOutlet weak var goodStateImgView:UIImageView!
    ///保存新品model
    private var model:GoodDetailModel?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        ///默认隐藏
        goodStateImgView.isHidden=true
    }
    
    func updateCell(model:GoodDetailModel){

        ///每次更新数据先隐藏
        hideGoodStateImgView()
        
        imgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)

        //商品名称
        if model.eachCount == nil{
            lblGoodName.text=model.goodInfoName
        }else{
            lblGoodName.text=(model.goodInfoName ?? "")+"(限购~~\(model.eachCount!)\(model.goodUnit ?? ""))"
        }
        

        if model.goodsStock == -1{
            lblStock.text="库存充足"
        }else{
            lblStock.text="库存:\(model.goodsStock ?? 0)"

            ///如果库存等于0或者空
            if model.goodsStock == nil || model.goodsStock == 0{
                showGoodStateImgView(name:"to_sell_out")
            }

        }

        lblGoodUnit.text=model.goodUnit

        lblUcode.text="/\(model.ucode ?? "")"

        lblUpice.text="￥\(model.preferentialPrice ?? "0")"

        lblSalesCount.text="销量:\(model.salesCount ?? 0)"

        ///给原价加上 中滑线
        let oldPrice=NSMutableAttributedString(string:"￥\(model.oldPrice ?? "0")")
        oldPrice.addAttribute(NSAttributedStringKey.strikethroughStyle, value:  NSNumber.init(value: Int8(NSUnderlineStyle.styleSingle.rawValue)), range: NSRange.init(location:0, length: oldPrice.length))
        lblOldPrice.attributedText=oldPrice
    }
    ///显示商品状态提示图片 禁止进入商品详情页面 购物车按钮隐藏
    private func showGoodStateImgView(name:String){
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
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
