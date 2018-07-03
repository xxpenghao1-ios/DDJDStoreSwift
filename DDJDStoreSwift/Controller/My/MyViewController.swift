//
//  MyViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/3.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
///个人中心
class MyViewController:BaseViewController{

    private let vm=MyViewModel()

    override func viewWillAppear(_ animated: Bool){
        super.viewWillAppear(animated);

        ///去掉底部黑线
        self.navigationController?.navigationBar.shadowImage=UIImage()

        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.RGBFromHexColor(hexString:"ff1261"))

        ///修改导航栏 文字颜色为白色
        self.navigationController?.navigationBar.titleTextAttributes=NSDictionary(object:UIColor.white, forKey:NSAttributedStringKey.foregroundColor as NSCopying) as? [NSAttributedStringKey : Any]

    }
    //页面退出
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ///还原文字颜色
        self.navigationController?.navigationBar.titleTextAttributes=NSDictionary(object:UIColor.black, forKey:NSAttributedStringKey.foregroundColor as NSCopying) as? [NSAttributedStringKey : Any]
        self.navigationController?.navigationBar.lt_reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="个人中心"
//        self.automaticallyAdjustsScrollViewInsets = false
        self.view.addSubview(scrollView)
        bindViewModel()
    }

    ///滑动容器
    private lazy var scrollView:UIScrollView={
        let _scrollView=UIScrollView(frame:self.view.bounds)
        _scrollView.addSubview(topBacImgView)
        _scrollView.addSubview(memberInfoView)
        _scrollView.addSubview(memberheadPortrait)
        _scrollView.addSubview(orderCollectionView)
        _scrollView.addSubview(menuCollectionView)
        _scrollView.addSubview(btnReturnLogin)
        _scrollView.contentSize=CGSize.init(width:SCREEN_WIDTH, height:btnReturnLogin.frame.maxY+12.5)
        return _scrollView
    }()

    ///头部背景图片
    private lazy var topBacImgView:UIImageView={
        let _imgView=UIImageView.init(imgName:"my_top")
        _imgView.frame=CGRect.init(x:0,y:0,width:SCREEN_WIDTH,height:235/2)
        return _imgView
    }()

    ///会员信息view
    private lazy var memberInfoView:UIView={
        ///d91f4e
        let _view=UIView.init(frame: CGRect.init(x:49,y:48, width:SCREEN_WIDTH-98, height:140))
        _view.backgroundColor=UIColor.white
        //加上阴影效果
        _view.layer.shadowOpacity = 0.8
        _view.layer.shadowColor = UIColor.RGBFromHexColor(hexString:"d91f4e").cgColor
        _view.layer.shadowOffset = CGSize(width:1,height:1)
        _view.addSubview(lblStoreName)
        _view.addSubview(lblStoreAccount)
        return _view
    }()

    ///店铺名称
    private lazy var lblStoreName:UILabel={
        let _lbl=UILabel.buildLabel(textColor:UIColor.color333(),font:16.5)
        _lbl.frame=CGRect.init(x:0, y:60, width:SCREEN_WIDTH-98,height:20)
        _lbl.textAlignment = .center
        _lbl.font=UIFont.boldSystemFont(ofSize:16.5)
        _lbl.text=USER_DEFAULTS.object(forKey:"storeName") as? String
        return _lbl
    }()

    ///店铺账号
    private lazy var lblStoreAccount:UILabel={
        let _lbl=UILabel.buildLabel(textColor:UIColor.color333(),font:14.5)
        _lbl.textAlignment = .center
        _lbl.frame=CGRect.init(x:0,y:100,width:SCREEN_WIDTH-98,height:20)
        _lbl.text="18874973113"
        return _lbl
    }()

    ///会员头像 暂时静态图片
    private lazy var memberheadPortrait:UIImageView={
        let _imgView=UIImageView(frame:CGRect.init(x:(SCREEN_WIDTH-84)/2,y:6,width:84,height:84))
        _imgView.image=UIImage.init(named:"my_member_defualt")
        return _imgView
    }()

    ///订单
    private lazy var orderCollectionView:UICollectionView={
        let flowLayout = UICollectionViewFlowLayout()
        //计算每列的宽度，需要在布局之前算好
        let columnWidth = (SCREEN_WIDTH - 20)/3
        flowLayout.itemSize = CGSize(width:columnWidth,height:90)
        flowLayout.minimumLineSpacing=0
        flowLayout.minimumInteritemSpacing=0
        let _collectionView=UICollectionView.init(frame: CGRect.init(x:10,y:memberInfoView.frame.maxY+12.5, width:SCREEN_WIDTH-20, height:90), collectionViewLayout:flowLayout)
        _collectionView.backgroundColor = UIColor.white
        _collectionView.register(MyOrderCollectionViewCell.self, forCellWithReuseIdentifier:"MyOrderCollectionViewCellId")
        return _collectionView
    }()

    ///菜单
    private lazy var menuCollectionView:UICollectionView={
        let flowLayout = UICollectionViewFlowLayout()
        //计算每列的宽度，需要在布局之前算好
        let columnWidth = (SCREEN_WIDTH - 20)/4
        flowLayout.itemSize = CGSize(width:columnWidth,height:columnWidth)
        flowLayout.minimumLineSpacing=0
        flowLayout.minimumInteritemSpacing=0
        let _collectionView=UICollectionView.init(frame: CGRect.init(x:10,y:orderCollectionView.frame.maxY+12.5, width:SCREEN_WIDTH-20, height:columnWidth*2), collectionViewLayout:flowLayout)
        _collectionView.backgroundColor = UIColor.white
        return _collectionView
    }()

    ///退出登录
    private lazy var btnReturnLogin:UIButton={
        let _btn=UIButton.buildBtn(text:"退出登录", textColor:UIColor.color333(), font: 16.5, backgroundColor: UIColor.white)
        _btn.frame=CGRect.init(x:10, y:menuCollectionView.frame.maxY+12.5, width:SCREEN_WIDTH-20, height:49)
        return _btn
    }()

}

extension MyViewController{

    private func bindViewModel(){

        ///下拉背景图片拉伸
        scrollView.rx.didScroll.asObservable().subscribe { (_) in
            weak var weakSelf=self
            if weakSelf == nil{
                return
            }
            //获取偏移量
            let offsetY = weakSelf!.scrollView.contentOffset.y+NAV_HEIGHT;

            //判断是否改变
            if ( offsetY < 0) {
                var rect = weakSelf!.topBacImgView.frame;
                //我们只需要改变view的y值和高度即可
                rect.origin.y = offsetY
                rect.size.height = 235/2 - offsetY
                weakSelf!.topBacImgView.frame = rect;
            }
        }.disposed(by:rx_disposeBag)

        //创建订单数据源
        let orderDataSource = RxCollectionViewSectionedReloadDataSource
            <SectionModel<String,MyOrderViewModel>>(
                configureCell: { (dataSource, collectionView, indexPath, element)  in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"MyOrderCollectionViewCellId",for:indexPath) as! MyOrderCollectionViewCell
                    cell.updateCell(name:element.name, imgStr:element.imgStr)
                    return cell
            })

        ///绑定订单数据
        vm.orderBR.asObservable().bind(to:orderCollectionView.rx.items(dataSource:orderDataSource)).disposed(by: rx_disposeBag)
    }
}
