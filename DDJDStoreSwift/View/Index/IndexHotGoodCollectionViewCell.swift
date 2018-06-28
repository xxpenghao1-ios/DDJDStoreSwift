//
//  IndexHotGoodCollectionViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
///热门商品
class IndexHotGoodCollectionViewCell:UICollectionViewCell{

    ///商品图片
    private lazy var imgView:UIImageView={
        let _imgView=UIImageView()
        return _imgView
    }()
    ///商品名称
    private lazy var lblGoodName:UILabel={
        let _lbl=UILabel.buildLabel(textColor:UIColor.color333(), font: 14)
        _lbl.numberOfLines=2
        _lbl.lineBreakMode = .byWordWrapping
        return _lbl
    }()
    ///商品价格
    private lazy var lblGoodPrice:UILabel={
        let _lbl=UILabel.buildLabel(textColor:UIColor.priceColor(),font:19)
        return _lbl
    }()
    ///加入购物车
    lazy var btnAddCar:UIButton={
        let _btn=UIButton.buildBtn(text:"加入购物车", textColor: UIColor.priceColor(), font:10, backgroundColor: UIColor.RGBFromHexColor(hexString:"ffe1e9"), cornerRadius:25/2)
        return _btn
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        self.contentView.backgroundColor=UIColor.white
        setUI()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    ///更新cell
    func updateCell(model:HotGoodModel){

        imgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)
        
        lblGoodName.text=model.goodInfoName

        lblGoodPrice.text="￥"+(model.uprice ?? "0")
    }
}
extension IndexHotGoodCollectionViewCell{

    private func setUI(){

        imgView.frame=CGRect.init(x:10, y:10, width:self.frame.width-20, height:self.frame.width-20)
        self.contentView.addSubview(imgView)

        lblGoodName.frame=CGRect.init(x:5, y:imgView.frame.maxY+10, width:imgView.frame.width-10, height:40)
        self.contentView.addSubview(lblGoodName)

        lblGoodPrice.frame=CGRect.init(x:5, y:lblGoodName.frame.maxY, width:(self.frame.width-10)/2,height:25)
        self.contentView.addSubview(lblGoodPrice)

        btnAddCar.frame=CGRect.init(x:self.frame.width-87,y: lblGoodName.frame.maxY, width:80, height: 25)
        self.contentView.addSubview(btnAddCar)

    }
}
