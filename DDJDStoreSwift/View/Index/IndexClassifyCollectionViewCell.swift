//
//  IndexClassifyCollectionViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/13.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
///首页商品分类
class IndexClassifyCollectionViewCell:UICollectionViewCell{
    //分类图片
    private lazy var imgView:UIImageView={
        let _imgView=UIImageView()
        return _imgView
    }()
    //分类名称
    private lazy var name:UILabel={
        let _lbl=UILabel.buildLabel(textColor:UIColor.color333(),font:13, textAlignment: NSTextAlignment.center)
        return _lbl

    }()
    override init(frame: CGRect){
        super.init(frame:frame)
        imgView.frame=CGRect(x:10,y: 0,width:frame.size.width-20,height: frame.size.height-20)
        self.contentView.addSubview(imgView);
        name.frame=CGRect(x:0,y:frame.height-20,width: frame.width,height: 20)
        self.contentView.addSubview(name);
    }
    //传入数据
    func updateCell(model:GoodsCategoryModel){

        name.text=model.goodsCategoryName

        imgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodsCategoryIco ?? ""), placeholderImgName:"fl_defualt")

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
