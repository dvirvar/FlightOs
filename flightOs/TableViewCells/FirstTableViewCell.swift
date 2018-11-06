//
//  FirstTableViewCell.swift
//
//  Created by Mimram on 5/28/18.
//  Copyright © 2018 Mimram. All rights reserved.
//

import UIKit

class FirstTableViewCell: UITableViewCell {
    @IBOutlet weak var firstCollectionView: UICollectionView!
   
    func setCollectionDatasourceDelege<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ datasourceDelege : D, forRow row: Int  ){
        firstCollectionView.delegate = datasourceDelege
        firstCollectionView.dataSource = datasourceDelege
    
        firstCollectionView.tag = row
        firstCollectionView.reloadData()
    
    }
    
    

}
