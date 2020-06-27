//
//  LevelGroupsVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/30/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import FirebaseFirestore

class LevelGroupsVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let levelGroups = ["Basics", "Intermediate", "Coltrane"]
    
    var selectedLevelGroup: String?
    var levelGroupNumOfMeasures: Int?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpValues()
        self.view.backgroundColor = .white
    }
    
    func setUpValues() {
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * 0.6)
        let cellHeight = floor(screenSize.height * 0.6)
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        let layout = collectionView.collectionViewLayout as! SnapToCenter
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)

        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.backgroundColor = .white
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelGroupCell", for: indexPath) as! LevelGroupCell

        cell.levelGroupLabel.text = String(levelGroups[indexPath.row])
        cell.levelGroupLabel.textColor = .black
        cell.backgroundColor = .white
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let levelGroupDoc = levelGroups[indexPath.row].lowercased()
        
        let levelGroupsRef = Firestore.firestore().collection("/level-groups")
        levelGroupsRef.document(levelGroupDoc).getDocument { (document, err) in
            if let document = document, document.exists {
                if let numOfMeasures = document.get("number-of-levels") as? Int {
                    self.selectedLevelGroup = document.documentID
                    self.levelGroupNumOfMeasures = numOfMeasures
                    self.performSegue(withIdentifier: "fromLevelGroupsToLevelSelectSegue", sender: self)
                }
                else {
                    print("document values not found")
                    return
                }
            }
            else {
                print("document was not found")
                return
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let levelSelect = segue.destination as? LevelSelect {
            
            guard let levelGroup = self.selectedLevelGroup,
                let numOfLevels = self.levelGroupNumOfMeasures else {
                    print("nothings really selected uhoh")
                    return
            }
            
            levelSelect.levelGroup = levelGroup
            levelSelect.numOfLevels = numOfLevels
        }
    }
    

    @IBAction func unwindFromLevelGroupsToWelcome(_ sender: Any) {
        performSegue(withIdentifier: "fromLevelGroupsToWelcomeUSegue", sender: self)
    }
    
    @IBAction func backToLevelGroupsFromLevelSelect(segue: UIStoryboardSegue) {}
    

}
