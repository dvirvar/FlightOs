//
//  HotelViewController.swift
//  testTableView2
//
//  Created by Mimram on 6/3/18.
//  Copyright © 2018 Mimram. All rights reserved.
//

import UIKit
import ImageSlideshow

class HotelViewController: UIViewController {
    var hotel : Hotels!
    
    @IBOutlet weak var mainHotelCover: UIImageView!
    @IBOutlet weak var mainRatingHotel: UIImageView!
    @IBOutlet weak var mainNameHotel: UILabel!
    @IBOutlet weak var mainAdressHotel: UILabel!
    @IBOutlet weak var mainStatusline: UILabel!
    
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
    
    @IBOutlet weak var priceBundle: UILabel!
    @IBOutlet weak var oldPrice: UILabel!
    
    @IBOutlet weak var mainDescription: UITextView!
    
    @IBOutlet weak var website: UIImageView!
    
    @IBAction func orderNowBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "hotelsegueto", sender:sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainNameHotel.text = hotel.hotelName
        mainRatingHotel.image = hotel.ratingStar
        mainDescription.text = hotel.description
        
        departureCityFrom.text = hotel.departureCityFrom
        departureDateFrom.text = hotel.departureDateFrom
        departureTimeFrom.text = hotel.departureTimeFrom
        departureCityTo.text = hotel.departureCityTo
        departureDateTo.text = hotel.departureDateTo
        departureTimeTo.text = hotel.departureTimeTo
        
        returnCityFrom.text = hotel.returnCityFrom
        returnDateFrom.text = hotel.returnDateFrom
        returnTimeFrom.text = hotel.returnTimeFrom
        returnCityTo.text = hotel.returnCityTo
        returnDateTo.text = hotel.returnDateTo
        returnTimeTo.text = hotel.returnTimeTo
        
        priceBundle.text = hotel.priceBundle
        oldPrice.text = hotel.priceFor2People
        
        let imageslide = ImageSlideshow(frame: mainHotelCover.frame)
        var inputs = [SDWebImageSource]()
        for image in hotel.photos{
            inputs.append(SDWebImageSource(url: URL(string: image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!))
        }
        
        imageslide.setImageInputs(inputs)
        imageslide.contentScaleMode = .scaleAspectFill
        view.viewWithTag(3)?.addSubview(imageslide)
        imageslide.zoomEnabled = true
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destintion = segue.destination as? PaymentViewController{
            
            destintion.checkinprice = priceBundle.text!
            destintion.locationCountry = returnCityFrom.text!
        }
    }
    
}
