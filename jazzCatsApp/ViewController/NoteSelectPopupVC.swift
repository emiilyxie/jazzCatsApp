
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
    
    var availableNotes: Array<String> = []
    var selectedNote: String = ""
    @IBOutlet weak var collectionViewPopup: UICollectionView!
    
    override func viewWillAppear(_ animated: Bool) {
        availableNotes = Array(GameUser.sounds.keys)
        
        guard let parentVC = self.parent as! GameViewController? else {
            return
        }
        
        if let musicScene = parentVC.currentScene as? MusicScene {
            selectedNote = musicScene.selectedNote
        }
        else {
            print("something's weird here")
            return
        }
        
        parentVC.currentScene?.isUserInteractionEnabled = false
        parentVC.currentScene?.isPaused = true
        self.view.isUserInteractionEnabled = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(CGFloat(0.8))
        self.collectionViewPopup.backgroundColor = ColorPalette.melon

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
        guard let parentVC = self.parent as! GameViewController? else {
            print("cant get parentvc")
            return
        }
        parentVC.currentScene?.isPaused = false
        parentVC.currentScene?.isUserInteractionEnabled = true
        self.view.removeFromSuperview()
    }
    
    
    @IBAction func selectButton(_ sender: UIButton) {
        guard let parentVC = self.parent as! GameViewController?,
            let musicScene = parentVC.currentScene as! MusicScene?,
            let noteButton = musicScene.buttons.object(forKey: "addNotesButton")
        else {
            print("cant get parentvc or scene or button ouch")
            self.view.removeFromSuperview()
            return
        }
        
        musicScene.selectedNote = selectedNote
        noteButton.defaultButton = SKTexture(imageNamed: selectedNote)
        noteButton.run(SKAction.setTexture(noteButton.defaultButton))
        musicScene.currentMode = "addMode"
        
        self.view.removeFromSuperview()
        parentVC.currentScene?.isPaused = false
        parentVC.currentScene?.isUserInteractionEnabled = true

    }
    

}
