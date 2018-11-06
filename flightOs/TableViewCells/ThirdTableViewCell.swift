//
//  ThirdTableViewCell.swift
//
//  Created by Mimram on 6/1/18.
//  Copyright © 2018 Mimram. All rights reserved.
//

import UIKit

class ThirdTableViewCell: UITableViewCell {
    @IBOutlet weak var thirdCollectionView: UICollectionView!
    
    func setCollectionDatasourceDelege<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ datasourceDelege : D, forRow row: Int  ){
        thirdCollectionView.delegate = datasourceDelege
        thirdCollectionView.dataSource = datasourceDelege
        
        thirdCollectionView.tag = row
        thirdCollectionView.reloadData()
        
    }

}
