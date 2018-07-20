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
        let dataSource=RxTableViewSectionedReloadDataSource<SectionModel<String,AddressModel>>(configureCell:{ [weak self] (_,table,indexPath,model) in
            let cell=table.dequeueReusableCell(withIdentifier:"addressListId") as? AddressListTableViewCell ?? AddressListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier:"addressListId")
            cell.updateCell(model:model)
            return cell
        })

        table.rx.setDelegate(self).disposed(by:rx_disposeBag)

        ///绑定数据源
        vm.addressListBR.asObservable().map({ [weak self] (dic) -> [SectionModel<String,AddressModel>] in
                let emptyDataType=dic.keys.first ?? .noData
                self?.emptyDataType = emptyDataType
                return dic[emptyDataType] ?? []
        }).bind(to:table.rx.items(dataSource:dataSource)).disposed(by:rx_disposeBag)


    }
}
extension AddressListViewController:UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    //删除操作
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete{

        }
    }
    //把delete 该成中文
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String?{
        return "删除"
    }
}
