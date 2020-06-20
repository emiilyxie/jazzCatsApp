
//
//  NoteSelectPopupVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 6/17/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit

class NoteSelectPopupVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var availableNotes: Array<String>!
    var selectedNote: String!
    
    override func viewWillAppear(_ animated: Bool) {
        availableNotes = Array(GameUser.sounds.keys)
        
        guard let parentVC = self.parent as! GameViewController? else {
            return
        }
        if let levelScene = parentVC.currentScene as? LevelTemplate {
            selectedNote = levelScene.selectedNote
        }
        else {
            print("not level template")
        }
        
        if let freestyleScene = parentVC.currentScene as? Freestyle {
            selectedNote = freestyleScene.selectedNote
        }
        else {
            print("not freestyle")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(0.8))

    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return availableNotes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteSelection", for: indexPath) as! NoteSelectCell

        cell.noteCellLabel.text = String(availableNotes[indexPath.row])
        cell.noteCellImage.image = UIImage(named: availableNotes[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(availableNotes[indexPath.row])
        selectedNote = availableNotes[indexPath.row]
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 6

        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout

        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))

        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))

        return CGSize(width: size, height: size)
    }
    
    @IBAction func cancelButton(_ sender: UIButton) {
        self.view.removeFromSuperview()
    }
    
    
    @IBAction func selectButton(_ sender: UIButton) {
        guard let parentVC = self.parent as! GameViewController? else {
            return
        }
        if let levelScene = parentVC.currentScene as? LevelTemplate {
            levelScene.selectedNote = selectedNote
            levelScene.noteButton.defaultButton = SKTexture(imageNamed: selectedNote)
            levelScene.noteButton.texture = SKTexture(imageNamed: selectedNote)
            levelScene.currentMode = "addMode"
        }
        else {
            print("not level template")
        }
        
        if let freestyleScene = parentVC.currentScene as? Freestyle {
            //freestyleScene.selectedNote = selectedNote
            freestyleScene.currentMode = "addMode"
        }
        else {
            print("not freestyle")
        }
        
        self.view.removeFromSuperview()
    }
    

}
