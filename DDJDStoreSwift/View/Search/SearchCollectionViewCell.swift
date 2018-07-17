//
//  SearchCollectionViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/16.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation

class SearchSectionHeader:UICollectionReusableView {
    var label:UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        //背景设为黑色
        self.backgroundColor = UIColor.clear
        //创建文本标签
        label = UILabel(frame:CGRect(x:15,y:15,width:200,height:20))
        label.textColor = UIColor.black
        label.font=UIFont.systemFont(ofSize:15)
        label.textAlignment = .left
        self.addSubview(label)
        
    }
    func updateCell(str:String){
        label.text=str
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        label = UILabel(frame:CGRect(x:15, y:0,width:200, height:20))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
/// 搜索cell
class SearchCollectionViewCell:UICollectionViewCell{

    private var lblName:UILabel!

    override init(frame: CGRect) {
        super.init(frame:frame)
        lblName=UILabel.buildLabel(textColor: UIColor.color333(),font:14, textAlignment: NSTextAlignment.center)
        self.contentView.addSubview(lblName)
        self.contentView.layer.cornerRadius=35/2
        self.contentView.backgroundColor=UIColor.white
        lblName.snp.makeConstraints { (make) in
            make.left.equalTo(self.contentView.snp.left)
            make.top.equalTo(7.5)
            make.height.equalTo(20)
            make.right.equalTo(self.contentView.snp.right)
        }
    }
    /**
     更新cell

     - parameter str:
     */
    func updateCell(str:String?){
        if str == "清除"{
            self.contentView.backgroundColor=UIColor.applicationMainColor()
            lblName.textColor=UIColor.white
            lblName.textAlignment = .center
        } else if str == "搜索历史" || str == "品牌推荐"{
            lblName.textColor = UIColor.black
            lblName.font=UIFont.systemFont(ofSize:15)
            lblName.textAlignment = .left
            self.contentView.backgroundColor=UIColor.clear
        }else{
            lblName.textAlignment = .center
            lblName.textColor=UIColor.color333()
            lblName.font=UIFont.systemFont(ofSize:14)
            self.contentView.backgroundColor=UIColor.white
        }
        lblName.text=str
    }
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let attributes=super.preferredLayoutAttributesFitting(layoutAttributes)
        let str=lblName.text
        if str == "" || str == nil{
            frame.size.height=35
            frame.size.width=1
            attributes.frame=frame
        }else{
            if str == "搜索历史" || str == "品牌推荐"{
                frame.size.height=35
                frame.size.width=SCREEN_WIDTH-50
                attributes.frame=frame
            }else{
                let size=str!.textSizeWithFont(font:lblName.font, constrainedToSize:CGSize(width:500, height:35))
                frame.size.height=35
                frame.size.width=size.width+40
                attributes.frame=frame
            }
        }
        return attributes
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
