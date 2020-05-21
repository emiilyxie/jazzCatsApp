//
//  WelcomeScreen.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/20/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit

class WelcomeScreen: UIViewController {
    
    var goingToFreestyle = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func goToLevelSelect(_ sender: Any) {
        performSegue(withIdentifier: "goToLevelSelectSegue", sender: self)
    }
    
    @IBAction func goToFreestyle(_ sender: Any) {
        goingToFreestyle = true
        performSegue(withIdentifier: "goToFreestyleSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if goingToFreestyle == true {
            let gameVC = segue.destination as! GameViewController
            gameVC.freestyleMode = true
        }
    }
    
    @IBAction func backAtWelcomeScreen(segue: UIStoryboardSegue) {}

}
