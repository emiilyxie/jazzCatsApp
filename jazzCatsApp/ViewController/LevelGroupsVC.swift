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
    //var levelCards: [LevelGroupView]!
    
    var selectedLevelGroup: String?
    var levelGroupNumOfMeasures: Int?

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //levelCards = createSlides()
        //setUpSlideScrollView(slides: levelCards)
        setupValues()
    }
    
    func setupValues() {
        let screenSize = UIScreen.main.bounds.size
        let cellWidth = floor(screenSize.width * 0.6)
        let cellHeight = floor(screenSize.height * 0.6)
        let insetX = (view.bounds.width - cellWidth) / 2.0
        let insetY = (view.bounds.height - cellHeight) / 2.0
        let layout = collectionView.collectionViewLayout as! SnapToCenter
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        collectionView.contentInset = UIEdgeInsets(top: insetY, left: insetX, bottom: insetY, right: insetX)

        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelGroups.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "levelGroupCell", for: indexPath) as! LevelGroupCell

        cell.levelGroupLabel.text = String(levelGroups[indexPath.row])
        cell.backgroundColor = UIColor.purple
        
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

    @IBAction func backToLevelGroupsFromLevelSelect(segue: UIStoryboardSegue) {}
    
    /*
    func createSlides() -> [LevelGroupView] {
        
        let slide1:LevelGroupView = Bundle.main.loadNibNamed("LevelGroupView", owner: self, options: nil)?.first as! LevelGroupView
        slide1.parentVC = self
        slide1.levelGroupCard.backgroundColor = UIColor.red
        slide1.levelGroupCard.setTitle("Basics", for: .normal)
        
        let slide2:LevelGroupView = Bundle.main.loadNibNamed("LevelGroupView", owner: self, options: nil)?.first as! LevelGroupView
        slide2.parentVC = self
        slide2.levelGroupCard.backgroundColor = UIColor.blue
        slide2.levelGroupCard.setTitle("Intermediate", for: .normal)
        
        let slide3:LevelGroupView = Bundle.main.loadNibNamed("LevelGroupView", owner: self, options: nil)?.first as! LevelGroupView
        slide3.parentVC = self
        slide3.levelGroupCard.backgroundColor = UIColor.red
        slide3.levelGroupCard.setTitle("Coltrane", for: .normal)
        
        return [slide1, slide2, slide3]
    }
    
    func setUpSlideScrollView(slides: [LevelGroupView]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setUpSlideScrollView(slides: levelCards)
    }
    */
    
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
    

}
