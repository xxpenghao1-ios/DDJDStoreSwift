//
//  MyMenuCollectionViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/4.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
///个人中心 菜单cell
class MyMenuCollectionViewCell:UICollectionViewCell {
    private lazy var imgView:UIImageView={
        let _imgView=UIImageView()
        return _imgView
    }()
    private lazy var lblName:UILabel={
        let _lab=UILabel.buildLabel(text:nil, textColor: UIColor.black, font:12, textAlignment:.center)
        return _lab
    }()
    override init(frame: CGRect) {
        super.init(frame:frame)
        imgView.frame=CGRect(x:(self.frame.width-40)/2,y:0,width:40,height:40)
        self.contentView.addSubview(imgView);
        lblName.frame=CGRect(x:0,y:imgView.frame.maxY+5,width:frame.width,height: 20)
        self.contentView.addSubview(lblName);
    }
    //传入数据
    func updateCell(name:String,imgStr:String){
        imgView.image=UIImage.init(named:imgStr)
        lblName.text=name

    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
