//
//  ClassifyViewController.swift
//  DDJDStoreSwift
//
//  Created by hao peng on 2018/6/30.
//  Copyright © 2018年 zldd. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
///分类
class ClassifyViewController:BaseViewController {
    
    ///2级分类table
    @IBOutlet weak var table:UITableView!

    ///3级分类
    @IBOutlet weak var collection:UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title="分类"
        self.view.backgroundColor=UIColor.viewBgdColor()
        setUI()
    }
    
}
///设置页面
extension ClassifyViewController{

    private func setUI(){
        table.tableFooterView=UIView(frame:CGRect.zero)
        table.backgroundColor=UIColor.viewBgdColor()
        table.separatorInset=UIEdgeInsets.zero

        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize=CGSize(width:(SCREEN_WIDTH-100)/3,height:(SCREEN_WIDTH-100)/3)
        flowLayout.minimumLineSpacing = 5;//每个相邻layout的上下
        flowLayout.minimumInteritemSpacing = 0;//每个相邻layout的左右
        collection.collectionViewLayout = flowLayout
//        collection.register(ClassifyCollectionViewCell.self, forCellWithReuseIdentifier:"ClassifyCollectionViewCellId")
    }
}
