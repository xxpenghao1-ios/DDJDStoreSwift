//
//  IndexNewGoodView.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/29.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
///首页新品view 旋转木马用
class IndexNewGoodViews:UIView{
    init(frame: CGRect,modelArr:[NewGoodModel]) {
        super.init(frame:frame)
        self.backgroundColor=UIColor.white
        //加上阴影效果
        self.layer.shadowOpacity = 0.8
        self.layer.shadowColor = UIColor.applicationMainColor().cgColor
        self.layer.shadowOffset = CGSize(width: 1, height: 1)
        ///每个新品商品宽度
        let width=(SCREEN_WIDTH-68)/3
        var viewX:CGFloat=7
        for i in 0..<modelArr.count{
            if i > 2{
                return
            }
            let view=IndexNewGoodView(frame:CGRect.init(x:viewX,y:7, width:width, height:self.frame.height-14))
            view.setModel(model:modelArr[i])
            self.addSubview(view)
            viewX+=width+7
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class IndexNewGoodView:UIView{
    ///商品图片
    private lazy var imgView:UIImageView={
        let _imgView=UIImageView()
        return _imgView
    }()
    ///商品名称
    private lazy var lblGoodName:UILabel={
        let _lbl=UILabel.buildLabel(textColor:UIColor.color333(), font:13)
        _lbl.numberOfLines=2
        _lbl.lineBreakMode = .byWordWrapping
        return _lbl
    }()
    ///商品价格
    private lazy var lblGoodPrice:UILabel={
        let _lbl=UILabel.buildLabel(textColor:UIColor.priceColor(),font:16)
        _lbl.textAlignment = .center
        return _lbl
    }()

    override init(frame: CGRect) {
        super.init(frame:frame)
        self.layer.borderWidth=1
        self.layer.borderColor=UIColor.borderColor().cgColor
        setUI()
    }
    private func setUI(){

        imgView.frame=CGRect.init(x:0,y:0, width:self.frame.width, height:self.frame.width)
        self.addSubview(imgView)

        lblGoodName.frame=CGRect.init(x:5,y:imgView.frame.maxY, width:self.frame.width-10,height:35)
        self.addSubview(lblGoodName)

        lblGoodPrice.frame=CGRect.init(x:0,y:lblGoodName.frame.maxY, width:self.frame.width,height:25)
        self.addSubview(lblGoodPrice)

    }
    func setModel(model:NewGoodModel){
        imgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)

        lblGoodName.text=model.goodInfoName

        lblGoodPrice.text="￥"+(model.uprice ?? "0")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
