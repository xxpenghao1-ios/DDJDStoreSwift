//
//  BrandDB.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/8/13.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import SQLite
///品牌DB
class BrandDB:NSObject{

    static let shared = BrandDB()

    private var db:Connection!

    let table = Table("Brand")

    let id=Expression<Int64>("id")
    ///品牌id
    let brandId=Expression<Int64>("brandId")
    ///品牌名称
    let brandName=Expression<String?>("brandName")

    private override init() {
        super.init()
        self.tableLampCreate()
    }

    ///创建品牌表 如果没有创建
    private func tableLampCreate(){
        do{
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask,true)[0]
            db=try Connection("\(path)/db.sqlite3")
            try self.db.run(table.create(ifNotExists: true, block: { (t) in
                t.column(id, primaryKey:true)
                t.column(brandId)
                t.column(brandName)
            }))
        } catch {
            print("创建数据库失败--\(error)")
        }
    }

//    ///查询所有分类品牌
//    func selectBrandArr() -> [GoodsCategoryModel]{
//        var arr=[GoodsCategoryModel]()
//        do{
//            for value in (try db.prepare("SELECT id, brandId,brandName FROM users")){
//                var model=GoodsCategoryModel()
//                model.brandId=Int(value[brandId])
//                model.brandName=value[brandName]
//                arr.append(model)
//            }
//        }catch{
//            print("查询数据错误--\(error)")
//        }
//        if arr.count == 0{//如果没有数据
////            refreshClassificationData() //重新请求分类数据刷新
//        }
//    }
    ///删除所有品牌数据
    func deleteArr(){
        do{
            try db.run(table.delete())
        }catch{
            print("删除数据错误---\(error)")
        }
    }
}
