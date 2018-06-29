//
//  IndexViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/12.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
///首页
class IndexViewController:BaseViewController,Refreshable{

    private let viewModel=IndexViewModel()
    ///新品推荐数组
    private var newGoodArr=[NewGoodModel]()
    ///旋转木马高度
    private var carouselHeight=(SCREEN_WIDTH-68)/3+35+30+14
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(scrollView)
        bindViewModel()
    }
    ///可滑动容器
    private lazy var scrollView:UIScrollView={
        let scrollView=UIScrollView(frame:self.view.bounds)
        scrollView.addSubview(cycleScrollView)
        scrollView.addSubview(classifyCollectionIntervalView)
        scrollView.addSubview(classifyCollectionView)
        scrollView.addSubview(specialsAndPromotionsView)
        scrollView.addSubview(newGoodView)
        scrollView.addSubview(hotTopView)
        scrollView.addSubview(hotGoodCollectionView)
        scrollView.contentSize=CGSize(width:SCREEN_WIDTH, height:hotGoodCollectionView.frame.maxY+15)
        return scrollView
    }()
    ///幻灯片
    private lazy var cycleScrollView:WRCycleScrollView={
        let cycleScrollView=WRCycleScrollView(frame:CGRect.init(x:0, y:0, width:SCREEN_WIDTH,height:SCREEN_WIDTH*0.38), type: ImgType.LOCAL, imgs:[SLIDE_DEFAULT])
        cycleScrollView.backgroundColor=UIColor.white
        cycleScrollView.pageControlAliment = .CenterBottom
        cycleScrollView.currentDotColor = .white
        cycleScrollView.autoScrollInterval=5
        return cycleScrollView
    }()
    ///分类间隔view
    private lazy var classifyCollectionIntervalView:UIView={
        let view=UIView.init(frame: CGRect.init(x:0, y:cycleScrollView.frame.maxY, width:SCREEN_WIDTH, height:15))
        view.backgroundColor=UIColor.white
        return view
    }()
    ///分类
    private lazy var classifyCollectionView:UICollectionView={
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset=UIEdgeInsets.init(top:0, left:15, bottom:0, right:15)
        let widthH=(SCREEN_WIDTH-75)/4
        flowLayout.itemSize = CGSize(width: widthH,height: widthH)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical//设置垂直显
        flowLayout.minimumLineSpacing = 10;//每个相邻layout的上下
        flowLayout.minimumInteritemSpacing = 15;//每个相邻layout的左右
        flowLayout.headerReferenceSize = CGSize(width:0, height: 0);
        let collectionView=UICollectionView(frame:CGRect.init(x:0, y:classifyCollectionIntervalView.frame.maxY,width:SCREEN_WIDTH,height:widthH*2+25), collectionViewLayout: flowLayout)
        collectionView.backgroundColor=UIColor.white
        collectionView.register(IndexClassifyCollectionViewCell.self, forCellWithReuseIdentifier:"indexClassifyId")
        return collectionView
    }()
    ///特价促销区 ***************
    private lazy var specialsAndPromotionsView:UIView={

        let view=UIView(frame: CGRect.init(x:0, y: classifyCollectionView.frame.maxY+10, width:SCREEN_WIDTH,height:220))
        view.backgroundColor=UIColor.white
        ///特价标题
        let title=UILabel.buildLabel(text:"特价促销", textColor: UIColor.color333(),font:16, textAlignment:.left)
        title.frame=CGRect.init(x:15,y:0,width:SCREEN_WIDTH-30,height:35)
        view.addSubview(title)
        view.addSubview(specialsAndPromotionsImgView)
        return view
    }()
    ///特价促销图片view
    private lazy var specialsAndPromotionsImgView:UIView={
        let view=UIView(frame: CGRect.init(x:15,y:35, width:SCREEN_WIDTH-30, height:175))
        view.backgroundColor=UIColor.white
        ///加上阴影效果
        view.layer.shadowOpacity = 0.8
        view.layer.shadowColor = UIColor.applicationMainColor().cgColor
        view.layer.shadowOffset = CGSize(width: 1, height: 1)
        view.addSubview(specialsImgView)
        view.addSubview(promotionsImgView)
        return view
    }()

    ///特价图片
    private lazy var specialsImgView:UIImageView={
        let imageView=UIImageView(frame: CGRect.init(x:175*0.8, y:0, width:SCREEN_WIDTH-30-175*0.8,height:175))
        imageView.image=UIImage.init(named:"index_special")
        return imageView
    }()
    ///促销图片
    private lazy var promotionsImgView:UIImageView={
        let imageView=UIImageView(frame: CGRect.init(x:0,y:0,width:175*0.8,height:175))
        imageView.image=UIImage.init(named:"index_promotion")
        return imageView
    }()
    /******************/

    ///新品推荐view
    private lazy var newGoodView:UIView={
        let _view=UIView(frame: CGRect.init(x:0, y:specialsAndPromotionsView.frame.maxY+10, width:SCREEN_WIDTH, height:35+carouselHeight+7))
        _view.backgroundColor=UIColor.white
        ///新品标题
        let _title=UILabel.buildLabel(text:"新品推荐", textColor: UIColor.color333(),font:16, textAlignment:.left)
        _title.frame=CGRect.init(x:15,y:0,width:SCREEN_WIDTH-30,height:35)
        _view.addSubview(_title)
        _view.addSubview(carousel)
        return _view
    }()
    ///旋转木马控件
    private lazy var carousel:iCarousel={
        let _carousel=iCarousel(frame:CGRect.init(x:0,y:35, width:SCREEN_WIDTH,height:carouselHeight))
        _carousel.type = .rotary
        _carousel.dataSource=self
        _carousel.delegate=self
        return _carousel
    }()
    ///热门商品头部view
    private lazy var hotTopView:UIView={
        let view=UIView(frame:CGRect.init(x:0,y:newGoodView.frame.maxY, width:SCREEN_WIDTH, height: 52))
        ///提示按钮
        let btnTitle=UIButton.buildBtn(text:"热门商品", textColor:UIColor.white, font:16, backgroundColor:UIColor.RGBFromHexColor(hexString:"ff1261"), cornerRadius:15)
        btnTitle.frame=CGRect.init(x:(SCREEN_WIDTH-90)/2,y:11, width:90, height:30)

        ///白色view
        let whiteView=UIView(frame: CGRect.init(x:0, y:26, width:SCREEN_WIDTH, height: 26))
        whiteView.backgroundColor=UIColor.white
        view.addSubview(whiteView)
        view.addSubview(btnTitle)
        return view
    }()
    ///热门商品UICollectionView
    private lazy var hotGoodCollectionView:UICollectionView={
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset=UIEdgeInsets.init(top:7, left: 7, bottom: 7, right:7)
        //计算每列的宽度，需要在布局之前算好
        let columnWidth = (SCREEN_WIDTH - 21)/2
        flowLayout.itemSize = CGSize(width:columnWidth,height:columnWidth+72)
        flowLayout.scrollDirection = UICollectionViewScrollDirection.vertical//设置垂直显
        flowLayout.minimumLineSpacing=7
        flowLayout.minimumInteritemSpacing=7
        let hotCollectionView=UICollectionView(frame:CGRect(x:0,y:hotTopView.frame.maxY,width:SCREEN_WIDTH,height:0),collectionViewLayout:flowLayout)
        hotCollectionView.backgroundColor=UIColor.viewBgdColor()
        hotCollectionView.isScrollEnabled=false
        hotCollectionView.register(IndexHotGoodCollectionViewCell.self, forCellWithReuseIdentifier:"indexHotGoodCellId");
        return hotCollectionView
    }()
}
///绑定VM
extension IndexViewController{
    ///绑定VM
    private func bindViewModel(){

        ///绑定幻灯片数据
        viewModel.imgUrlArrBR.asObservable().subscribe(onNext: { [weak self]  (imgArr) in
            self?.cycleScrollView.serverImgArray=imgArr
        }).disposed(by:rx_disposeBag)

        //创建分类数据源
        let categoryDataSource = RxCollectionViewSectionedReloadDataSource
            <SectionModel<String,GoodsCategoryModel>>(
                configureCell: { (dataSource, collectionView, indexPath, element)  in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"indexClassifyId",for:indexPath) as! IndexClassifyCollectionViewCell
                    cell.updateCell(model:element)
                    return cell
            })

