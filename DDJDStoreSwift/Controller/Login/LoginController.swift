//
//  LoginController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/26.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
///登录页面
class LoginController:BaseViewController{
    private let viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="登录"
        loadViewlayout()
        bindViewModel()

    }
    ///绑定VM
    private func bindViewModel() {
        let input = LoginViewModel.Input(userName:txtMemberName.rx.text.orEmpty.asObservable(), pw: txtPW.rx.text.orEmpty.asObservable(), validate:btnLogin.rx.tap.asObservable())
        let outputs = viewModel.transform(input:input)
        outputs.result.drive(onNext: { (b) in
            if b{
                print("跳转页面")
            }else{
                print("不跳转页面")
            }
        }, onCompleted:nil,onDisposed:nil) .disposed(by:rx_disposeBag)
    }
    ///包含登录页面所有控件view
    lazy var loginView:UIView={
        let view=UIView()
        view.addSubview(topImg)
        view.addSubview(txtMemberName)
        view.addSubview(txtMemberNameDividingLine)
        view.addSubview(txtPW)
        view.addSubview(txtPwDividingLine)
        view.addSubview(lblForgetassword)
        view.addSubview(btnLogin)
        view.addSubview(btnRegister)
        return view
    }()
    ///默认图像img
    lazy var topImg:UIImageView={
        let img=UIImageView()
        img.image=UIImage.init(named:"login_top_img")
        return img
    }()
    ///用户名输入框
    lazy var txtMemberName:UITextField={
        let txt=UITextField.buildTxt(font:18, placeholder:"请输入手机号码", tintColor: UIColor.black, keyboardType: UIKeyboardType.namePhonePad)
        txt.leftView=setLeftView(str:"memberName")
        txt.leftViewMode=UITextFieldViewMode.always;
        return txt
    }()
    ///分割线
    lazy var txtMemberNameDividingLine:UIView={
        let view=UIView()
        view.backgroundColor=UIColor.RGBFromHexColor(hexString:"ebebeb")
        return view
    }()
    ///密码输入框
    lazy var txtPW:UITextField={
        let txt=UITextField.buildTxt(font:18, placeholder:"请输入密码", tintColor: UIColor.black,keyboardType:UIKeyboardType.default)
        txt.isSecureTextEntry=true
        txt.leftView=setLeftView(str:"pw")
        txt.leftViewMode=UITextFieldViewMode.always;
        return txt
    }()
    ///分割线
    lazy var txtPwDividingLine:UIView={
        let view=UIView()
        view.backgroundColor=UIColor.RGBFromHexColor(hexString:"ebebeb")
        return view
    }()
    ///忘记密码
    lazy var lblForgetassword:UILabel={
        let lbl=UILabel.buildLabel(text:"忘记密码?",textColor:UIColor.color666(), font:27/2, textAlignment: NSTextAlignment.right)
        return lbl
    }()
    ///登录按钮
    lazy var btnLogin:UIButton={
        let btn=UIButton.buildBtn(text:"登录", textColor: UIColor.white, font:18, backgroundColor: UIColor.RGBFromHexColor(hexString:"ff1261"), cornerRadius:10)
        btn.addTarget(self, action:#selector(login), for: UIControlEvents.touchUpInside)
        return btn
    }()
    ///注册按钮
    lazy var btnRegister:UIButton={
        let btn=UIButton.buildBtn(text:"注册", textColor:UIColor.color666(),font:18, backgroundColor: UIColor.clear, cornerRadius:10)
        btn.layer.borderWidth=1
        btn.layer.borderColor=UIColor.RGBFromHexColor(hexString:"d2d2d2").cgColor
        return btn
    }()

    ///设置输入框左视图
    private func setLeftView(str:String) -> UIView{
        let leftView=UIView(frame:CGRect.init(x:0, y:0, width:30, height:30))
        let img=UIImageView.init(frame: CGRect.init(x:0,y:(30-46/2)/2, width:35/2, height:46/2))
        img.image=UIImage(named:str)
        leftView.addSubview(img)
        return leftView
    }
    @objc private func login(){
//        PHRequest.shared.requestDataWithTargetJSON(target:LoginAndRegisterAPI.login(memberName: "17607319949", password:"123456" , deviceToken:"penghao", deviceName:"ios", flag: 1), successClosure: { (r) in
//            print(r.description)
//        }) { (error) in
//            print(error)
//        }
    }
}
///页面布局
extension LoginController{
    ///加载页面
    private func loadViewlayout(){
        self.view.addSubview(self.loginView)
        loginView.snp.makeConstraints { (make) in
            make.width.equalTo(SCREEN_WIDTH-115)
            make.left.equalTo(115/2)
            make.top.equalTo(NAV_HEIGHT)
        }
        topImg.snp.makeConstraints { (make) in
            make.width.height.equalTo(120)
            make.centerX.equalTo(loginView)
            make.top.equalTo(0)
        }
        txtMemberName.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(30)
            make.top.equalTo(topImg.snp.bottom).offset(45/2)
        }
        txtMemberNameDividingLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(1)
            make.top.equalTo(txtMemberName.snp.bottom).offset(45/2)
        }
        txtPW.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(30)
            make.top.equalTo(txtMemberNameDividingLine.snp.bottom).offset(45/2)
        }
        txtPwDividingLine.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(1)
            make.top.equalTo(txtPW.snp.bottom).offset(45/2)
        }
        lblForgetassword.snp.makeConstraints { (make) in
            make.width.equalTo(loginView)
            make.height.equalTo(20)
            make.right.equalTo(0)
            make.top.equalTo(txtPwDividingLine).offset(25)
        }
        btnLogin.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(50)
            make.top.equalTo(lblForgetassword.snp.bottom).offset(20)
        }
        btnRegister.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(50)
            make.top.equalTo(btnLogin.snp.bottom).offset(20)
            make.bottom.equalTo(10)
        }
    }
}
