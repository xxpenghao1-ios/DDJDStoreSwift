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

    private var nameArr=["清除缓存","当前版本"]

    private var table:UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="其他"
        table=UITableView(frame:CGRect.init(x:0,y:NAV_HEIGHT+10,width:SCREEN_WIDTH, height:SCREEN_HEIGH-NAV_HEIGHT-BOTTOM_SAFETY_DISTANCE_HEIGHT-10))
        table.dataSource=self
        table.delegate=self
        table.backgroundColor=UIColor.clear
        table.tableFooterView=UIView.init(frame:CGRect.zero)
        table.separatorInset=UIEdgeInsets.zero
        self.view.addSubview(table)
    }
}
extension OtherViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=table.dequeueReusableCell(withIdentifier:"id") ?? UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier:"id")
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font=UIFont.systemFont(ofSize:15)
        cell.detailTextLabel?.font=UIFont.systemFont(ofSize:14)
        cell.textLabel?.text=nameArr[indexPath.row]
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
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at:indexPath,animated:true)
        if indexPath.row == 0{
            cache.clearDiskCache(completion: {
                cache.clearMemoryCache()
                PHProgressHUD.showSuccess("缓存清除完毕")
                self.table.reloadData()
            })
        }
    }

}
