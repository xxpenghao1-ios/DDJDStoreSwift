//
//  SpecialGoodTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/10.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit
import RxSwift

/**
 计算剩余时间

 - parameter seconds: 秒

 - returns: 字符串
 */
func lessSecondToDay(_ seconds:Int) -> String{
    let day=seconds/(24*3600)
    let hour=(seconds%(24*3600))/3600
    let min=(seconds%(3600))/60
    let second=(seconds%60)
    var time:NSString=""
    if seconds >= 0{
        if day == 0{//如果天数等于0
            time=NSString(format:"剩余时间:%i小时%i分钟%i秒",hour,min,second)
            if hour == 0{
                time=NSString(format:"剩余时间:%i分钟%i秒",min,second)
                if min == 0{
                    time=NSString(format:"剩余时间:%i秒",second)
                    if seconds == 0{
                        return "活动已结束"
                    }
                }
            }
        }else{
            time=NSString(format:"剩余时间:%i日%i小时%i分钟%i秒",day,hour,min,second)
        }
    }else{
        return "活动已结束"
    }
    return time as String
}
///特价cell
class SpecialGoodTableViewCell: UITableViewCell {
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
    ///商品原价
    @IBOutlet weak var lblOldPrice:UILabel!
    ///商品销量
    @IBOutlet weak var lblSalesCount:UILabel!
    ///商品库存
    @IBOutlet weak var lblStock:UILabel!
    ///加入购物车
    @IBOutlet weak var btnAddCar:UIButton!
    ///活动剩余时间
    @IBOutlet weak var lblEndTime:UILabel!
    ///商品状态图片  已售罄/活动已结束
    @IBOutlet weak var goodStateImgView:UIImageView!
    ///行索引
    var index:Int?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        ///默认隐藏
        goodStateImgView.isHidden=true
        ///点击图片跳转页面
        imgView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(pushGoodDetail)))
        ///加入购物车
        btnAddCar.addTarget(self, action:#selector(addCar), for: UIControlEvents.touchUpInside)
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

        lblStock.text="库存:\(model.goodsStock ?? 0)"
        ///如果库存等于0或者空
        if model.goodsStock == nil || model.goodsStock == 0{
            showGoodStateImgView(name:"to_sell_out")
        }

        lblGoodUnit.text=model.goodUnit

        lblUcode.text="/\(model.ucode ?? "")"

        lblUpice.text="￥\(model.preferentialPrice ?? "0")"

        lblSalesCount.text="销量:\(model.salesCount ?? 0)"

        ///给原价加上 中滑线
        let oldPrice=NSMutableAttributedString(string:"￥\(model.oldPrice ?? "0")")
        oldPrice.addAttribute(NSAttributedStringKey.strikethroughStyle, value:  NSNumber.init(value: Int8(NSUnderlineStyle.styleSingle.rawValue)), range: NSRange.init(location:0, length: oldPrice.length))
        lblOldPrice.attributedText=oldPrice

        let times=model.endTime?.components(separatedBy:".")
        if times != nil && Int(times![0]) > 0{///特价时间不为空
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
