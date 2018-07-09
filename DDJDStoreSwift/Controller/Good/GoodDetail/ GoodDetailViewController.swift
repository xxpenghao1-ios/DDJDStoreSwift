//
//   GoodDetailViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/9.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
///商品详情
class GoodDetailViewController:BaseViewController{
    ///接收商品状态   1特价，2普通,3促销
    var flag:Int=2

    ///接收商品model
    var model:GoodDetailModel?

    ///商品图片
    @IBOutlet weak var goodImgView:UIImageView!

    ///加入购物车
    @IBOutlet weak var btnAddCar:UIButton!

    ///商品加减数量
    @IBOutlet weak var stepper: GMStepper!

    ///收藏图片
    @IBOutlet weak var collectionImgView:UIImageView!

    ///收藏文字 (已收藏 收藏)
    @IBOutlet weak var lblCollection:UILabel!

    ///商品名称
    @IBOutlet weak var lblGoodName:UILabel!

    ///商品单位
    @IBOutlet weak var lblGoodUnit:UILabel!

    ///商品规格
    @IBOutlet weak var lblUcode:UILabel!

    ///商品批价
    @IBOutlet weak var lblGoodPrice:UILabel!

    ///建议零售价
    @IBOutlet weak var lblUitemPrice:UILabel!

    ///商品销量
    @IBOutlet weak var lblSales:UILabel!

    @IBOutlet weak var table:UITableView!

    private var vm:GoodDetailViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
        bindViewModel()
    }
    ///设置UI
    private func setUI(){
        ///设置文字大小
        stepper.labelFont=UIFont.systemFont(ofSize:16)
        ///设置圆角
        btnAddCar.layer.cornerRadius=35/2
        table.delegate=self
        table.dataSource=self
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0)
        table.backgroundColor=UIColor.clear
    }
}
///绑定vm
extension GoodDetailViewController{

    private func bindViewModel(){
        if model == nil{
            return
        }
        ///初始化vm
        vm=GoodDetailViewModel(model:model!,goodDetailflag:flag)

        ///获取订单详情数据
        vm.goodDetailBR.asObservable().subscribe(onNext: { [weak self] (model) in
            self?.goodImgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)
            self?.lblGoodName.text=model.goodInfoName
            self?.lblSales.text=model.salesCount?.description
            self?.lblUcode.text="规格:\(model.ucode ?? "")"
            self?.lblGoodUnit.text="单位:\(model.goodUnit ?? "")"
            self?.lblGoodPrice.text="￥\(model.uprice ?? "0")"
            self?.lblUitemPrice.text=model.uitemPrice
            self?.title=model.goodInfoName
            self?.stepper.minimumValue=Double(model.miniCount ?? 1)
            self?.stepper.maximumValue=999
            self?.stepper.stepValue=Double(model.goodsBaseCount ?? 1)
            self?.table.reloadData()
        }, onError: { (error) in

        }).disposed(by:rx_disposeBag)

    }
}
extension GoodDetailViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.goodDetailOtherTitleArr.count

    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=table.dequeueReusableCell(withIdentifier:"goodDetailId") ?? UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"goodDetailId")
        cell.textLabel?.font=UIFont.systemFont(ofSize:14)
        cell.textLabel?.textColor=UIColor.color333()
        cell.detailTextLabel?.font=UIFont.systemFont(ofSize:14)
        cell.detailTextLabel?.textColor=UIColor.textColor()
        if indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 5{
            cell.accessoryType = .disclosureIndicator
        }else{
            cell.accessoryType = .none
        }
        ///获取key
        cell.textLabel?.text=vm.goodDetailOtherTitleArr[indexPath.row]
        if vm.goodDetailOtherTitleArrValue.count > 0{//value
            cell.detailTextLabel?.text=vm.goodDetailOtherTitleArrValue[indexPath.row]
        }
        return cell

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath, animated:true)
    }
}
