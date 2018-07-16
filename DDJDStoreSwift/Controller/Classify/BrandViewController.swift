//
//  BrandViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/14.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
///品牌
class BrandViewController:BaseViewController{

    ///接收1级分类id
    var goodsCategoryId:Int?

    var vm:BrandViewModel!

    private var collection:UICollectionView={
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset=UIEdgeInsets.init(top:10, left:10, bottom:10, right:10)
        let widthH=(SCREEN_WIDTH-40)/3
        flowLayout.itemSize = CGSize(width:widthH,height:50)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical//设置垂直显
        flowLayout.minimumLineSpacing = 10;//每个相邻layout的上下
        flowLayout.minimumInteritemSpacing = 10;//每个相邻layout的左右
        flowLayout.headerReferenceSize = CGSize(width:0, height: 0);
        let collectionView=UICollectionView(frame:CGRect.init(x:0, y:2,width:SCREEN_WIDTH,height:SCREEN_HEIGH-NAV_HEIGHT-44-BOTTOM_SAFETY_DISTANCE_HEIGHT-2), collectionViewLayout: flowLayout)
        collectionView.backgroundColor=UIColor.white
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:"brandCellId")
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(collection)
        collection.emptyDataSetSource=self
        collection.emptyDataSetDelegate=self
        self.emptyDataSetTextInfo="暂时木有相关品牌"
        vm=BrandViewModel(goodsCategoryId:goodsCategoryId)
        bindViewModel()
    }
}
///绑定vm
extension BrandViewController:Refreshable{

    private func bindViewModel(){

        if goodsCategoryId != nil{///查询1级分类下面品牌
            vm.requestNewDataCommond.onNext(1)
        }else{///查询所有品牌
            vm.requestNewDataCommond.onNext(2)
        }

        //创建品牌数据源
        let brandDataSource = RxCollectionViewSectionedReloadDataSource
            <SectionModel<String,GoodsCategoryModel>>(
                configureCell: { (dataSource, collectionView, indexPath,model)  in
                    let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"brandCellId",for:indexPath)
                    var lblName=cell.contentView.viewWithTag(11) as? UILabel
                    if lblName == nil{
                        lblName=UILabel.buildLabel(textColor:UIColor.RGBFromHexColor(hexString:"414141"),font:15, textAlignment:.center)
                        lblName?.tag=11
                        cell.contentView.addSubview(lblName!)
                    }
                    lblName!.frame=cell.contentView.frame
                    lblName!.text=model.brandName
                    cell.contentView.backgroundColor=UIColor.RGBFromHexColor(hexString:"ebebeb")
                    return cell
            })

        ///绑定数据源
        vm.goodsBrandArrBR.asObservable().map({ [weak self] (dic) -> [SectionModel<String,GoodsCategoryModel>] in
            let emptyDataType=dic.keys.first ?? .noData
            self?.emptyDataType = emptyDataType
            return dic[emptyDataType] ?? []
        }).bind(to:collection.rx.items(dataSource:brandDataSource)).disposed(by:rx_disposeBag)

        ///选中3级分类事件
        self.collection.rx.modelSelected(GoodsCategoryModel.self).asObservable().subscribe(onNext: { [weak self] (model) in
            let vc=GoodListViewController()
            vc.flag=1
            vc.titleStr=model.brandName
            vc.hidesBottomBarWhenPushed=true
            self?.navigationController?.pushViewController(vc,animated:true)
        }).disposed(by:rx_disposeBag)

        ///刷新
        let refreshHeader=initRefreshHeader(collection) { [weak self] in
            if self?.goodsCategoryId != nil{
                self?.vm.requestNewDataCommond.onNext(1)
            }else{
                self?.vm.requestNewDataCommond.onNext(2)
            }
        }
        ///自动匹配当前刷新状态
        vm.autoSetRefreshHeaderStatus(header:refreshHeader, footer:nil).disposed(by:rx_disposeBag)
    }
}
