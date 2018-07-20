//
//  AddressListViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/20.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources
///收货地址管理
class AddressListViewController:BaseViewController{

    private var vm=AddressViewModel()

    private lazy var table:UITableView={
        let table=UITableView(frame: CGRect.init(x:0, y:NAV_HEIGHT, width:SCREEN_WIDTH, height:SCREEN_HEIGH-NAV_HEIGHT-BOTTOM_SAFETY_DISTANCE_HEIGHT-50))
        table.backgroundColor=UIColor.clear
        table.emptyDataSetSource=self
        table.emptyDataSetDelegate=self
        table.separatorInset=UIEdgeInsetsMake(0, 0, 0, 0)
        table.tableFooterView=UIView.init(frame:CGRect.zero)
        table.register(UINib(nibName:"AddressListTableViewCell", bundle:nil), forCellReuseIdentifier:"addressListId")
        return table
    }()

    private lazy var btnAddAddress:UIButton={
        let btn=UIButton.buildBtn(text:"添加收货地址", textColor:UIColor.white, font:16, backgroundColor: UIColor.applicationMainColor())
        btn.frame=CGRect.init(x:0, y:table.frame.maxY, width:SCREEN_WIDTH, height:50)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="收货地址管理"
        self.view.addSubview(table)
        self.view.addSubview(btnAddAddress)
        self.emptyDataSetTextInfo="暂无收货地址"
        bindViewModel()

    }
}
extension AddressListViewController{

    private func bindViewModel(){

        vm.requestNewDataCommond.onNext(true)
        ///数据源
        let dataSource=RxTableViewSectionedReloadDataSource<SectionModel<String,AddressModel>>(configureCell:{  (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"addressListId") as? AddressListTableViewCell ?? AddressListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"addressListId")
            cell.updateCell(model:model)
            return cell
        },
            canEditRowAtIndexPath: { _, _ in
                return true //单元格可删除
        },
            canMoveRowAtIndexPath: { _, _ in
                return true //单元格可移动
        })

        table.rx.setDelegate(self).disposed(by:rx_disposeBag)

        ///删除收货地址
        table.rx.itemDeleted.asObservable().subscribe(onNext: { [weak self] (indexPath) in
            self?.vm.deleteAddressPS.onNext(indexPath.row)
        }).disposed(by:rx_disposeBag)

        ///点击跳转修改收货地址
        table.rx.itemSelected.asObservable().subscribe(onNext: { [weak self](indexPath) in
            self?.table.deselectRow(at:indexPath, animated:true)
            self?.pushUpdateAddAddressVC(addressModel:self?.vm.addressList[indexPath.row])
        }).disposed(by:rx_disposeBag)

        ///绑定数据源
        vm.addressListBR.asObservable().map({ [weak self] (dic) -> [SectionModel<String,AddressModel>] in
                let emptyDataType=dic.keys.first ?? .noData
                self?.emptyDataType = emptyDataType
                return dic[emptyDataType] ?? []
        }).bind(to:table.rx.items(dataSource:dataSource)).disposed(by:rx_disposeBag)

        ///添加收货地址
        btnAddAddress.rx.tap.asObservable().subscribe(onNext: { [weak self] (_) in
            self?.pushUpdateAddAddressVC(addressModel:nil)
        }).disposed(by:rx_disposeBag)


    }
    ///跳转到添加/修改收货地址页面  addressModel有值 修改
    private func pushUpdateAddAddressVC(addressModel:AddressModel?){
        let vc=UIStoryboard.init(name:"UpdateAddAddress", bundle:nil).instantiateViewController(withIdentifier:"UpdateAddAddressVC") as! UpdateAddAddressViewController
        vc.addressModel=addressModel
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
extension AddressListViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //把delete 该成中文
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "删除"
    }
}
