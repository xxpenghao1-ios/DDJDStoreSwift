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

    ///接收商品状态   1特价，2普通,3促销  默认普通商品
    var flag:Int=2

    ///接收商品model
    var model:GoodDetailModel?

    ///有值表示从购物车中跳转过来
    var isCarFlag:Int?

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

    ///商品原价
    @IBOutlet weak var lblOldPrice:UILabel!
    
    ///建议零售价
    @IBOutlet weak var lblUitemPrice:UILabel!

    ///商品销量
    @IBOutlet weak var lblSales:UILabel!

    ///选择商品数量
    @IBOutlet weak var btnSelectedGoodCount:UIButton!

    @IBOutlet weak var table:UITableView!

    ///跳转到购物车按钮
    private var btnPushCar:UIButton?

    private var vm:GoodDetailViewModel!

    ///加入购物车vm
    private var addCarVM:AddCarViewModel!

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
        ///加入收藏
        collectionImgView.isUserInteractionEnabled=true
        collectionImgView.addGestureRecognizer(UITapGestureRecognizer(target:self, action:#selector(addCollection)))

        if isCarFlag == nil{///如果不是从购物车中跳转过来 添加跳转到购物车按钮
            ///跳转到购物车按钮
            btnPushCar=UIButton(frame: CGRect.init(x:0, y:0, width:25,height:25))
            btnPushCar!.setImage(UIImage(named:"pushCar"), for: UIControlState.normal)
            btnPushCar!.addTarget(self,action:#selector(pushCar), for: UIControlEvents.touchUpInside)
            let pushCarItem=UIBarButtonItem(customView:btnPushCar!)
            pushCarItem.tintColor=UIColor.colorItem()
            self.navigationItem.rightBarButtonItem=pushCarItem
        }
    }
    ///跳转到购物车
    @objc private func pushCar(){

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
        ///初始化加入购物车vm
        addCarVM=AddCarViewModel(model:model!, flag:flag)

        ///获取订单详情数据
        vm.goodDetailBR.asObservable().subscribe(onNext: { [weak self] (model) in
            ///查询购物车商品数量
            self?.addCarVM.queryCarSumCountPS.onNext(true)
            self?.setData(model:model)
        }).disposed(by:rx_disposeBag)

        ///加入购物车
        btnAddCar.rx.tap.asObservable().subscribe({ (_) in
            weak var weakSelf=self
            if weakSelf == nil{
                return
            }
            weakSelf!.addCarVM.addCarPS.onNext(Int(weakSelf!.stepper.value))
        }).disposed(by:rx_disposeBag)

        ///更新购物车item按钮数量
        addCarVM.queryCarSumCountBR.asObservable().subscribe(onNext: { [weak self] (count) in
            self?.btnPushCar?.showBadge(with: WBadgeStyle.number, value: count, animationType: WBadgeAnimType.none)
        }).disposed(by:rx_disposeBag)

        ///选择商品数量
        btnSelectedGoodCount.rx.tap.asObservable().subscribe(onNext: { (_) in
            weak var weakSelf=self
            if weakSelf == nil{
                return
            }
            weakSelf!.selectedGoodCount(model:weakSelf!.vm.goodDetailBR.value)
        }).disposed(by:rx_disposeBag)
    }
    ///set数据
    private func setData(model:GoodDetailModel){
        self.goodImgView.ph_setImage(withUrlString:HTTP_URL_IMG+(model.goodPic ?? ""), placeholderImgName:GOOD_DEFAULT_IMG)
        if model.goodsCollectionStatu == 1{
            self.collectionImgView.image=UIImage(named:"has_collection")
            self.lblCollection.text="已收藏"
        }else{
            self.collectionImgView.image=UIImage(named:"not_collection")
            self.lblCollection.text="收藏"
        }
        self.lblSales.text=model.salesCount?.description
        self.lblUcode.text="规格:\(model.ucode ?? "")"
        self.lblGoodUnit.text="单位:\(model.goodUnit ?? "")"
        self.lblUitemPrice.text=model.uitemPrice
        self.title=model.goodInfoName
        self.stepper.minimumValue=Double(model.miniCount ?? 1)
        ///库存等于-1的时候最多999  否则最大是库存数
        self.stepper.maximumValue=model.goodsStock == -1 ? 999 : Double(model.goodsStock ?? 1)
        self.stepper.stepValue=Double(model.goodsBaseCount ?? 1)
        if self.flag == 1{//如果是特价
            //商品名称
            if model.eachCount == nil{
                lblGoodName.text=model.goodInfoName
            }else{
                lblGoodName.text=(model.goodInfoName ?? "")+"(限购~~\(model.eachCount!)\(model.goodUnit ?? ""))"
            }
            ///红色价格展示特价
            self.lblGoodPrice.text="￥\(model.prefertialPrice ?? "0")"
            ///给原价加上 中滑线
            let oldPrice=NSMutableAttributedString(string:"￥\(model.uprice ?? "0")")
            oldPrice.addAttribute(NSAttributedStringKey.strikethroughStyle, value:  NSNumber.init(value: Int8(NSUnderlineStyle.styleSingle.rawValue)), range: NSRange.init(location:0, length: oldPrice.length))
            self.lblOldPrice.attributedText=oldPrice
        }else{//不是特价
            ///红色价格展示 uprice
            self.lblGoodPrice.text="￥\(model.uprice ?? "0")"
            if self.flag == 3{//如果是促销
                //商品名称
                if model.promotionStoreEachCount == nil{
                    lblGoodName.text=model.goodInfoName
                }else{
                    lblGoodName.text=(model.goodInfoName ?? "")+"(限购~~\(model.promotionStoreEachCount!)\(model.goodUnit ?? ""))"
                }
            }else{
                self.lblGoodName.text=model.goodInfoName
            }
        }
        self.table.reloadData()
    }
    ///加入收藏
    @objc private func addCollection(){
        if vm.goodDetailBR.value.goodsCollectionStatu == 1{
            PHProgressHUD.showInfo("该商品已经收藏了")
        }else{
           ///发送加入收藏请求
           vm.addCollectionPS.onNext(true)
        }
    }
    /**
     弹出数量选择

     - parameter sender:UIButton
     */
    func selectedGoodCount(model:GoodDetailModel){
        let alertController = UIAlertController(title:nil, message:"输入您要购买的数量", preferredStyle: UIAlertControllerStyle.alert);
        alertController.addTextField {
            (textField: UITextField!) -> Void in
            textField.keyboardType=UIKeyboardType.numberPad
            if model.goodsStock == -1{//判断库存 等于-1 表示库存充足 由于UI大小最多显示3位数
                textField.placeholder = "请输入\(model.miniCount ?? 1)~999之间\(model.goodsBaseCount ?? 1)的倍数"
                textField.tag=999
            }else{
                textField.placeholder = "请输入\(model.miniCount ?? 1)~\(model.goodsStock ?? 1)之间\(model.goodsBaseCount ?? 1)的倍数"
                textField.tag=model.goodsStock ?? 1
            }
            NotificationCenter.default.addObserver(self, selector: #selector(self.alertTextFieldDidChange), name: NSNotification.Name.UITextFieldTextDidChange, object: textField)
        }
        //确定
        let okAction = UIAlertAction(title: "确定", style: UIAlertActionStyle.default,handler:{ [weak self] Void in
            let text=(alertController.textFields?.first)! as UITextField
            self?.stepper.value=Double(text.text!)!
        })
        //取消
        let cancelAction = UIAlertAction(title: "取消", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        okAction.isEnabled = false
        self.present(alertController, animated: true, completion: nil)
    }
    //检测输入框的字符是否大于库存数量 是解锁确定按钮
    @objc func alertTextFieldDidChange(_ notification: Notification){
        let alertController = self.presentedViewController as! UIAlertController?
        if (alertController != nil) {
            let text = (alertController!.textFields?.first)! as UITextField
            let okAction = alertController!.actions.last! as UIAlertAction
            if text.text?.count > 0{
                ///当输入数量 是goodsBaseCount的倍数  并且小于等于库存数  大于等于最低起送数量才可以点击确定按钮
                okAction.isEnabled = Int(text.text!)! % (self.vm.goodDetailBR.value.goodsBaseCount ?? 1) == 0 && Int(text.text!)! <= text.tag && Int(text.text!)! >= (self.vm.goodDetailBR.value.miniCount ?? 1)
            }else{
                okAction.isEnabled=false
            }
        }
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
        cell.accessoryType = .none
        if flag == 1{//特价
            if indexPath.row == 0{///第一行
                cell.textLabel?.textColor=UIColor.applicationMainColor()
            }else if indexPath.row == 4{
                cell.accessoryType = .disclosureIndicator
            }
        }else if flag == 3{//促销
            if indexPath.row == 0{///第一行
                cell.detailTextLabel?.textColor=UIColor.applicationMainColor()
                cell.accessoryType = .disclosureIndicator
            }else if indexPath.row == 4{
                cell.accessoryType = .disclosureIndicator
            }
        }else{//普通
            if indexPath.row == 3{
                cell.accessoryType = .disclosureIndicator
            }
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
        if flag == 1{//特价
            if indexPath.row == 4{//跳转到配送商商城
                pushGoodListVC()
            }
        }else if flag == 3{//促销
            if indexPath.row == 0{///弹出促销信息
                UIAlertController.showAlertYes(self, title:"促销信息", message:vm.goodDetailOtherTitleArrValue[0], okButtonTitle:"确定")
            }else if indexPath.row == 4{//跳转到配送商商城
                pushGoodListVC()
            }
        }else{//普通
            if indexPath.row == 3{//跳转到配送商商城
                pushGoodListVC()
            }
        }
    }
    ///跳转到配送商商城
    private func pushGoodListVC(){
        let vc=GoodListViewController()
        vc.flag=4
        vc.titleStr=vm.goodDetailBR.value.supplierName
        vc.subSupplierId=vm.goodDetailBR.value.subSupplier
        self.navigationController?.pushViewController(vc, animated:true)
    }
}
