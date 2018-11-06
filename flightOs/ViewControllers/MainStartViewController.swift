//
//  MainStartViewController.swift
//
//  Created by Mimram on 6/12/18.
//  Copyright © 2018 Mimram. All rights reserved.
//

import UIKit
import Lottie

class MainStartViewController: UIViewController {
    
    @IBOutlet weak var loading: UILabel!
    @IBOutlet weak var vacationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        animateLoadingLabel()
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.performSegue(withIdentifier: "gotohomepage", sender: self)
        })
        let animationView = LOTAnimationView.init(name: "plane2")
        animationView.frame = CGRect(x: 10, y: 200, width: self.view.frame.width, height: 250)
        animationView.contentMode = .scaleAspectFit
        animationView.loopAnimation = true
        animationView.lastBaselineAnchor.anchorWithOffset(to: vacationLabel.topAnchor)
        loading.rightAnchor.anchorWithOffset(to: vacationLabel.leftAnchor)
        animationView.animationProgress = 0.50
        self.view.addSubview(animationView)
        
        animationView.play()
    }
    
    @objc func animateLoadingLabel()
    {
        if (loading != nil)
        {
            if loading.text == "טוען..."
            {
                loading.text = "טוען"
            }
            else
            {
                loading.text = "\(loading.text!)."
            }
            
            perform(#selector(animateLoadingLabel), with: nil, afterDelay: 1)
        }
    }
    
}



