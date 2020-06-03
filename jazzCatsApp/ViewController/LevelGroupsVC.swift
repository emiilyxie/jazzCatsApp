//
//  LevelGroupsVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/30/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit

class LevelGroupsVC: UIViewController, UIScrollViewDelegate {
    
    let levelGroups = ["basics", "intermediate", "coltrane"]
    var levelCards: [LevelGroupView]!
    
    var selectedLevelGroup: String?
    var levelGroupNumOfMeasures: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        levelCards = createSlides()
        setUpSlideScrollView(slides: levelCards)
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let levelSelect = segue.destination as? LevelSelect {
            levelSelect.levelGroup = self.selectedLevelGroup
            levelSelect.numOfLevels = self.levelGroupNumOfMeasures
        }
    }
    

    @IBAction func unwindFromLevelGroupsToWelcome(_ sender: Any) {
        performSegue(withIdentifier: "fromLevelGroupsToWelcomeUSegue", sender: self)
    }
    

}
