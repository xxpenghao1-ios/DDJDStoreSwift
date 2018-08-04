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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///查询订单数据
        vm.orderCountPS.onNext(true)

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(scrollView)
        setNav()
        bindViewModel()
    }
    ///滑动容器
    private lazy var scrollView:UIScrollView={
        let _scrollView=UIScrollView(frame:view.bounds)
        _scrollView.addSubview(topBacImgView)
        _scrollView.addSubview(memberInfoView)
        _scrollView.addSubview(memberheadPortrait)
        _scrollView.addSubview(orderCollectionView)
        _scrollView.addSubview(menuCollectionView)
        _scrollView.addSubview(btnReturnLogin)
        if btnReturnLogin.frame.maxY+12.5 < SCREEN_HEIGH - TAB_BAR_HEIGHT{
            _scrollView.contentSize=CGSize.init(width:SCREEN_WIDTH, height:SCREEN_HEIGH - TAB_BAR_HEIGHT)
        }else{
            _scrollView.contentSize=CGSize.init(width:SCREEN_WIDTH, height:btnReturnLogin.frame.maxY+12.5)
        }
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
        _lbl.text=USER_DEFAULTS.object(forKey:"memberName") as? String
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
        flowLayout.sectionInset=UIEdgeInsets.init(top:10, left:0, bottom:0, right:0)
        //计算每列的宽度，需要在布局之前算好
        let columnWidth = (SCREEN_WIDTH - 20)/4
        flowLayout.itemSize = CGSize(width:columnWidth,height:columnWidth)
        flowLayout.minimumLineSpacing=0
        flowLayout.minimumInteritemSpacing=0
        let _collectionView=UICollectionView.init(frame: CGRect.init(x:10,y:orderCollectionView.frame.maxY+12.5, width:SCREEN_WIDTH-20, height:columnWidth*2+10), collectionViewLayout:flowLayout)
        _collectionView.backgroundColor = UIColor.white
        _collectionView.register(MyMenuCollectionViewCell.self, forCellWithReuseIdentifier:"MyMenuCollectionViewCellId")
        return _collectionView
    }()

    ///退出登录
    private lazy var btnReturnLogin:UIButton={
        let _btn=UIButton.buildBtn(text:"退出登录",textColor:UIColor.color333(), font: 16.5, backgroundColor:UIColor.white)
        _btn.frame=CGRect.init(x:10, y:menuCollectionView.frame.maxY+12.5, width:SCREEN_WIDTH-20, height:49)
        return _btn
    }()

}
///VM
extension MyViewController{

    private func bindViewModel(){

        //创建订单数据源
        let orderDataSource = RxCollectionViewSectionedReloadDataSource
            <SectionModel<String,MyModel>>(
                configureCell: { [weak self] (dataSource, collectionView, indexPath, element)  in
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"MyOrderCollectionViewCellId",for:indexPath) as! MyOrderCollectionViewCell

                    if self?.vm.orderCountBR.value.count == 0{
                        cell.updateCell(name:element.name, imgStr:element.imgStr, orderCountModel:nil)
                    }else{
                        ///拿到对应状态的订单数量  有可能为空
                        let orderCountModel=self?.vm.orderCountBR.value.filter{ $0.orderStatus == indexPath.row+1 }.first
                        cell.updateCell(name:element.name, imgStr:element.imgStr, orderCountModel:orderCountModel)
                    }
                    return cell
            })

        scrollView.rx.didScroll.asDriver(onErrorJustReturn: ()).drive(onNext: { [weak self] (_) in
            //获取偏移量
            let offsetY = (self?.scrollView.contentOffset.y ?? 0)+NAV_HEIGHT;
            //判断是否改变
            if ( offsetY < 0) {
                var rect = self?.topBacImgView.frame;
                //我们只需要改变view的y值和高度即可
                rect?.origin.y = offsetY
                rect?.size.height = 235/2 - offsetY
                self?.topBacImgView.frame = rect!;
            }
        }).disposed(by:rx_disposeBag)

        ///绑定订单数据
        vm.orderBR.asObservable().bind(to:orderCollectionView.rx.items(dataSource:orderDataSource)).disposed(by: rx_disposeBag)

