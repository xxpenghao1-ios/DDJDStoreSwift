//
//  ClassifyViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/30.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
///分类
class ClassifyViewController:BaseViewController {

    ///接收1级分类id
    var goodsCategoryId:Int?

    ///2级分类table
    @IBOutlet weak var table:UITableView!

    ///3级分类
    @IBOutlet weak var collection:UICollectionView!

    ///VM
    private var vm=ClassifyViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="按品项"
        self.view.backgroundColor=UIColor.viewBgdColor()
        collection.emptyDataSetDelegate=self
        collection.emptyDataSetSource=self
        self.emptyDataSetTextInfo="暂时木有相关分类"
        vm.goodsCategoryId=goodsCategoryId
        setUI()
        bindViewModel()
    }
    
}

extension ClassifyViewController:Refreshable{
    ///绑定VM
    private func bindViewModel(){

        if goodsCategoryId == nil{//如果为空 查询所有的23级分类
            vm.requestNewDataCommond.onNext(false)
            setAllGoodsCategory()
        }else{//查询1分类对应的23级分类
            vm.requestNewDataCommond.onNext(true)
            setLevel1GoodsCategory()
        }
        ///绑定table Delegate
        table.rx.setDelegate(self).disposed(by: rx_disposeBag)


        ///3级分类数据源
        let collectionDataSource=RxCollectionViewSectionedReloadDataSource<SectionModel<String,GoodsCategoryModel>>(configureCell: { (_, collection, indexPath,element)  in
            let cell=collection.dequeueReusableCell(withReuseIdentifier:"ClassifyCollectionViewCellId", for: indexPath) as! ClassifyCollectionViewCell
            cell.updateCell(model:element)
            return cell
        })

        ///选中3级分类事件
        self.collection.rx.modelSelected(GoodsCategoryModel.self).asObservable().subscribe(onNext: { [weak self] (model) in
            let vc=GoodListViewController()
            vc.flag=2
            vc.goodsCategoryId=model.goodsCategoryId
            vc.titleStr=model.goodsCategoryName
            vc.hidesBottomBarWhenPushed=true
            self?.navigationController?.pushViewController(vc,animated:true)
        }).disposed(by:rx_disposeBag)

        ///绑定3级分类
        vm.goodsCategory3ArrBR.asObservable().map({ [weak self] (dic) -> [SectionModel<String,GoodsCategoryModel>] in
            let emptyDataType=dic.keys.first ?? .noData
            self?.emptyDataType = emptyDataType
            return dic[emptyDataType] ?? []
        }).bind(to:self.collection.rx.items(dataSource:collectionDataSource))
            .disposed(by: rx_disposeBag)

        ///刷新
        let refreshHeader=initRefreshHeader(collection) { [weak self] in
            if self?.goodsCategoryId == nil{//如果为空 查询所有的23级分类
                self?.vm.requestNewDataCommond.onNext(false)
            }else{//查询1分类对应的23级分类
                self?.vm.requestNewDataCommond.onNext(true)
            }
        }
        ///自动匹配当前刷新状态
        vm.autoSetRefreshHeaderStatus(header:refreshHeader, footer:nil).disposed(by:rx_disposeBag)
    }
    ///根据1级分类设置
    private func setLevel1GoodsCategory(){
        ///2级分类数据源
        let tableDataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,String>>(configureCell: { (_, table, indexPath,element)  in
            var cell=table.dequeueReusableCell(withIdentifier:"tableCellId") as? GoodClassifyTableViewCell
            if cell == nil{
                cell=GoodClassifyTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"tableCellId")
            }
            cell!.updateCell(name:element)
            return cell!
        })

        ///绑定2级分类
        vm.goodsCategory2ArrBR.asObservable()
            .bind(to:self.table.rx.items(dataSource:tableDataSource))
            .disposed(by:rx_disposeBag)


        ///table选中事件
        table.rx.itemSelected.asObservable().subscribe(onNext: { (indexPath) in
            weak var weakSelf=self
            if weakSelf == nil{
                return
            }
            ///获取2级分类名称
            let key=tableDataSource[indexPath]
            ///获取2级分类对应的3级分类数据
            let sectionModel=SectionModel(model:"", items: weakSelf!.vm.goodsCategory23ArrBR.value[key] ?? [])
            ///更新3级分类数据
            weakSelf!.vm.goodsCategory3ArrBR.accept([.noData
                :[sectionModel]])
            ///记录每次选中的行索引
            weakSelf!.vm.index=indexPath.row
        }).disposed(by:rx_disposeBag)
    }
    ///从底部点击进来
    private func setAllGoodsCategory(){
        ///2级分类数据源
        let tableDataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,GoodsCategoryModel>>(configureCell: { (_, table, indexPath,element)  in
            var cell=table.dequeueReusableCell(withIdentifier:"tableCellId") as? GoodClassifyTableViewCell
            if cell == nil{
                cell=GoodClassifyTableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"tableCellId")
            }
            cell!.updateCell(name:element.goodsCategoryName ?? "")
            return cell!
        })

        ///绑定2级分类
        vm.goodsCategoryAll2ArrBR.asObservable()
            .bind(to:self.table.rx.items(dataSource:tableDataSource))
            .disposed(by:rx_disposeBag)

        ///table选中事件
        table.rx.itemSelected.asObservable().subscribe(onNext: { (indexPath) in
            weak var weakSelf=self
            if weakSelf == nil{
                return
            }
            ///获取2级分类model
            let model=tableDataSource[indexPath]
            if model.goodsCategoryName == "全部"{///直接获取所有的3级分类
                weakSelf!.vm.goodsCategory3ArrBR.accept([.noData:weakSelf!.vm.goodsCategoryAll3ArrBR.value])
            }else{
                ///获取全部的3级分类
                let allArrModel3=weakSelf!.vm.goodsCategoryAll3ArrBR.value[0].items
                ///筛选父id是当前选中的2级分类id3级分类
                let arrModel3=allArrModel3.filter({ (m) -> Bool in
                    return m.goodsCategoryPid == model.goodsCategoryId
                })
                weakSelf!.vm.goodsCategory3ArrBR.accept([.noData:[SectionModel.init(model:"",items:arrModel3)]])
            }
            ///记录每次选中的行索引
            weakSelf!.vm.index=indexPath.row
        }).disposed(by:rx_disposeBag)
    }
}
///设置页面
extension ClassifyViewController:UITableViewDelegate{

    private func setUI(){

        table.tableFooterView=UIView(frame:CGRect.zero)
        table.backgroundColor=UIColor.viewBgdColor()
        table.separatorInset=UIEdgeInsets.zero
        table.register(GoodClassifyTableViewCell.self,forCellReuseIdentifier:"tableCellId")

        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.sectionInset=UIEdgeInsets.init(top:15, left:10, bottom:15, right:10)
        flowLayout.itemSize=CGSize(width:(SCREEN_WIDTH-130)/3,height:(SCREEN_WIDTH-130)/3)
        flowLayout.minimumLineSpacing = 5;//每个相邻layout的上下
        flowLayout.minimumInteritemSpacing = 0;//每个相邻layout的左右
        collection.collectionViewLayout = flowLayout
        collection.register(ClassifyCollectionViewCell.self, forCellWithReuseIdentifier:"ClassifyCollectionViewCellId")

    }
    ///返回cell高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let index=IndexPath(row:self.vm.index, section:0)
            DispatchQueue.main.async {
                tableView.selectRow(at:index, animated:true, scrollPosition: UITableViewScrollPosition.none)
            }
    }
}
