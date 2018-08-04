//
//  ForgotPasswordViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
///忘记密码
class ForgotPasswordViewModel:NSObject{

    ///保存验证码
    private var code=BehaviorRelay<String?>(value:nil)

    var codePS=PublishSubject<String>()
}

extension ForgotPasswordViewModel:ViewModelType{
    
    func transform(input:Input) -> Output {

        ///获取验证码
        codePS.subscribe(onNext: { [weak self] (memberName) in
            self?.getCode(memberName:memberName)
        }).disposed(by:rx_disposeBag)


        ///提交按钮是否可以点击
        let submitBtnIsDisable=Observable.combineLatest(input.memberName,input.pw,input.code).map{ $0.count == 11 && $1.count >= 6 && $2.count > 0 }.share(replay:1, scope:.whileConnected).asDriver(onErrorJustReturn:false)



        ///倒计时  60开始到计时
        let codeTheCountdown=input.codeValidate.throttle(2, scheduler: MainScheduler.instance).withLatestFrom(input.memberName).filter({ (memberName) -> Bool in
            if memberName.count == 11{
                return true
            }else{
                PHProgressHUD.showInfo("请输入正确的手机号码")
                return false
            }
        }).flatMapLatest { (memberName)-> Observable<ResponseResult> in
            PHProgressHUD.showLoading("正在验证账号是否存在...")
            ///发送网络请求返回结果
            return PHRequest.shared.requestJSONObject(target: LoginAndRegisterAPI.doMemberTheOnly(memberName:memberName))
            }.map { (result) -> Int in
                switch result{
                case let .success(json:json):
                    let success=json["success"].stringValue
                    if success == "success"{
                        return 60
                    }else{
                        PHProgressHUD.showError("账号不存在")
                        return 0
                    }
                default:return 0
                }
            }.asDriver(onErrorJustReturn:0)

        ///合并成1个Observable
        let observables=Observable.combineLatest(input.memberName,input.pw,input.code) { ($0, $1, $2) }
        ///返回结果
        let result=input.submitValidate.throttle(1, scheduler: MainScheduler.instance).withLatestFrom(observables).filter { [weak self] in
                if $2 != self?.code.value{
                    PHProgressHUD.showError("验证码输入错误")
                    return false
                }
                return true
            }.flatMapLatest { (res)-> Observable<ResponseResult> in
                PHProgressHUD.showLoading("请稍后...")
                ///发送网络请求返回结果
                return PHRequest.shared.requestJSONObject(target: LoginAndRegisterAPI.updatePassWord(memberName:res.0, newPassWord: res.1))
            }.map { (result) -> Bool in
                switch result{
                case let .success(json):
                    let success=json["success"].stringValue
                    if success == "success"{
                        PHProgressHUD.showSuccess("设置密码成功,请重新登录")
                        return true
                    }else{
                        PHProgressHUD.showError("设置密码失败")
                        return false
                    }
                default:return false
                }
            }.asDriver(onErrorJustReturn:false)
        return Output(result:result, submitBtnIsDisable:submitBtnIsDisable, codeTheCountdown:codeTheCountdown)
    }

    ///获取验证码
    private func getCode(memberName:String){
        PHRequest.shared.requestJSONObject(target:LoginAndRegisterAPI.returnRandCode(memberName:memberName, flag:"updatePassword")).subscribe(onNext: { [weak self] (result) in
            switch result{
            case let .success(json:json):
                let success=json["success"].stringValue
                if success == "success"{
                    let code=json["randCode"].stringValue
                    self?.code.accept(code)
                }else{
                    PHProgressHUD.showError("获取验证码失败")
                }
                break
            default:break
            }

        }).disposed(by:rx_disposeBag)
    }
    ///输入
    public struct Input{
        ///用户名
        let memberName:Observable<String>
        ///密码
        let pw:Observable<String>
        ///验证码
        let code:Observable<String>
        ///submit按钮验证
        let submitValidate:Observable<Void>
        ///验证码按钮验证
        let codeValidate:Observable<Void>
    }
    ///输出
    struct Output {
        ///true成功返回登录页面  false修改失败
        let result:Driver<Bool>
        ///提交按钮是否禁用  false禁用 true不禁用
        let submitBtnIsDisable:Driver<Bool>
        ///验证码倒计时
        let codeTheCountdown:Driver<Int>
        init(result:Driver<Bool>,submitBtnIsDisable:Driver<Bool>,codeTheCountdown:Driver<Int>) {
            self.result=result
            self.submitBtnIsDisable=submitBtnIsDisable
            self.codeTheCountdown=codeTheCountdown

        }
    }

}
