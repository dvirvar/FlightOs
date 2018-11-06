//
//  PaymentViewController.swift
//
//  Created by Mimram on 6/12/18.
//  Copyright © 2018 Mimram. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController {

    @IBAction func orderComplete(_ sender: UIButton) {
        let nameMSG = UIAlertController(title: "אנא הזן שם מלא", message: "", preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "אשר", style: .default, handler: nil)
        
        nameMSG.addAction(btnOk)
        
        guard let fullName = fullNameTF.text else {
            present(nameMSG, animated: true, completion: nil)
            return
        }
        if !fullName.contains(" "){
            present(nameMSG, animated: true, completion: nil)
            return
        }
        
        let fName = fullName.split(separator: " ")
        for name in fName {
            if String(name).count < 2{
                present(nameMSG, animated: true, completion: nil)
                return
            }
        }
       
        guard !(phoneNumTF.text?.isEmpty)! else{
            let msg = UIAlertController(title: "אנא הזן מספר", message: "", preferredStyle: .alert)
            let btnOk = UIAlertAction(title: "אשר", style: .default, handler: nil)
            
            msg.addAction(btnOk)
            present(msg, animated: true, completion: nil)
            return
        }
        
        performSegue(withIdentifier: "thanku", sender: nil)
    }
    var checkinPrice : String = ""
    var locationCountry : String = ""
    
    @IBOutlet weak var fullNameTF: UITextField!
    @IBOutlet weak var phoneNumTF: UITextField!
    @IBOutlet weak var priceCheckin: UILabel!
    @IBOutlet weak var orderRandomNumbers: UILabel!
    
    @IBOutlet weak var countryArea: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if checkinPrice.count > 4{
            print(checkinPrice.count)
            priceCheckin.font =  priceCheckin.font.withSize(CGFloat(20))
        }
        priceCheckin.text = checkinPrice
        countryArea.text = locationCountry
        orderRandomNumbers.text = String(arc4random_uniform(UInt32(100000)))
        
    }


}
