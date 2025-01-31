//
//  Welcome.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/19/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
//import FirebaseAuth
//import FirebaseFirestore

class LevelSelect: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var levels: Array<Int> = []
    var levelGroup: String = ""
    var numOfLevels: Int = 0
    var maxUnlockedLevel: Int = 1
    
    var whichLevel: Int = 0
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        // set up the datasource, an array of ints
        levels = Array<Int>(repeating: 0, count: numOfLevels)
        for i in 0..<numOfLevels {
            levels[i] = i+1
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set up the max unlocked level
        setUpGraphics()
        refreshCollection()
    }
    
    func refreshCollection() {
        if let maxUnlockedLevel = GameUser.levelProgress[levelGroup] {
            self.maxUnlockedLevel = maxUnlockedLevel
        }
        else {
            self.maxUnlockedLevel = 1
        }
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func setUpGraphics() {
        //self.view.backgroundColor = ColorPalette.brightManuscript
        
        /*
        let imageView : UIImageView = {
            let iv = UIImageView()
            iv.image = UIImage(named: "cafe1")
            iv.contentMode = .scaleAspectFill
            return iv
        }()
        
        self.collectionView.backgroundView = imageView
 */
        self.view.backgroundColor = ColorPalette.brightManuscript
        self.collectionView.backgroundColor = ColorPalette.brightManuscript
        
        let flowlayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowlayout.sectionInset.top = CGFloat(30)
        flowlayout.sectionInset.left = CGFloat(60)
        flowlayout.sectionInset.right = CGFloat(60)
        
        UIStyling.setHeader(header: header)
        header.text = levelGroup.capitalized
        
        UIStyling.setButtonStyle(button: backButton)
        backButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        backButton.layer.cornerRadius = 5
        backButton.backgroundColor = .white
    }
    
    // setting up the collection view funcs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "level", for: indexPath) as! LevelCell

        cell.levelCellLabel.text = String(levels[indexPath.row])
        cell.levelCellLabel.textColor = ColorPalette.lineColor
        
        if Int(cell.levelCellLabel.text!) ?? 0 > maxUnlockedLevel {
            cell.backgroundColor = UIColor.white.withAlphaComponent(CGFloat(0.5))
        }
        else {
            cell.backgroundColor = .white
        }
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 3
        cell.layer.borderColor = ColorPalette.lineColor.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(levels[indexPath.row])
        whichLevel = levels[indexPath.row]
        if whichLevel <= maxUnlockedLevel {
            performSegue(withIdentifier: Constants.levelSelectToGame, sender: self)
        }
        else {
            print("level not unlocked yet!!")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 4

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // pass on info
        if let gameVC = segue.destination as? GameViewController {
            gameVC.levelGroup = levelGroup
            gameVC.selectedLevel = whichLevel
            gameVC.maxlevel = numOfLevels
        }
    }
    
    func goToLevel(_ sender: Any) {
        performSegue(withIdentifier: Constants.levelSelectToGame, sender: self)
    }
    
    // unwind segue
    @IBAction func unwindFromLevelSelectToWelcome(_ sender: Any) {
        performSegue(withIdentifier: Constants.levelSelectToLevelGroups, sender: self)
    }

    // destination segues
    @IBAction func backToLevelSelectFromGame(segue: UIStoryboardSegue) {
        refreshCollection()
    }
    
}