        ///创建菜单数据源
        let menuDataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String,MyModel>>(
            configureCell: { (dataSource, collectionView, indexPath, element)  in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"MyMenuCollectionViewCellId",for:indexPath) as! MyMenuCollectionViewCell
            cell.updateCell(name:element.name, imgStr:element.imgStr)
            return cell
        })

        ///绑定菜单数据
        vm.menuBR.asObservable().bind(to:menuCollectionView.rx.items(dataSource:menuDataSource)).disposed(by:rx_disposeBag)

        ///更新订单数量
        vm.orderCountBR.asDriver(onErrorJustReturn: []).drive(onNext: { [weak self] (arr) in
            if arr.count > 0{
                self?.orderCollectionView.reloadData()
            }
        }).disposed(by:rx_disposeBag)

        ///VC操作
        vmOperation()

    }

    ///VM操作
    private func vmOperation(){

        ///订单点击事件
        orderCollectionView.rx.itemSelected.asObservable().subscribe(onNext: { [weak self] (indexPath) in
            ///跳转到对应订单页面
            let vc=OrderPageViewController()
            vc.hidesBottomBarWhenPushed=true
            var orderStatus=1
            switch indexPath.row{
            case 0:
                orderStatus=1
                break
            case 1:
                orderStatus=2
                break
            case 2:
                orderStatus=3
                break
            default:break
            }
            vc.orderStatus=orderStatus
            self?.navigationController?.pushViewController(vc,animated:true)
        }).disposed(by:rx_disposeBag)

        ///点击菜单跳转页面
        menuCollectionView.rx.itemSelected.asObservable().subscribe(onNext: { [weak self] (indexPath) in
            self?.menuPushVC(index:indexPath.row)
        }).disposed(by:rx_disposeBag)

        ///退出登录
        btnReturnLogin.rx.controlEvent(UIControlEvents.touchUpInside).asDriver(onErrorJustReturn: ()).drive(onNext: { [weak self] (_) in
            self?.returnLogin()
        }).disposed(by: rx_disposeBag)
    }
}

extension MyViewController{
    ///设置导航栏
    private func setNav(){
        let lblTitle=UILabel()
        lblTitle.textColor=UIColor.white
        lblTitle.font=UIFont.boldSystemFont(ofSize:17)
        lblTitle.text="个人中心"
        self.navigationItem.titleView=lblTitle

        let item=UIBarButtonItem.init(image:UIImage.init(named:"my_more")?.reSizeImage(reSize: CGSize.init(width:25, height: 25)), style: UIBarButtonItemStyle.done, target:self, action:#selector(pushOther))
        item.tintColor=UIColor.white
        self.navigationItem.rightBarButtonItem=item
    }
    ///跳转到其他页面
    @objc private func pushOther(){
        let vc=OtherViewController()
        vc.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated:true)
    }
    ///菜单跳转页面
    private func menuPushVC(index:Int){
        switch index {
        case 0:
            ///收货地址
            let vc=AddressListViewController()
            pushVC(vc:vc)
            break
        case 1:
            ///购买记录
            let vc=PurchaseRecordsViewController()
            pushVC(vc:vc)
            break
        case 2:
            ///点单商城
            let vc=UIStoryboard.init(name:"IntegralStore", bundle:nil).instantiateViewController(withIdentifier:"IntegralStoreVC") as! IntegralStoreViewController
            pushVC(vc:vc)
            break
        case 3:
            ///商品收藏
            let vc=CollectionGoodViewController()
            vc.hidesBottomBarWhenPushed=true
            pushVC(vc:vc)
            break
        case 4:
            ///我的消息
            let vc=MessageViewController()
            pushVC(vc:vc)
            break
        case 5:
            ///代金券
            let vc=VouchersViewController()
            pushVC(vc: vc)
            break
        case 6:
            //联系客服
            var tel=USER_DEFAULTS.object(forKey:"subStationPhoneNumber") as? String
            tel=tel ?? "400-835-6878"
            UIApplication.shared.openURL(Foundation.URL(string :"tel://\(tel!)")!)
            break
        case 7:
            ///投诉与建议
            let vc=ComplaintsAndSuggestionsViewController()
            pushVC(vc:vc)
            break
        default:break
        }

    }
    ///跳转页面
    private func pushVC(vc:BaseViewController){
        vc.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated:true)
    }
    ///退出登录
    private func returnLogin(){
        UIAlertController.showAlertYesNo(self, title:"提示", message:"您确认要退出登录吗?", cancelButtonTitle:"取消", okButtonTitle:"确定", okHandler: { [weak self] (action) in
            APP.jumpToLoginVC()
            self?.clearUserDefault()
        })
    }
}
