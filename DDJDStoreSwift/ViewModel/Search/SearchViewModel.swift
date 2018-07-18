//
//  SearchViewModel.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/16.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxCocoa
import RxDataSources
import RxSwift
///搜索vm
class SearchViewModel:NSObject{

    ///保存品牌推荐信息
    private var allSystemBrandBR=BehaviorRelay<[GoodsCategoryModel]>(value:[])

    ///保存缓存中的搜索记录
    private var searchArrBR=BehaviorRelay<[String]>(value:[])

    ///搜索记录和品牌推荐  分2组信息
    var allBrandAndSearchStrBR=BehaviorRelay<[SectionModel<String,GoodsCategoryModel>]>(value:[])

    ///发送网络请求
    var requestNewDataCommond = PublishSubject<Bool>()

    ///添加搜索信息
    var addSearchStr=PublishSubject<String?>()

    ///删除所有的搜索信息
    var deleteSearchStr=PublishSubject<Bool>()

    ///跳转到商品页面
    var pushGoodList=PublishSubject<String?>()
    override init() {
        super.init()

        requestNewDataCommond.subscribe(onNext: { [weak self] (b) in
            if b{
                self?.getAllSystemBrand()
            }
        }).disposed(by:rx_disposeBag)

        ///添加搜索信息
        addSearchStr.subscribe(onNext: { [weak self] (str) in
            self?.setSearchStr(str:str)
        }).disposed(by:rx_disposeBag)



        ///订阅allSystemBrandBR
        allSystemBrandBR.asObservable().subscribe(onNext: { [weak self] (arr) in
            ///传入已经获取好的品牌数据
            self?.updateAllBrandAndSearchStrBR(arr:arr)

        }).disposed(by:rx_disposeBag)

        ///订阅 searchArrBR 每次添加新搜索记录都会执行
        searchArrBR.asObservable().subscribe({ (_) in
            weak var weakSelf=self
            if weakSelf == nil{
                return
            }
            ///传入已经获取好的品牌数据
            weakSelf!.updateAllBrandAndSearchStrBR(arr:weakSelf!.allSystemBrandBR.value)
        }).disposed(by:rx_disposeBag)

        ///删除所有搜索信息
        deleteSearchStr.asObservable().subscribe(onNext: { [weak self] (_) in
            //删除搜索记录
            USER_DEFAULTS.removeObject(forKey:"searchStrArr")
            //写入磁盘
            USER_DEFAULTS.synchronize();
            ///修改页面数据
            self?.searchArrBR.accept([])
        }).disposed(by:rx_disposeBag)
    }
    ///更新数据源
    private func updateAllBrandAndSearchStrBR(arr:[GoodsCategoryModel]){
        let searchArrStr=getGoodsCategoryModelArr()
        if searchArrStr.count == 0 && arr.count == 0{///推荐品牌为空  搜索记录为空
            allBrandAndSearchStrBR.accept([])
        }else{
            if searchArrStr.count == 0{//如果搜索记录为0 不显示搜索历史
                allBrandAndSearchStrBR.accept([SectionModel.init(model:"品牌推荐",items:arr)])
            }else if arr.count == 0{//如果品牌推荐数据为0 不显示品牌推荐
                allBrandAndSearchStrBR.accept([SectionModel.init(model:"搜索历史",items:searchArrStr)])

            }else{
                allBrandAndSearchStrBR.accept([SectionModel.init(model:"搜索历史", items:getGoodsCategoryModelArr()),SectionModel.init(model:"品牌推荐",items:arr)])
            }
        }
    }
}

extension SearchViewModel{
    ///获取推荐品牌
    private func  getAllSystemBrand(){
        weak var weakSelf=self
        if weakSelf == nil{
            return
        }
        PHRequest.shared.requestJSONArrModel(target:ClassifyAPI.queryAllSystemBrand(), model:GoodsCategoryModel.self).subscribe(onNext: { (arr) in
            var modelArr=arr
            if  arr.count > 0{
                var model=GoodsCategoryModel()
                model.brandName="品牌推荐"
                modelArr.insert(model,at:0)
            }
            weakSelf!.allSystemBrandBR.accept(modelArr)
        }, onError: { (error) in
            weakSelf!.allSystemBrandBR.accept([])
            phLog("获取推荐品牌失败\(error.localizedDescription)")
        }).disposed(by:rx_disposeBag)
    }
    ///把搜索数组 转换成分类品牌model
    private func getGoodsCategoryModelArr() -> [GoodsCategoryModel]{
        ///获取缓存中的搜索信息
        let searchArr=USER_DEFAULTS.object(forKey:"searchStrArr") as? [String] ?? [String]()
        if searchArr.count == 0{
            return []
        }

        var arr=[GoodsCategoryModel]()
        ///默认加一个搜索历史
        var titleModel=GoodsCategoryModel()
        titleModel.brandName="搜索历史"
        arr.append(titleModel)
        for str in searchArr{///把缓存中每一条记录都修改为品牌名称
            var model=GoodsCategoryModel()
            model.brandName=str
            arr.append(model)
        }
        var model=GoodsCategoryModel()
        model.brandName="清除"
        arr.append(model)
        return arr
    }
    ///添加搜索信息
    private func setSearchStr(str:String?){
        ///去掉所有空格
        let string=str?.removeAllSapce
        if string == nil || string!.isNil(){
            PHProgressHUD.showError("搜索条件不能为空")
            return
        }else{
            if string!.containsEmoji{
                PHProgressHUD.showError("不能包含特殊字符")
                return
            }
        }
        ///获取缓存中的搜索信息
        var searchArr=USER_DEFAULTS.object(forKey:"searchStrArr") as? [String] ?? [String]()
        ///添加信息的搜索记录
        searchArr.append(string!)
        //数组去重
        let arr=searchArr.filterDuplicates({$0})
        //保存进缓存
        USER_DEFAULTS.set(arr,forKey:"searchStrArr")
        //写入磁盘
        USER_DEFAULTS.synchronize();
        ///添加到缓存成功  修改页面数据
        searchArrBR.accept(arr)
        ///发送跳转页面消息
        pushGoodList.onNext(string)
    }
}
