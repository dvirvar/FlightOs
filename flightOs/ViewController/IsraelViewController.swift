//
//  IsraelViewController.swift
//  testTableView2
//
//  Created by Mimram on 6/4/18.
//  Copyright © 2018 Mimram. All rights reserved.
//

import UIKit
import ImageSlideshow

class IsraelViewController: UIViewController {
    
    var israel : IsraelHotels!
    
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var priceBundle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var returnDateTo: UILabel!
    @IBOutlet weak var Israeldescription: UITextView!
    @IBOutlet weak var israelStatus: UILabel!
    @IBOutlet weak var israelMainImage: UIImageView!
    
    
    
    
    //searchview
    
    @IBAction func ordernowBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "israelsegueto", sender: sender)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hotelName.text = israel.hotelName
        priceBundle.text = israel.priceBundle
        date.text = israel.checkinDate
        returnDateTo.text = israel.returnDate
        Israeldescription.text = israel.description
        
        
        
        let imageslide = ImageSlideshow(frame: israelMainImage.frame)
        var inputs = [SDWebImageSource]()
        if !israel.photos.isEmpty{
            for image in israel.photos{
                inputs.append(SDWebImageSource(url: URL(string: image)!))
            }
        }else{
            inputs.append(SDWebImageSource(url: URL(string: israel.mainImage)!))
        }
        imageslide.setImageInputs(inputs)
        imageslide.contentScaleMode = .scaleAspectFill
        view.viewWithTag(3)?.addSubview(imageslide)
        imageslide.zoomEnabled = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PaymentViewController{
            destination.checkinprice = priceBundle.text!
            destination.locationCountry = hotelName.text!
        }
    }
}
