//
//  Welcome.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/19/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import FirebaseFirestore

class LevelSelect: UIViewController {
    
    var whichLevel: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func selectLevel1(_ sender: Any) {
        whichLevel = 1
        performSegue(withIdentifier: "goToLevelSegue", sender: self)
    }
    
    @IBAction func selectLevel2(_ sender: Any) {
        whichLevel = 2
        performSegue(withIdentifier: "goToLevelSegue", sender: self)
    }
    
    @IBAction func selectLevel3(_ sender: Any) {
        whichLevel = 3
        performSegue(withIdentifier: "goToLevelSegue", sender: self)
    }
    
    @IBAction func selectLevel4(_ sender: Any) {
        whichLevel = 1
        performSegue(withIdentifier: "goToLevelSegue", sender: self)
    }
    
    @IBAction func selectLevel5(_ sender: Any) {
        whichLevel = 1
        performSegue(withIdentifier: "goToLevelSegue", sender: self)
    }
    
    @IBAction func selectLevel6(_ sender: Any) {
        whichLevel = 1
        performSegue(withIdentifier: "goToLevelSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let gameVC = segue.destination as! GameViewController
        gameVC.selectedLevel = whichLevel
    }

    // destination segues
    @IBAction func backToLevelSelectFromGame(segue: UIStoryboardSegue) {}
    
}
