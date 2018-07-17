//
//  SearchViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/16.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa
///搜索
class SearchViewController:BaseViewController{

    private var vm=SearchViewModel()

    private var txtSearch:UITextField!

    private var collection:UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.emptyDataType = .noData
        self.emptyDataSetTextInfo="暂无搜索记录"
        setUI()
        setUpNav()
        bindViewModel()
    }

}

extension SearchViewController:UITextFieldDelegate{

    private func bindViewModel(){

        vm.requestNewDataCommond.onNext(true)

        //数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource
            <SectionModel<String,GoodsCategoryModel>>(
                configureCell: { (dataSource, collectionView, indexPath,model)  in
                    let cell =  collectionView.dequeueReusableCell(withReuseIdentifier:"searchId",for:indexPath) as! SearchCollectionViewCell
                        cell.updateCell(str:model.brandName)
                    return cell
            })

        ///绑定数据源
        vm.allBrandAndSearchStrBR.asObservable().bind(to:collection.rx.items(dataSource:dataSource)).disposed(by:rx_disposeBag)

        ///选中3级分类事件
        self.collection.rx.modelSelected(GoodsCategoryModel.self).asObservable().subscribe(onNext: { [weak self] (model) in
            if model.brandName == "清除"{
                self?.vm.deleteSearchStr.onNext(true)
            }else{
                if model.brandName != "搜索历史" && model.brandName != "品牌推荐"{
                    self?.pushGoodList(str:model.brandName)
                }
            }
        }).disposed(by:rx_disposeBag)

        ///点击搜索按钮 验证完成后跳转到商品列表
        vm.pushGoodList.asObservable().subscribe(onNext: { [weak self] (str) in
            self?.pushGoodList(str:str)
        }).disposed(by:rx_disposeBag)
    }
    ///跳转到商品列表
    private func pushGoodList(str:String?){
        ///清除输入框数据
        txtSearch.text=nil
        let vc=GoodListViewController()
        vc.flag=1
        vc.titleStr=str
        self.navigationController?.pushViewController(vc,animated:true)
    }
    //点击键盘搜索按钮
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.vm.addSearchStr.onNext(textField.text)
        return true
    }
    //点击view隐藏键盘
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension SearchViewController{
    
    private func setUI(){
        let flowLayout = UICollectionViewFlowLayout()
        //给默认宽高 基于自动布局有效
        flowLayout.estimatedItemSize=CGSize(width:60, height:35)
        flowLayout.minimumLineSpacing = 10;//每个相邻layout的上下
        flowLayout.minimumInteritemSpacing = 10;//每个相邻layout的左右
        flowLayout.sectionInset=UIEdgeInsets(top:15,left:15,bottom:15,right:15)
        collection=UICollectionView(frame:self.view.bounds, collectionViewLayout:flowLayout)
        collection.backgroundColor=UIColor.clear
        collection.emptyDataSetSource=self
        collection.emptyDataSetDelegate=self
        collection.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier:"searchId")
        self.view.addSubview(collection)
    }
    ///设置导航栏
    private func setUpNav(){
        //直接创建一个文本框
        txtSearch=UITextField(frame:CGRect(x:0,y:0, width:SCREEN_WIDTH-100, height:30))
        txtSearch.backgroundColor=UIColor.RGBFromHexColor(hexString:"f0f2f5")
        txtSearch.placeholder="请输入您要搜索的商品"
        txtSearch.font=UIFont.systemFont(ofSize: 14)
        txtSearch.tintColor=UIColor.color666()
        txtSearch.returnKeyType = .search
        txtSearch.delegate=self
        txtSearch.clearButtonMode = .whileEditing
        txtSearch.layer.cornerRadius=15
        //左边搜索图片
        let leftView=UIView(frame:CGRect(x:0,y:0, width:30, height:30))
        let leftImageView=UIImageView(frame:CGRect(x:10,y:8.5,width:13.5,height:13))
        leftImageView.image=UIImage(named:"search")
        leftView.addSubview(leftImageView)
        txtSearch.leftView=leftView
        txtSearch.leftViewMode=UITextFieldViewMode.always
        //右边扫码图片
        let rightView=UIView(frame:CGRect(x:0,y:0, width:35, height:30))
        let rightImgView=UIImageView(frame:CGRect(x:0,y:2.5, width:25, height:25))
        rightImgView.isUserInteractionEnabled=true
        rightImgView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(pushSweepCodeVC)))
        rightImgView.image=UIImage(named:"sweep_code")
        rightView.addSubview(rightImgView)
        txtSearch.rightView=rightView
        txtSearch.rightViewMode=UITextFieldViewMode.always
        let searchTxtItem=UIBarButtonItem(customView:txtSearch)
        //搜索按钮
        let searchBtn=UIButton.buildBtn(text:"搜索", textColor:UIColor.color666(), font:15, backgroundColor:UIColor.clear)
        searchBtn.frame=CGRect(x:0, y:0, width:40, height:30)
        searchBtn.rx.tap.asObservable().subscribe { [weak self] (_) in
            self?.vm.addSearchStr.onNext(self?.txtSearch.text)
            }.disposed(by: rx_disposeBag)
        let searchBtnItem=UIBarButtonItem(customView:searchBtn)
        self.navigationItem.rightBarButtonItems=[searchBtnItem,searchTxtItem]
    }
    ///跳转到扫码页面
    @objc private func pushSweepCodeVC(){
        let camera: PrivateResource = .cameraCode
        let propose: Propose = {
            proposeToAccess(camera, agreed: {
                let vc=ScanCodeGetBarcodeViewController()
                self.navigationController?.pushViewController(vc, animated:true)
            }, rejected: {
                self.alertNoPermissionToAccess(camera)
            })
        }
        showProposeMessageIfNeedFor(camera, andTryPropose: propose)
    }
}
