//
//  ExchangeRecordTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit
///兑换记录cell
class ExchangeRecordTableViewCell: UITableViewCell {

    /// 图片
    @IBOutlet weak var imgGood: UIImageView!
    /// 商品名称
    @IBOutlet weak var lblGoodName: UILabel!
    /// 兑换数量
    @IBOutlet weak var lblCount: UILabel!
    /// 兑换状态
    @IBOutlet weak var lblStatu: UILabel!
    /// 兑换时间
    @IBOutlet weak var lblTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    func updateCell(model:ExchangeRecordModel){
        
        imgGood.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodsPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)
        lblGoodName.text=model.goodsName
        if model.exchangeStatu == 1{
            lblStatu.text="已提交"
        }else if model.exchangeStatu == 2{
            lblStatu.text="已成功"
        }
        if model.exchangeCount != nil{
            lblCount.text="兑换数量:\(model.exchangeCount ?? 1)"
        }
        lblTime.text=model.addTime
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
