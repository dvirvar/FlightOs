//
//  FlightsViewController.swift
//  testTableView2
//
//  Created by Mimram on 6/3/18.
//  Copyright © 2018 Mimram. All rights reserved.
//

import UIKit
import ImageSlideshow
class FlightsViewController: UIViewController {
    var flights : Hotels!
    
    @IBOutlet weak var mainCountryImage: UIImageView!
    @IBOutlet weak var mainCountryName: UILabel!
    @IBOutlet weak var MainStatus: UILabel!
    @IBOutlet weak var mainDescripition: UITextView!
    
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
    
    @IBAction func ordernowBtn(_ sender: Any) {
        performSegue(withIdentifier: "flightsegueto", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainCountryName.text = flights.cityHotel
        
        departureCityFrom.text = flights.departureCityFrom
        departureDateFrom.text = flights.departureDateFrom
        departureTimeFrom.text = flights.departureTimeFrom
        departureCityTo.text = flights.departureCityTo
        departureDateTo.text = flights.departureDateTo
        departureTimeTo.text = flights.departureTimeTo
        
        returnCityFrom.text = flights.returnCityFrom
        returnDateFrom.text = flights.returnDateFrom
        returnTimeFrom.text = flights.returnTimeFrom
        returnCityTo.text = flights.returnCityTo
        returnDateTo.text = flights.returnDateTo
        returnTimeTo.text = flights.returnTimeTo
        
        priceBundle.text = flights.priceBundle
        
        let imageslide = ImageSlideshow(frame: mainCountryImage.frame)
        var inputs = [SDWebImageSource]()
        if !flights.photos.isEmpty{
            for image in flights.photos{
                inputs.append(SDWebImageSource(url: URL(string: image)!))
            }
        }else{
            inputs.append(SDWebImageSource(url: URL(string: flights.imageHotel)!))
        }
        imageslide.setImageInputs(inputs)
        imageslide.contentScaleMode = .scaleAspectFill
        view.viewWithTag(3)?.addSubview(imageslide)
        imageslide.zoomEnabled = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PaymentViewController{
            destination.checkinprice = priceBundle.text!
            destination.locationCountry = returnCityFrom.text!
        }
    }
    
}

