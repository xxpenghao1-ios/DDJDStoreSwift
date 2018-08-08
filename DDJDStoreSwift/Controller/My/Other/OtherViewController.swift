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

    ///是否开启 语音活动语音提示
    private var isCancelSpeechSwitch:UISwitch?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="其他"
        self.automaticallyAdjustsScrollViewInsets=false
        table=UITableView(frame:CGRect.init(x:0,y:NAV_HEIGHT,width:SCREEN_WIDTH, height:SCREEN_HEIGH-NAV_HEIGHT-BOTTOM_SAFETY_DISTANCE_HEIGHT),style:.grouped)
        table.dataSource=self
        table.delegate=self
        table.backgroundColor=UIColor.clear
        table.estimatedSectionFooterHeight=10
        table.estimatedSectionHeaderHeight=0
        table.estimatedRowHeight=0
        table.tableFooterView=UIView.init(frame:CGRect.zero)
        table.separatorInset=UIEdgeInsets.zero
        self.view.addSubview(table)
    }
    ///是否取消语音
    @objc private func isCancelSpeech(sender:UISwitch){
        if sender.isOn {///如果开启
            PHJPushHelper.setTag(tag:substation_Id ?? "")
        }else{///如果取消
            PHJPushHelper.removeTag()
        }
        USER_DEFAULTS.set(sender.isOn, forKey:"isCancelSpeech")
        USER_DEFAULTS.synchronize()
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
        cell.accessoryType = .none
        cell.textLabel?.font=UIFont.systemFont(ofSize:15)
        cell.detailTextLabel?.font=UIFont.systemFont(ofSize:14)
        if indexPath.section == 0{
            cell.textLabel?.text=section1NameArr[indexPath.row]
            isCancelSpeechSwitch = cell.contentView.viewWithTag(111) as? UISwitch
            if isCancelSpeechSwitch == nil{
                isCancelSpeechSwitch=UISwitch(frame:CGRect(x:SCREEN_WIDTH-60, y:10, width:45, height:30))

                isCancelSpeechSwitch!.isOn=USER_DEFAULTS.object(forKey:"isCancelSpeech") as? Bool ?? false
                isCancelSpeechSwitch!.addTarget(self, action:#selector(isCancelSpeech), for: .valueChanged)
                cell.contentView.addSubview(isCancelSpeechSwitch!)

            }
        }else{
            cell.textLabel?.text=section2NameArr[indexPath.row]
            if indexPath.row == 0{
                cache.calculateDiskCacheSize(completion: { (size) in
                    cell.detailTextLabel?.text="\(size/1024/1024)MB"
                    cell.accessoryType = .disclosureIndicator
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

