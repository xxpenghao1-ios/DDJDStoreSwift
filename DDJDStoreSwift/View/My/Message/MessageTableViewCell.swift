//
//  MessageTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/4.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit

///消息cell
class MessageTableViewCell: UITableViewCell {
    ///消息标题
    @IBOutlet weak var lblTitle: UILabel!
    ///消息时间
    @IBOutlet weak var lblTime: UILabel!
    ///消息内容
    @IBOutlet weak var lblMessContent: UILabel!
    ///查看详情
    @IBOutlet weak var btnPushDetail: UIButton!

    @IBOutlet weak var view:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        self.contentView.backgroundColor=UIColor.viewBgdColor()
        view.layer.cornerRadius=8
        view.clipsToBounds=true
        btnPushDetail.setTitleColor(UIColor.RGBFromHexColor(hexString:"ff1261"), for: UIControlState.normal)
    }
    func updateCell(model:MessageModel){
        lblTitle.text=model.messTitle
        lblTime.text=model.messAddTime
        lblMessContent.text=model.messContent
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
