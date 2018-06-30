//
//  ClassifyCollectionViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/30.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
///3级分类 cell
class ClassifyCollectionViewCell:UICollectionViewCell{
    private lazy var imgView:UIImageView={
        let _imgView=UIImageView()
        return _imgView
    }()
    private lazy var lblName:UILabel={
        let _lab=UILabel.buildLabel(text:nil, textColor: UIColor.black, font:12, textAlignment:.center)
        _lab.numberOfLines=2
        _lab.lineBreakMode = .byWordWrapping
        return _lab
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        imgView.frame=CGRect.init(x:15, y:0, width:self.frame.width-30, height:self.frame.width-30)
        self.contentView.addSubview(imgView)
        lblName.frame=CGRect.init(x:2, y:imgView.frame.maxY+2,width:self.frame.width-4, height:40)
        self.contentView.addSubview(lblName)
    }
    func updateCell(model:GoodsCategoryModel){
        lblName.text=model.goodsCategoryName
        imgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodsCategoryIco ?? ""), placeholderImgName:"fl_defualt")
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
