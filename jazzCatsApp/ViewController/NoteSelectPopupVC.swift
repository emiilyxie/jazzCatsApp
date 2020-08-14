
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
    
    var sounds = GameUser.sounds
    var selectedNote: String = ""
    @IBOutlet weak var header: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        
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
        setUpGraphics()
    }
    
    func setUpGraphics() {
        DispatchQueue.main.async {
            self.view.backgroundColor = UIColor.clear
            UIStyling.setPopupBackground(popupView: self.bgView)
            UIStyling.setButtonStyle(button: self.cancelButton)
            self.header.textColor = ColorPalette.lineColor
            self.cancelButton.layer.cornerRadius = 10
            self.collectionView.backgroundColor = ColorPalette.friendlyGold
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sounds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noteSelection", for: indexPath) as! NoteSelectCell

        cell.noteCellLabel.text = sounds[indexPath.row].name
        cell.noteCellLabel.font = UIFont(name: "Gaegu-Regular", size: CGFloat(16))
        cell.noteCellLabel.textColor = ColorPalette.lineColor
        cell.noteCellImage.image = UIImage(named: sounds[indexPath.row].id)
        cell.backgroundColor = ColorPalette.unselectedButton
        cell.layer.masksToBounds = true
        cell.layer.borderColor = ColorPalette.lineColor.cgColor
        cell.layer.borderWidth = CGFloat(2)
        cell.layer.cornerRadius = CGFloat(25)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(sounds[indexPath.row].id)
        selectedNote = sounds[indexPath.row].id
        
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let noOfCellsInRow = 4

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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        //location is relative to the current view
        // do something with the touched point
        if touch?.view != bgView {
            self.cancelButton(UIButton())
        }
    }
}
