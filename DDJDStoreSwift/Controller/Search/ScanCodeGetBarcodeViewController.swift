//
//  ScanCodeGetBarcodeViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/7/17.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import AVFoundation
///扫码获取条形码 或二维码
class ScanCodeGetBarcodeViewController:LBXScanViewController,LBXScanViewControllerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="扫描商品条形码"
        ///去掉返回按钮文字
        let bark=UIBarButtonItem()
        bark.title=""
        bark.tintColor=UIColor.color333()
        self.navigationItem.backBarButtonItem=bark
        ///设置条码类型
        self.arrayCodeType=[AVMetadataObject.ObjectType.ean13,AVMetadataObject.ObjectType.ean8,AVMetadataObject.ObjectType.code128,AVMetadataObject.ObjectType.code39,AVMetadataObject.ObjectType.code93]

        //设置扫码区域参数
        var style = LBXScanViewStyle()
        style.centerUpOffset = 44;
        style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle.On;
        style.photoframeLineW = 6;
        style.photoframeAngleW = 24;
        style.photoframeAngleH = 24;
        style.isNeedShowRetangle = true;
        style.anmiationStyle = LBXScanViewAnimationStyle.NetGrid;
        //使用的支付宝里面网格图片
        style.animationImage = UIImage(named: "CodeScan.bundle/qrcode_scan_part_net");
        //4个角的颜色
        style.colorAngle=UIColor.applicationMainColor()
        self.scanStyle=style
        self.isOpenInterestRect = true
        self.scanResultDelegate=self
    }
    ///扫码结果返回
    func scanFinished(scanResult: LBXScanResult, error: String?) {
        if scanResult.strBarCodeType != nil{
            if scanResult.strBarCodeType! != "org.iso.QRCode"{//判断是否是二维码
                let vc=GoodListViewController()
                vc.flag=1
                vc.titleStr=scanResult.strScanned
                self.navigationController?.pushViewController(vc, animated:true)
            }
        }
    }
}
