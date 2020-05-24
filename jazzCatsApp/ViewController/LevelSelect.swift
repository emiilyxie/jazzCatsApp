//
//  Welcome.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/19/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit

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

    @IBAction func backToLevelSelectFromGame(segue: UIStoryboardSegue) {}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
