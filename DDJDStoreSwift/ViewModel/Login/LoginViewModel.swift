//
//  LoginViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/4/28.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
///登录VM
class LoginViewModel:NSObject{
    ///默认页面加载不响应
    let hudInfo=HUDInfo(hudType: HUDType.loading)
}
///登录VM
extension LoginViewModel:ViewModelType{

    ///输入
    public struct Input{
        let userName:Observable<String>
        let pw:Observable<String>
        let validate:Observable<Void>
    }
    ///输出
    struct Output {
        ///true登录成功跳转页面  false登录失败
        let result:Driver<Bool>
        init(result:Driver<Bool>) {
            self.result=result
        }
    }
    func transform(input: Input) -> Output {
        ///合并成1个Observable
        let nameAndPw=Observable.combineLatest(input.userName,input.pw) { ($0, $1) }
        ///发送网络请求返回状态
        let result=input.validate.withLatestFrom(nameAndPw).flatMapLatest { [weak self] in
                let b=self?.validateInputInfo(name:res.0,pw:res.1)
                if b == false{//如果验证不通过直接返回false不发送网络请求
                    
                }else{//发送网络请求
                    return PHRequest.shared.requestJSONData(target:LoginAndRegisterAPI.login(memberName:$0.0, password:$0.1, deviceToken:"", deviceName:"", flag:1), hudInfo:self?.hudInfo)
                }
            }.map { (responseResult) -> Bool in
                switch responseResult{
                case let .success(json):
                    return true
                case let .faild(message):
                    return false
                }

        }
        return Output(result:result)
    }
    ///验证用户输入信息
    private func validateInputInfo(name:String,pw:String) -> Bool{
        if name.isNil(){
            PHProgressHUD.showInfo("账号不能为空")
            return false
        }
        if !name.validateStrCount(count:11){
            PHProgressHUD.showInfo("请输入正确的手机号码")
            return false
        }
        if pw.isNil(){
            PHProgressHUD.showInfo("密码不能为空")
            return false
        }
        if pw.count < 6{
            PHProgressHUD.showInfo("亲,密码最少也有6位")
            return false
        }
        return true
    }
}
