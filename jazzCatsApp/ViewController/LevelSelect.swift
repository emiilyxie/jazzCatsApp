//
//  Welcome.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/19/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit

class LevelSelect: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var levels = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]
    
    var whichLevel: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // setting up the collection view funcs
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "level", for: indexPath) as! LevelCell

        cell.levelCellLabel.text = String(levels[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(levels[indexPath.row])
        whichLevel = levels[indexPath.row]
        performSegue(withIdentifier: "goToLevelSegue", sender: self)
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
        if let gameVC = segue.destination as? GameViewController {
            gameVC.selectedLevel = whichLevel
        }
    }
    
    func goToLevel(_ sender: Any) {
        performSegue(withIdentifier: "goToLevelSegue", sender: self)
    }
    
    // unwind segue
    @IBAction func unwindFromLevelSelectToWelcome(_ sender: Any) {
        performSegue(withIdentifier: "fromLevelSelectToWelcomeUSegue", sender: self)
    }

    // destination segues
    @IBAction func backToLevelSelectFromGame(segue: UIStoryboardSegue) {}
    
}
