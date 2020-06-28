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
    
    var levelGroupNames: Array<String>?
    var levelGroupNumbers: Array<Int>?
    
    var selectedLevelGroup: String?
    var levelGroupNumOfLevels: Int?

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        getNameData {
            self.getCountData {
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpValues()
        setUpGraphics()
    }
    
    func getNameData(getCounts: @escaping () -> ()) {
        let levelGroupsRef = Firestore.firestore().collection("/level-groups")
        
        levelGroupsRef.document("all-groups").getDocument { (document, err) in
            if let err = err {
                print(err.localizedDescription)
                return
            }
            else if let document = document, document.exists {
                if let names = document.get("groups") as? Array<String> {
                    self.levelGroupNames = names
                    getCounts()
                }
            }
            else {
                print("couldnt get name doc")
                return
            }
        }
    }
    
    func getCountData(displayView: @escaping () -> ()) {
        let levelGroupsRef = Firestore.firestore().collection("/level-groups")
        self.levelGroupNumbers = []
        for name in levelGroupNames! {
            levelGroupsRef.document(name).getDocument { (document, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                else if let document = document, document.exists {
                    if let levelCount = document.get("number-of-levels") as? Int {
                        self.levelGroupNumbers?.append(levelCount)
                    }
                }
                else {
                    print("couldnt get number of levels")
                    return
                }
            }
        }
        displayView()
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
    
    func setUpGraphics() {
        self.view.backgroundColor = .white
        
        header.backgroundColor = .white
        header.layer.masksToBounds = true
        header.layer.borderWidth = 3
        header.layer.borderColor = UIColor.black.cgColor
        
        backButton.backgroundColor = .white
        backButton.layer.masksToBounds = true
        backButton.contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        backButton.layer.cornerRadius = 5
        backButton.layer.borderWidth = 3
        backButton.layer.borderColor = UIColor.black.cgColor
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let names = levelGroupNames else {
            print("level names not loaded")
            return 0
        }
        return names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelGroupCell", for: indexPath) as! LevelGroupCell
        
        guard let names = levelGroupNames else {
            print("level names not loaded")
            return UICollectionViewCell()
        }

        cell.levelGroupLabel.text = String(names[indexPath.row])
        cell.levelGroupLabel.textColor = .black
        //cell.levelGroupLabel.layer.masksToBounds = true
        
        cell.levelGroupBkgd.contentMode = .scaleAspectFill
        cell.levelGroupBkgd.clipsToBounds = true
        cell.levelGroupBkgd.image = UIImage(named: "cafe1")
        
        cell.backgroundColor = .white
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 5
        cell.layer.borderWidth = 3
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let names = levelGroupNames, let counts = levelGroupNumbers else {
            print("level names or counts not loaded")
            return
        }
        
        selectedLevelGroup = names[indexPath.row]
        levelGroupNumOfLevels = counts[indexPath.row]
        performSegue(withIdentifier: "fromLevelGroupsToLevelSelectSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let levelSelect = segue.destination as? LevelSelect {
            
            guard let levelGroup = selectedLevelGroup,
                let numOfLevels = levelGroupNumOfLevels else {
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
