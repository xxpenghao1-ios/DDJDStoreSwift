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
struct LoginViewModel:ViewModelType{
    let input:Input
    let output:Output
    ///输入
    struct Input{
        let hudInfo=HUDInfo(hudType: HUDType.loading)
        let userName:AnyObserver<String>
        let pw:AnyObserver<String>
        let validate:AnyObserver<Void>
    }
    struct Output {
        let greeting:Driver<Bool>
    }
    private let nameSubject = ReplaySubject<String>.create(bufferSize: 1)
    private let validateSubject = PublishSubject<Void>()
//    init() {
//
//    }
}
