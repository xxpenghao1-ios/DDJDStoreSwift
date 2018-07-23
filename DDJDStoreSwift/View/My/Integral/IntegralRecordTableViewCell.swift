//
//  IntegralRecordTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
///积分记录cell
class IntegralRecordTableViewCell:UITableViewCell{

    private lazy var lblName:UILabel={
        let _lbl=UILabel.buildLabel(textColor:UIColor.color333(), font:15)
        return _lbl
    }()

    private lazy var lblTime:UILabel={
        let _lbl=UILabel.buildLabel(textColor:UIColor.color999(), font:13)
        return _lbl
    }()

    private lazy var lblIntegral:UILabel={
        let _lbl=UILabel.buildLabel(textColor:UIColor.color666(), font:14)
        _lbl.textAlignment = .right
        return _lbl
    }()
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(lblName)
        self.contentView.addSubview(lblTime)
        self.contentView.addSubview(lblIntegral)
        lblName.frame=CGRect(x:15, y:15, width:300, height:20)
        lblTime.frame=CGRect(x:15, y:40, width:300, height:20)
        lblIntegral.frame=CGRect(x:15,y:(75-20)/2, width:SCREEN_WIDTH-30, height:20)
    }
    func updateCell(model:IntegralRecordModel){
        lblTime.text=model.time
        lblIntegral.text=model.integral
        switch model.integralType ?? 0{
        case 1:
            lblName.text="发货扣除点单币"
            break
        case 2:
            lblName.text="充值"
            break
        case 3:
            lblName.text="购物返还点单币"
            break
        case 4:
            lblName.text="兑换商品扣除点单币"
        default:
            lblName.text="异常数据"
            break
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

