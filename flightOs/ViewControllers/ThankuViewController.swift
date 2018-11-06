//
//  ThankuViewController.swift
//
//  Created by Mimram on 6/12/18.
//  Copyright © 2018 Mimram. All rights reserved.
//

import UIKit

class ThankuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
            self.performSegue(withIdentifier: "returntomain", sender: self)
        })
    }
}
