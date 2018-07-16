//
//  SecondTableViewCell.swift
//  testTableView2
//
//  Created by Mimram on 6/1/18.
//  Copyright © 2018 Mimram. All rights reserved.
//

import UIKit

class SecondTableViewCell: UITableViewCell {

    @IBOutlet weak var secondCollectionView: UICollectionView!
    
    
    
    func setCollectionDatasourceDelege<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ datasourceDelege : D, forRow row: Int  ){
        secondCollectionView.delegate = datasourceDelege
        secondCollectionView.dataSource = datasourceDelege
        
        secondCollectionView.tag = row
        secondCollectionView.reloadData()
        
    }
}