        //绑定分类数据
        viewModel.categorySectionBR.asObservable()
            .bind(to:self.classifyCollectionView.rx.items(dataSource:categoryDataSource))
            .disposed(by:rx_disposeBag)

        ///获取新品推荐数据
        viewModel.newGoodArrModelBR.asObservable().subscribe(onNext: { [weak self] (arr) in
            self?.newGoodArr=arr
            self?.carousel.reloadData()
        }).disposed(by: rx_disposeBag)

        ///创建热门商品数据源
        let hotGoodDataSource = RxCollectionViewSectionedReloadDataSource
            <SectionModel<String,HotGoodModel>>(
                configureCell: { (dataSource, collectionView, indexPath, element)  in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"indexHotGoodCellId",for:indexPath) as! IndexHotGoodCollectionViewCell
                    cell.updateCell(model:element)
                    return cell
            })

        //绑定热门商品数据
        viewModel.hotGoodArrModelBR.asObservable().map({ [weak self] (arr) -> [SectionModel<String,HotGoodModel>] in
            ///根据数据设置热门商品控件高度
            if let modelArr=arr.first?.items{
                ///更新热门商品高度
                self?.updateHotGoodViewHeight(count:modelArr.count)
            }
            return arr
        }).bind(to:self.hotGoodCollectionView.rx.items(dataSource: hotGoodDataSource))
            .disposed(by:rx_disposeBag)
        ///刷新
        let refreshHeader=initRefreshHeader(scrollView) { [weak self] in
            self?.viewModel.requestNewDataCommond.onNext(true)
        }
        ///加载更多
        let refreshFooter=initRefreshFooter(scrollView) { [weak self] in
            self?.viewModel.requestNewDataCommond.onNext(false)
        }
        ///自动匹配当前刷新状态
        viewModel.autoSetRefreshHeaderStatus(header:refreshHeader, footer: refreshFooter).disposed(by:rx_disposeBag)
    }
}
///实现旋转木马
extension IndexViewController:iCarouselDataSource,iCarouselDelegate{
    ///返回数量
    func numberOfItems(in carousel: iCarousel) -> Int {
        return newGoodArr.count
    }
    ///返回视图
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
        let itemView:IndexNewGoodViews
        if view == nil{
            itemView=IndexNewGoodViews(frame:CGRect.init(x:20, y:0, width:SCREEN_WIDTH-40,height:carouselHeight),modelArr:newGoodArr)
        }else{
            itemView=view as! IndexNewGoodViews
        }
        return itemView
    }
    func carousel(_ carousel: iCarousel,valueFor option:iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        if (option == .spacing) {
            return value * 1.1
        }
        return value
    }


}
///更新布局
extension IndexViewController{
    ///更新热门商品高度  传入热门商品数量
    private func updateHotGoodViewHeight(count:Int){
        ///每个cell高度
        let height = (SCREEN_WIDTH - 21)/2+72+7
        ///计算热门商品控件高度
        let hotGoodCollectionViewHeight=count%2==0 ? CGFloat(count/2) * height: CGFloat((count+1)/2) * height
        ///重新设置热门商品高度
        self.hotGoodCollectionView.frame=CGRect(x:0,y:self.hotTopView.frame.maxY,width:SCREEN_WIDTH,height:hotGoodCollectionViewHeight+7)
        ///重新设置可滑动范围
        self.scrollView.contentSize=CGSize(width:SCREEN_WIDTH, height:self.hotGoodCollectionView.frame.maxY)
    }
}
