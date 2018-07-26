//
//  OrderEvaluationViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/26.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
///订单评价
class OrderEvaluationViewController:BaseViewController{

    ///接收订单id
    var orderInfoId:Int?

    ///接收配送商名称
    var supplierName:String?

    ///订单评分view
    @IBOutlet weak var orderView:SwiftyStarRatingView!

    ///配送评分view
    @IBOutlet weak var distributionView:SwiftyStarRatingView!

    ///业务员评分view
    @IBOutlet weak var salesmanView:SwiftyStarRatingView!

    ///评价输入
    @IBOutlet weak var txtStr:UITextView!

    ///配送商名称
    @IBOutlet weak var lblSupplierName:UILabel!

    ///提交
    @IBOutlet weak var btnSubmit:UIButton!

    override func navigationShouldPopOnBackButton() -> Bool {///返回订单列表页面
        for vc:UIViewController in (self.navigationController?.viewControllers)!{
            if vc.isKind(of:OrderPageViewController.classForCoder()){
                self.navigationController?.popToViewController(vc, animated:true)
                return false
            }
        }
        return true
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="订单评价"
        btnSubmit.layer.cornerRadius=45/2
        lblSupplierName.text=supplierName
        txtStr.placeholder="请输入您的订单评价"
        ///提交评价
        btnSubmit.rx.tap.asObservable().throttle(1, scheduler:MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            self?.submit()
        }).disposed(by:rx_disposeBag)
    }

    ///提交订单
    private func submit(){
        ///订单评分
        let orderScore=Int(orderView.value)

        ///配送评分
        let distributionScore=Int(distributionView.value)

        ///业务员评分
        let userServiceScore=Int(salesmanView.value)

        if txtStr.text.isNil(){
            PHProgressHUD.showInfo("请输入订单评价")
            return
        }
        if txtStr.text.containsEmoji{
            PHProgressHUD.showInfo("不能输入特殊字符")
            return
        }

        if orderScore <= 0{
            PHProgressHUD.showInfo("请选择订单评分")
            return
        }
        if distributionScore <= 0{
            PHProgressHUD.showInfo("请选择配送评分")
            return
        }
        if userServiceScore <= 0{
            PHProgressHUD.showInfo("请选择业务员评分")
            return
        }


        PHRequest.shared.requestJSONObject(target:OrderAPI.storeOrderInfoScore(orderInfoId:orderInfoId ?? 0, orderScore:orderScore, orderEvaluate: txtStr.text, distributionScore: distributionScore, userServiceScore: userServiceScore, storeId:store_Id!)).debug().subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    PHProgressHUD.showSuccess("订单评价提交成功")
                    for vc:UIViewController in (self?.navigationController?.viewControllers)!{
                        if vc.isKind(of:OrderPageViewController.classForCoder()){
                            self?.navigationController?.popToViewController(vc, animated:true)
                        }
                    }
                }else if success == "updateError"{
                    PHProgressHUD.showError("订单已评价,请勿重复评价。")
                }else{
                    PHProgressHUD.showError("评价失败")
                }
                break
            default:
                PHProgressHUD.showError("订单评价提交失败")
                break
            }
        }, onError: { (error) in
            phLog("提交评价出错")
        }).disposed(by:rx_disposeBag)
    }
}
