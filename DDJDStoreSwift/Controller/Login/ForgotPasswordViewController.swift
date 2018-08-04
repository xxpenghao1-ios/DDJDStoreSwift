//
//  ForgotPasswordViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/12.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
////忘记密码
class ForgotPasswordViewController:UIViewController{

    private var vm=ForgotPasswordViewModel()
    //会员账号
    @IBOutlet weak var txtMemberName: UITextField!
    //验证码
    @IBOutlet weak var txtCode: UITextField!
    //密码
    @IBOutlet weak var txtPassword: UITextField!
    //提交按钮
    @IBOutlet weak var btnSubmit: UIButton!
    //边框颜色
    private let borderColor=UIColor.cellBorderColor().cgColor
    //获取验证码按钮
    private var btnGetCode:UIButton!
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated:true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="忘记密码"
        self.view.backgroundColor=UIColor.viewBgdColor()
        setUI()
        bindViewModel()
    }



    private func setUI(){

        btnSubmit.layer.cornerRadius=45/2

        txtMemberName.layer.borderColor=borderColor
        txtMemberName.layer.borderWidth=0.5
        txtMemberName.layer.cornerRadius=5
        txtMemberName.adjustsFontSizeToFitWidth=true;
        txtMemberName.tintColor=UIColor.color999()
        txtMemberName.keyboardType=UIKeyboardType.numberPad
        txtMemberName.font=UIFont.systemFont(ofSize: 14)
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtMemberName.clearButtonMode=UITextFieldViewMode.whileEditing


        //设置验证码
        txtCode.layer.borderColor=borderColor
        txtCode.layer.borderWidth=0.5
        txtCode.layer.cornerRadius=5
        txtCode.font=UIFont.systemFont(ofSize: 14)
        txtCode.adjustsFontSizeToFitWidth=true;
        txtCode.tintColor=UIColor.color999()
        txtCode.keyboardType=UIKeyboardType.numberPad;
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtCode.clearButtonMode=UITextFieldViewMode.whileEditing;


        btnGetCode=UIButton.buildBtn(text:"获取验证码", textColor:.white, font:13,  backgroundColor:UIColor.applicationMainColor(), cornerRadius: 5)

        btnGetCode.frame=CGRect(x:0, y:0, width:80, height:45)
        txtCode.rightView=btnGetCode
        txtCode.rightViewMode = .always

        txtPassword.layer.borderColor=borderColor
        txtPassword.layer.borderWidth=0.5
        txtPassword.layer.cornerRadius=5
        txtPassword.font=UIFont.systemFont(ofSize: 14)
        txtPassword.adjustsFontSizeToFitWidth=true;
        txtPassword.tintColor=UIColor.color999()
        txtPassword.keyboardType=UIKeyboardType.default;
        //不为空，且在编辑状态时（及获得焦点）显示清空按钮
        txtPassword.clearButtonMode=UITextFieldViewMode.whileEditing;

    }
}

extension ForgotPasswordViewController{

    private func bindViewModel(){

        let input=ForgotPasswordViewModel.Input(memberName:txtMemberName.rx.text.orEmpty.asObservable(), pw:txtPassword.rx.text.orEmpty.asObservable(), code:txtCode.rx.text.orEmpty.asObservable(), submitValidate:btnSubmit.rx.tap.asObservable() , codeValidate: btnGetCode.rx.tap.asObservable())

        let outputs = vm.transform(input:input)

        outputs.submitBtnIsDisable.drive(btnSubmit.rx.isDisable).disposed(by:rx_disposeBag)

        ///接收倒计时结果
        outputs.codeTheCountdown.asObservable().subscribe(onNext: { [weak self] (i) in
            if i == 60{
                self?.vm.codePS.onNext(self?.txtMemberName.text ?? "")
                self?.codeBtnTheCountdown()
            }
        }).disposed(by:rx_disposeBag)

        ///结果
        outputs.result.asObservable().subscribe(onNext: { [weak self] (b) in
            if b{
                self?.navigationController?.popViewController(animated:true)
            }
        }).disposed(by:rx_disposeBag)
    }
    ///按钮倒计时
    private func codeBtnTheCountdown(){
        Observable<Int>.timer(0,period:1, scheduler:MainScheduler.instance).take(60).subscribe(onNext: { [weak self] (i) in
            self?.btnGetCode.setTitle("\(60-i)s", for: UIControlState.normal)
            self?.btnGetCode.disable()
            },onCompleted: { [weak self] in
                self?.btnGetCode.setTitle("获取验证码", for: UIControlState.normal)
                self?.btnGetCode.enable()
        }).disposed(by:rx_disposeBag)
    }
}
