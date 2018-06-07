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
        let result=input.validate.withLatestFrom(nameAndPw).flatMapLatest { [weak self] (res)-> Observable<ResponseResult> in
            print(res.0)
            print(res.1)
            return PHRequest.shared.requestJSONData(target:.login(memberName:res.0, password: res.1, deviceToken:"penghao", deviceName:"ios", flag:1))
            }.map { (responseResult) -> Bool in
                switch responseResult{
                case let .success(json):
                    print(json)
                    return true
                case let .faild(message):
                    print(message)
                    return false
                }

        }.asDriver(onErrorJustReturn:false)
        return Output(result:result)
    }
    ///验证用户输入信息
    private func validateInputInfo(name:String,pw:String){
        if name.isNil(){
            PHProgressHUD.showInfo("账号不能为空")
            return
        }
        if !name.validateStrCount(count:11){
            PHProgressHUD.showInfo("请输入正确的手机号码")
            return
        }
        if pw.isNil(){
            PHProgressHUD.showInfo("密码不能为空")
            return
        }
        if pw.count < 6{
            PHProgressHUD.showInfo("亲,密码最少也有6位")
            return
        }

    }
}
