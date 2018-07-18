//
//  CarViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/17.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxDataSources
import RxSwift
import RxCocoa
///购物车按钮
class CarViewController:BaseViewController{

    private var vm=CarViewModel()

    @IBOutlet weak var table:UITableView!
    ///结算
    @IBOutlet weak var btnSettlement:UIButton!
    ///全选
    @IBOutlet weak var btnCheckAll:UIButton!
    ///总价
    @IBOutlet weak var lblSumPrice:UILabel!
    ///底部view
    @IBOutlet weak var bottomView:UIView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ///发送网络请求
        vm.requestNewDataCommond.onNext(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="购物车"
        setUI()
        bindViewModel()
    }

    private func setUI(){

        ///默认隐藏底部view
        bottomView.isHidden=true
        ///设置圆角
        btnSettlement.layer.cornerRadius=35/2
        ///设置全部选择按钮
        btnCheckAll.setImage(UIImage.init(named:"car_selected"), for: UIControlState.selected)
        btnCheckAll.setImage(UIImage.init(named:"car_uncheck"), for: UIControlState.normal)
        ///默认选中
        btnCheckAll.isSelected=true

        table.register(UINib(nibName:"CarTableViewCell", bundle:nil), forCellReuseIdentifier:"carId")
        table.backgroundColor=UIColor.clear
        table.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        table.autoresizingMask = UIViewAutoresizing.flexibleHeight
        table.dataSource=self
        table.delegate=self
        table.emptyDataSetSource=self
        table.emptyDataSetDelegate=self
        table.tableHeaderView=UIView(frame:CGRect.init(x:0,y:0,width:0, height:6))
        table.tableFooterView=UIView(frame:CGRect.zero)
        self.emptyDataSetTextInfo="购物车空空如也"
        self.emptyDataType = .noData
        ///空视图不显示
        self.emptyDataIsHidden=false
    }
}

extension CarViewController{

