//
//  MyOrderCollectionViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/3.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxGesture
///个人中心  订单视图cell
class MyOrderCollectionViewCell:UICollectionViewCell{

    private lazy var centerView:UIView={
        return UIView()
    }()

    private lazy var imgView:UIImageView={
        let _imgView=UIImageView()
        return _imgView
    }()

    private lazy var lblName:UILabel={
        let _lbl=UILabel.buildLabel(textColor:UIColor.color333(),font:13)
        _lbl.textAlignment = .center
        return _lbl
    }()
    var pushOrderClosure:(() -> Void)?
    override init(frame: CGRect) {
        super.init(frame:frame)

        centerView.frame=CGRect.init(x:0,y:35/2,width:frame.width,height:60)

        imgView.frame=CGRect.init(x:(centerView.frame.width-35)/2, y:0, width:35, height:35)

        lblName.frame=CGRect.init(x:0, y:imgView.frame.maxY+5,width:centerView.frame.width,height:20)


        centerView.addSubview(imgView)
        centerView.addSubview(lblName)

        self.contentView.addSubview(centerView)

        centerView.rx.tapGesture().when(.recognized).subscribe(onNext: { [weak self] (_) in
            self?.pushOrderClosure?()
        }).disposed(by:rx_disposeBag)

    }
    func updateCell(name:String,imgStr:String,orderCountModel:OrderCountModel?=nil){

        if orderCountModel == nil{
            imgView.clearBadge()
        }else{
            if orderCountModel!.orderStatus == 3{//已完成隐藏订单数量
                imgView.clearBadge()
            }else{
                imgView.showBadge(with: WBadgeStyle.number, value:orderCountModel!.orderSum ?? 0,animationType: WBadgeAnimType.none)
            }
        }
        imgView.image=UIImage.init(named:imgStr)
        lblName.text=name
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
