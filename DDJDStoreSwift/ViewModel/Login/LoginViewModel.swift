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
}
///登录VM
extension LoginViewModel:ViewModelType{

    ///输入
    public struct Input{
        ///用户名
        let userName:Observable<String>
        ///密码
        let pw:Observable<String>
        ///登录按钮验证
        let loginValidate:Observable<Void>
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
        ///登录发送网络请求返回状态
        let result=input.loginValidate.withLatestFrom(nameAndPw).flatMapLatest { [weak self] (res)-> Observable<StoreModel> in
                ///验证输入信息是否符合要求
                let bool=self!.validateInputInfo(name:res.0, pw:res.1)
                if bool == true{///如果符合要求 发送网络请求
                    return PHRequest.shared.requestJSONModel(target:LoginAndRegisterAPI.login(memberName:res.0, password:res.1, deviceToken:"penghao", deviceName:"ios", flag:2), model:StoreModel.self)
                }else{///返回失败
                    return Observable<StoreModel>.empty()
                }
            }.map({ (model) -> Bool in
//                if clss model
//                return false
            }).asDriver(onErrorJustReturn:false)
        return Output(result:result)
    }

}
///页面逻辑
extension LoginViewModel{
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
    ///验证登录是否成功
    private func validateLoginIsSuccess(model:StoreModel) -> Bool{
        guard let success=model.success else {
            PHProgressHUD.showError("获取登录信息失败")
            return false
        }
        switch success {
        case "success":
            saveStoreInfo(model:model)
            return true
        case "loginNull":
            PHProgressHUD.showError("该账号不是店铺")
            return false
        case "failds":
            PHProgressHUD.showError("店铺信息不存在")
            return false
        case "isexist":
            PHProgressHUD.showError("账号或密码错误")
            return false
        default:
            PHProgressHUD.showError("登录失败")
            return false
        }
    }
    ///保存店铺信息
    private func saveStoreInfo(model:StoreModel){
        USER_DEFAULTS.set(model.storeId, forKey:"storeId")
        USER_DEFAULTS.synchronize()
    }
}
