//
//  GoodClassifyTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/30.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
///2级分类cell
class GoodClassifyTableViewCell: UITableViewCell{
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style:style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.textLabel?.font=UIFont.systemFont(ofSize:13.5)
        self.textLabel?.frame=CGRect.init(x:0, y:0, width:SCREEN_WIDTH, height:50)
        self.textLabel?.textAlignment = .center
    }
    func updateCell(name:String){
        self.textLabel?.text=name
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected{
            self.textLabel?.textColor=UIColor.applicationMainColor()
            self.contentView.backgroundColor=UIColor.white
        }else{
            self.textLabel?.textColor=UIColor.color333()
            self.contentView.backgroundColor=UIColor.viewBgdColor()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
