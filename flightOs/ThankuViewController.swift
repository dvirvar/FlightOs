//
//  ThankuViewController.swift
//  testTableView2
//
//  Created by Mimram on 6/12/18.
//  Copyright © 2018 Mimram. All rights reserved.
//

import UIKit

class ThankuViewController: UIViewController {

//    var timer : Timer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.performSegue(withIdentifier: "returntomain", sender: self)
        })

        
//         timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(timeaction), userInfo: nil, repeats: true)
        
    }

    
//    @objc func timeaction(){
//
//        //code for move next VC
//        let secondVC = storyboard?.instantiateViewController(withIdentifier: "returntomain") as? ViewController
//        self.navigationController?.pushViewController(secondVC!, animated: true)
//        timer.invalidate()//after that timer invalid

//}
}