    private func bindViewModel(){
        ///刷新数据
        vm.arrPS.subscribe(onNext: { [weak self] (b) in
            if self?.vm.arr.count > 0{//如果有数据显示底部view
                self?.bottomView.isHidden=false
            }
            ///显示空视图
            self?.emptyDataIsHidden=true
            self?.table.reloadData()
        }).disposed(by:rx_disposeBag)

        ///更新商品总价
        vm.sumPriceBR.subscribe(onNext: { [weak self] (sumPrice) in
            self?.lblSumPrice.text="￥\(sumPrice)"
        }).disposed(by:rx_disposeBag)
    }
    ///跳转到商品详情
    private func pushGoodDetail(model:GoodDetailModel){
        let vc=UIStoryboard(name:"GoodDetail", bundle:nil).instantiateViewController(withIdentifier:"GoodDetailVC") as! GoodDetailViewController
        vc.model=model
        vc.flag=model.flag ?? 2
        vc.hidesBottomBarWhenPushed=true
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
///购物车操作逻辑
extension CarViewController{

}
extension CarViewController:UITableViewDelegate,UITableViewDataSource{

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=table.dequeueReusableCell(withIdentifier:"carId") as? CarTableViewCell ?? CarTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"carId")
        if vm.arr.count > 0{
            let model=vm.arr[indexPath.section].listGoods![indexPath.row]
            cell.updateCell(model:model)
            cell.pushGoodDetailClosure={ [weak self] in
                self?.pushGoodDetail(model:model)
            }
        }
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return vm.arr.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.arr[section].listGoods!.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if vm.arr.count == 0{
            return nil
        }else{
            let carModel=vm.arr[section]
            return setCellHeaderView(carModel:carModel, section:section)
        }
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if vm.arr.count == 0{
            return nil
        }else{
            let carModel=vm.arr[section]
            return setCellFooterView(carModel:carModel, section:section)
        }
    }
    //返回头部高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    //返回尾部高度
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    ///头部
    private func setCellHeaderView(carModel:CarModel,section:Int) -> UIView{
        let view=UIView(frame:CGRect.init(x:0, y:0, width:SCREEN_WIDTH, height:50))
        view.backgroundColor=UIColor.white

        //给选择图片加上按钮实现点击切换
        let btnSelectImg=UIButton(frame:CGRect(x:10,y:15,width:20,height: 20));
        //选择图片
        let selectImg=UIImage(named:"car_uncheck");
        let selectImgSelected=UIImage(named:"car_selected");
        btnSelectImg.setImage(selectImg, for:UIControlState.normal)
        btnSelectImg.setImage(selectImgSelected, for:.selected);
//            btnSelectImg!.addTarget(self, action:#selector(selectImgSwitch), for: UIControlEvents.touchUpInside);
        btnSelectImg.tag=section
        view.addSubview(btnSelectImg);


        let lblSupplierName=UILabel(frame:CGRect(x:btnSelectImg.frame.maxX+5,y:15,width:200,height:20))
        lblSupplierName.font=UIFont.systemFont(ofSize:14)
        lblSupplierName.tag=111
        lblSupplierName.text=carModel.supplierName
        view.addSubview(lblSupplierName)
        if carModel.isSelected == 1{//如果等于1选中
            btnSelectImg.isSelected=true
        }else{
            btnSelectImg.isSelected=false
        }
        let lblLowestMoney=UILabel.buildLabel(text:"满\(carModel.lowestMoney  ?? "0")元起送", textColor:UIColor.color333(), font:14, textAlignment:.right)
        lblLowestMoney.frame=CGRect.init(x:SCREEN_WIDTH-160, y:15, width:150,height: 20)
        view.addSubview(lblLowestMoney)
        return view
    }
    ///尾部
    private func setCellFooterView(carModel:CarModel,section:Int) -> UIView{
        let view=UIView(frame:CGRect.init(x:0, y:0, width:SCREEN_WIDTH, height:50))
        view.backgroundColor=UIColor.white
        
        let broderView=UIView(frame: CGRect.init(x:0, y:44, width:SCREEN_WIDTH,height:6))
        broderView.backgroundColor=UIColor.viewBgdColor()
        view.addSubview(broderView)
//        //循环所有商品统计
//        var sumMoney="0"
//        for i in 0..<carModel.listGoods!.count{
//            let goodModel=carModel.listGoods![i]
//            if goodModel.isSelected == 1{//只统计选中的商品
//                if goodModel.flag == 1{//如果是特价
//                    sumMoney=PriceComputationsUtil.decimalNumberWithString(multiplierValue: "\(goodModel.carNumber ?? 0)", multiplicandValue:goodModel.prefertialPrice ?? "0", type:.multiplication, position:2)
//                }else{//普通价格
//                    sumMoney=PriceComputationsUtil.decimalNumberWithString(multiplierValue: "\(goodModel.carNumber ?? 0)", multiplicandValue:goodModel.uprice ?? "0", type:.multiplication, position:2)
//                }
//            }
//
//        }

        ///去凑单按钮
        let btn=UIButton.buildBtn(text:"去凑单", textColor:UIColor.white, font:14, backgroundColor:UIColor.applicationMainColor(), cornerRadius:5)
//        btn.addTarget(self, action:#selector(pushStoreVC), for:UIControlEvents.touchUpInside)

        btn.tag=section
        ///默认隐藏
        btn.isHidden=true

        ///每组商品提示信息
        let lblName=UILabel.buildLabel(textColor:UIColor.red, font:14, textAlignment:.left)

        if Double(carModel.sumPrice!) < Double(carModel.lowestMoney ?? "0"){//如果小计小于最低起送额
            lblName.text="还需\(PriceComputationsUtil.decimalNumberWithString(multiplierValue:carModel.lowestMoney ?? "0", multiplicandValue:carModel.sumPrice!,type:.subtraction, position:2))元起送"
            btn.isHidden=false
        }else{
            lblName.text="您已达到配送标准"
            btn.isHidden=true
        }

        let size=lblName.text!.textSizeWithFont(font: UIFont.systemFont(ofSize: 14), constrainedToSize:CGSize(width: 300,height: 20))

        lblName.frame=CGRect(x: 15,y: 10,width: size.width,height: 20)
        view.addSubview(lblName)

        btn.frame=CGRect(x: lblName.frame.maxX+5,y: 5,width: 60,height: 30)
        view.addSubview(btn)

        let lblTotal=UILabel(frame:CGRect(x: lblName.frame.maxX+65,y: 5,width:SCREEN_WIDTH-lblName.frame.maxX-10-65,height: 30))
        lblTotal.text="小计:\(carModel.sumPrice!)"
        lblTotal.font=UIFont.systemFont(ofSize: 14)
        lblTotal.textAlignment = .right
        lblTotal.textColor=UIColor.red
        view.addSubview(lblTotal)
        return view
    }

}
