//
//  UIImageView.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/27.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import Kingfisher

extension UIImageView{

    /// 快速创建 imageView
    ///
    /// - parameter imgName:  图片名字
    ///
    /// - returns:
    convenience init(imgName: String) {
        self.init(image:UIImage(named:imgName))
    }

    ///
    /// - parameter withUrlString:      图片的 urlString
    /// - parameter placeholderImgName:  默认图片的名字
    func ph_setImage(withUrlString: String?, placeholderImgName: String?){
        // 获取图片的 url
        let url = URL(string: withUrlString ?? "")
        // 判断他是否为 nil
        guard let u = url else {
            return
        }
        self.kf.setImage(with: u, placeholder: UIImage(named: placeholderImgName ?? ""),options:[.transition(.fade(1))])

    }
}
