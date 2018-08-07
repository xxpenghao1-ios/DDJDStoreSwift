//
//  ComplaintsAndSuggestionsViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/23.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
///投诉与建议
class ComplaintsAndSuggestionsViewController:BaseViewController{

    private lazy var txtStr:UITextView={
        let _txt=UITextView(frame: CGRect.init(x:20, y:NAV_HEIGHT+20, width:SCREEN_WIDTH-40, height:150))
        _txt.placeholder="点单即到感谢您的支持，请输入您的建议，内容在10-300字符以内!"
        _txt.placeholderColor=UIColor.color999()
        _txt.textColor=UIColor.color333()
        _txt.tintColor=UIColor.color333()
        _txt.font=UIFont.systemFont(ofSize:15)
        return _txt
    }()
    private lazy var btnSubmit:UIButton={
        let btn=UIButton.buildBtn(text:"提交", textColor: UIColor.priceColor(), font:16, backgroundColor: UIColor.RGBFromHexColor(hexString:"ffe1e9"))
        btn.frame=CGRect.init(x:20, y:txtStr.frame.maxY+20, width: SCREEN_WIDTH-40, height:55)
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets=false
        self.title="投诉与建议"
        self.view.addSubview(txtStr)
        self.view.addSubview(btnSubmit)
        txtStr.rx.text.orEmpty.map{ $0.count >= 10 && $0.count <= 300 }.bind(to:btnSubmit.rx.isDisable).disposed(by:rx_disposeBag)

        btnSubmit.rx.tap.asObservable().throttle(1, scheduler:MainScheduler.instance).subscribe(onNext: { [weak self] (_) in
            self?.submit()
        }).disposed(by:rx_disposeBag)

    }

    private func submit(){

        let str=txtStr.text

        if str!.containsEmoji{
            PHProgressHUD.showInfo("不能包含特殊字符")
            return
        }

        PHProgressHUD.showLoading("正在提交...")

        PHRequest.shared.requestJSONObject(target: MyAPI.complaintsAndSuggestions(complaint:txtStr.text, storeId:store_Id!)).subscribe(onNext: { (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    PHProgressHUD.showSuccess("提交成功")
                    self.navigationController?.popViewController(animated: true)
                }else{
                    PHProgressHUD.showError("提交失败")
                }
                break
            default:break
            }
        }).disposed(by:rx_disposeBag)
    }
}
