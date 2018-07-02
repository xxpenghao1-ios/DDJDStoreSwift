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
        vm.goodsCategoryId=goodsCategoryId
        setUI()
        bindViewModel()
    }
    
}

extension ClassifyViewController{
    ///绑定VM
    private func bindViewModel(){

        vm.requestNewDataCommond.onNext(true)

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
        vm.goodsCategory2ArrBR.asObservable().bind(to:self.table.rx.items(dataSource:tableDataSource)).disposed(by:rx_disposeBag)

        ///绑定table Delegate
        table.rx.setDelegate(self).disposed(by: rx_disposeBag)


        ///table选中事件
        table.rx.itemSelected.asObservable().subscribe(onNext: { (indexPath) in
            weak var weakSelf=self
            if weakSelf == nil{
                return
            }
            weakSelf!.table.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated:true)
            ///获取2级分类名称
            let key=tableDataSource[indexPath]
            ///获取2级分类对应的3级分类数据
            let sectionModel=SectionModel(model:"", items: weakSelf!.vm.goodsCategory23ArrBR.value[key] ?? [])
            ///更新3级分类数据
            weakSelf!.vm.goodsCategory3ArrBR.accept([sectionModel])
        }).disposed(by:rx_disposeBag)

        ///3级分类数据源
        let collectionDataSource=RxCollectionViewSectionedReloadDataSource<SectionModel<String,GoodsCategoryModel>>(configureCell: { (_, collection, indexPath,element)  in
            let cell=collection.dequeueReusableCell(withReuseIdentifier:"ClassifyCollectionViewCellId", for: indexPath) as! ClassifyCollectionViewCell
            cell.updateCell(model:element)
            return cell
        })

        ///绑定3级分类
        vm.goodsCategory3ArrBR.asObservable().bind(to:self.collection.rx.items(dataSource:collectionDataSource)).disposed(by: rx_disposeBag)

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
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
}
