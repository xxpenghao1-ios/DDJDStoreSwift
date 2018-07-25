//
//  VouchersTableViewCell.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/25.
//  Copyright © 2018年 zldd. All rights reserved.
//

import UIKit
import RxSwift
///代金券cell
class VouchersTableViewCell: UITableViewCell {
    ///立即使用
    var immediateUseClosure:(() -> Void)?
    ///代金券金额
    @IBOutlet weak var lblMoney:UILabel!
    ///有效时间
    @IBOutlet weak var lblTime:UILabel!
    ///使用按钮
    @IBOutlet weak var btn:UIButton!
    ///虚线
    @IBOutlet weak var view:UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        btn.layer.cornerRadius=28/2
        drawDashLine(lineView: view,lineLength:3,lineSpacing:2, lineColor: UIColor.RGBFromHexColor(hexString:"e3e3e3"))
        btn.rx.tap.asObservable().throttle(1, scheduler: MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            self?.immediateUseClosure?()
        }).disposed(by:rx_disposeBag)

    }
    func updateCell(model:VouchersModel){
        lblMoney.text=model.cashCouponAmountOfMoney?.description
        lblTime.text=model.cashCouponExpirationDate
        if Int(model.cashCouponExpirationDateInt ?? "0")! <= 0{
            btn.setTitle("已过期", for: UIControlState.normal)
            btn.isEnabled=false
            btn.backgroundColor=UIColor.RGBFromHexColor(hexString:"e3e3e3")
        }else{
            btn.setTitle("立即使用", for: UIControlState.normal)
            btn.backgroundColor=UIColor.applicationMainColor()
            btn.isEnabled=true
        }
    }
    func drawDashLine(lineView : UIView,lineLength : Int ,lineSpacing : Int,lineColor : UIColor){
        let shapeLayer = CAShapeLayer()
        shapeLayer.bounds = lineView.bounds
        //        只要是CALayer这种类型,他的anchorPoint默认都是(0.5,0.5)
        shapeLayer.anchorPoint = CGPoint(x: 0, y: 0)
        shapeLayer.strokeColor = lineColor.cgColor

        shapeLayer.lineWidth = lineView.frame.size.height
        shapeLayer.lineJoin = kCALineJoinRound

        shapeLayer.lineDashPattern = [NSNumber(value: lineLength),NSNumber(value: lineSpacing)]

        let path = CGMutablePath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: lineView.frame.size.width, y: 0))

        shapeLayer.path = path
        lineView.layer.addSublayer(shapeLayer)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
