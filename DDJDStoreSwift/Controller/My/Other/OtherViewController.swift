//
//  OtherViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/4.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
///其他页面
class OtherViewController:BaseViewController{

    private var section1NameArr=["是否开启活动语音提示"]
    private var section2NameArr=["清除缓存","当前版本"]

    private var table:UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="其他"
        table=UITableView(frame:CGRect.init(x:0,y:NAV_HEIGHT+10,width:SCREEN_WIDTH, height:SCREEN_HEIGH-NAV_HEIGHT-BOTTOM_SAFETY_DISTANCE_HEIGHT-10),style:.grouped)
        table.dataSource=self
        table.delegate=self
        table.backgroundColor=UIColor.clear
        table.estimatedSectionFooterHeight=15
        table.estimatedSectionHeaderHeight=15
        table.tableFooterView=UIView.init(frame:CGRect.zero)
        table.separatorInset=UIEdgeInsets.zero
        self.view.addSubview(table)
    }
}
extension OtherViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return section1NameArr.count
        }else{
            return section2NameArr.count
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=table.dequeueReusableCell(withIdentifier:"id") ?? UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"id")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font=UIFont.systemFont(ofSize:15)
        cell.detailTextLabel?.font=UIFont.systemFont(ofSize:14)
        if indexPath.section == 0{
            cell.textLabel?.text=section1NameArr[indexPath.row]

        }else{
            cell.textLabel?.text=section2NameArr[indexPath.row]
            if indexPath.row == 0{
                cache.calculateDiskCacheSize(completion: { (size) in
                    cell.detailTextLabel?.text="\(size/1024/1024)MB"
                })
            }else if indexPath.row == 1{
                //应用程序信息
                let infoDictionary = Bundle.main.infoDictionary!
                let majorVersion = infoDictionary["CFBundleShortVersionString"]//主程序版本号
                cell.detailTextLabel?.text=majorVersion as? String
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath,animated:true)
        if  indexPath.section == 1{
            if indexPath.row == 0{
                cache.clearDiskCache(completion: {
                    cache.clearMemoryCache()
                    PHProgressHUD.showSuccess("缓存清除完毕")
                    self.table.reloadData()
                })
            }
        }
    }

}

