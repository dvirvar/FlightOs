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
    
    var israel : IsraelHotel!
    
    @IBOutlet weak var hotelName: UILabel!
    @IBOutlet weak var priceBundle: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var returnDateTo: UILabel!
    @IBOutlet weak var israelDescription: UITextView!
    @IBOutlet weak var israelStatus: UILabel!
    @IBOutlet weak var israelMainImage: UIImageView!
    
    @IBAction func ordernowBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "israelsegueto", sender: sender)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hotelName.text = israel.hotelName
        priceBundle.text = israel.priceBundle
        date.text = israel.checkinDate
        returnDateTo.text = israel.returnDate
        israelDescription.text = israel.description
        
        let imageSlide = ImageSlideshow(frame: israelMainImage.frame)
        var inputs = [SDWebImageSource]()
        if !israel.photos.isEmpty{
            for image in israel.photos{
                inputs.append(SDWebImageSource(url: URL(string: image)!))
            }
        }else{
            inputs.append(SDWebImageSource(url: URL(string: israel.mainImage)!))
        }
        imageSlide.setImageInputs(inputs)
        imageSlide.contentScaleMode = .scaleAspectFill
        view.viewWithTag(3)?.addSubview(imageSlide)
        imageSlide.zoomEnabled = true
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PaymentViewController{
            destination.checkinPrice = priceBundle.text!
            destination.locationCountry = hotelName.text!
        }
    }
}
