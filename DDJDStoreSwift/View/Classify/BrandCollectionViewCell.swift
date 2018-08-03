//
//  BrandCollectionViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/8/3.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
///品牌cell
class BrandCollectionViewCell:UICollectionViewCell{

    private var lblName:UILabel!

    var pushGoodListClosure:(() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        lblName=UILabel.buildLabel(textColor:UIColor.RGBFromHexColor(hexString:"414141"),font:15, textAlignment:.center)
        lblName!.frame=self.contentView.frame
        self.contentView.backgroundColor=UIColor.RGBFromHexColor(hexString:"ebebeb")
        self.contentView.addSubview(lblName)
        self.contentView.isUserInteractionEnabled=true
        self.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(pushGoodListVC)))

    }
    @objc private func pushGoodListVC(){
        pushGoodListClosure?()
    }
    func updateCell(name:String?){
        lblName.text=name
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
