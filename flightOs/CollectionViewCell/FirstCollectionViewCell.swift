//
//  FirstCollectionViewCell.swift
//  testTableView2
//
//  Created by Mimram on 5/28/18.
//  Copyright © 2018 Mimram. All rights reserved.
//

import UIKit

class FirstCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var hotelPhoto: UIImageView!
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var cityHotel: UILabel!
    @IBOutlet weak var priceBundle: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    @IBOutlet weak var ratingStarImg: UIImageView!
    @IBOutlet weak var peopleInRoom: UILabel!
    @IBOutlet weak var numOfNight: UILabel!
    
    @IBOutlet weak var departureCityFrom: UILabel!
    @IBOutlet weak var departureDateFrom: UILabel!
    @IBOutlet weak var departureTimeFrom: UILabel!
    
    @IBOutlet weak var departureCityTo: UILabel!
    @IBOutlet weak var departureDateTo: UILabel!
    @IBOutlet weak var departureTimeTo: UILabel!
    
    @IBOutlet weak var returnCityFrom: UILabel!
    @IBOutlet weak var returnDateFrom: UILabel!
    @IBOutlet weak var returnTimeFrom: UILabel!
    
    @IBOutlet weak var returnCityTo: UILabel!
    @IBOutlet weak var returnDateTo: UILabel!
    @IBOutlet weak var returnTimeTo: UILabel!
    
}
