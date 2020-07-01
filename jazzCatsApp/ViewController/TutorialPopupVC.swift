//
//  TutorialPopupVC.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 6/28/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit

class TutorialPopupVC: UIViewController {

    var tutorialData: Array<Dictionary<String, Any>> = []
    var currentTutorialPage: Int = 0
    var canContinue = true
    var continueLoc: CGRect?
    var progressAction: (CGPoint?) -> () =  { (optPoint: CGPoint?) -> () in  }
    weak var parentVC: GameViewController?
    weak var currentScene: MusicScene?
    
    
    @IBOutlet weak var dialogueView: UIView!
    @IBOutlet weak var dialogueBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dialogueTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonFrame: UIButton!
    @IBOutlet weak var dialogueBox: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setUpGraphics()
        
        guard let parentVC = self.parent as! GameViewController? else {
            print("parent vc - less")
            return
        }
        guard let currentScene = parentVC.currentScene as! MusicScene? else {
            print("scene - less")
            return
        }
        
        self.parentVC = parentVC
        self.currentScene = currentScene
    }
    
    func setUpGraphics() {
        self.view.backgroundColor = .clear
        
        buttonFrame.layer.masksToBounds = true
        buttonFrame.layer.cornerRadius = 20
        buttonFrame.layer.borderWidth = 3
        buttonFrame.layer.borderColor = UIColor.black.cgColor
        buttonFrame.backgroundColor = .white
        dialogueBox.textColor = .black
    }
    
    func startTutorial() {
        nextPage()
        resetUserInteraction()
    }
    
    func resetUserInteraction()  {
        guard let currentScene = currentScene else {
            print("cant detect the vc and scene")
            return
        }
        
        currentScene.isUserInteractionEnabled = false
        //currentScene.isPaused = true
        for button in currentScene.buttons.dictionaryRepresentation().values {
            button.isUserInteractionEnabled = false
        }
        currentScene.buttons.object(forKey: "homeButton")?.isUserInteractionEnabled = true
        
        self.view.isUserInteractionEnabled = true
    }
    
    func nextPage() {
        NSLayoutConstraint.deactivate([dialogueTopConstraint])
        NSLayoutConstraint.activate([dialogueBottomConstraint])
        canContinue = true
        continueLoc = nil
        progressAction = { (optPoint: CGPoint?) -> () in  }
        if currentTutorialPage < tutorialData.count {
            for field in tutorialData[currentTutorialPage] {
                let key = field.key
                let val = field.value
                
                handleData(key: key, val: val)
            }
        }
    }
    
    func handleData(key: String, val: Any) {
        guard let musicScene = currentScene else {
            print("current scene weird")
            return
        }
        
        switch (key, val) {
            
        case ("text", let content):
            dialogueBox.text = content as? String
            
        case ("progress-button", let buttonName):
            canContinue = false
            let button = musicScene.buttons.object(forKey: buttonName as? NSString)
            guard let scenePos = button?.frame.origin else { return }
            let sceneRect = CGRect(x: scenePos.x, y: scenePos.y, width: 100, height: 100)
            continueLoc = sceneRect
            
        case ("progress-rect", let rect):
            canContinue = false
            guard let rectArray = rect as? Array<Int> else {
                print("cant parse rect")
                return
            }
            let staffOrigin = musicScene.staffPosToScenePos(staffPos: [rectArray[0], rectArray[1]])
            let rectOrigin = musicScene.convert(staffOrigin, from: musicScene.barsNode)
            print("rect origin: \(rectOrigin)")
            let rectDiameter = CGFloat(rectArray[2])
            let rectRadius = rectDiameter/2
            let viewRect = CGRect(x: rectOrigin.x - rectRadius, y: rectOrigin.y - rectRadius, width: rectDiameter, height: rectDiameter)
            continueLoc = viewRect
            
        case ("progress-action", "add-note" as String):
            let addNoteProgress = { (location: CGPoint?) -> () in
                if let noteLocation = location {
                    let noteBarsLocation = musicScene.convert(noteLocation, to: musicScene.barsNode)
                    musicScene.addNote(noteType: musicScene.selectedNote, notePosition: noteBarsLocation)
                }
            }
            progressAction = addNoteProgress
        
        case ("progress-action", "dismiss" as String):
            progressAction = { (_: CGPoint?) -> () in
                self.view.removeFromSuperview()
            }
            
        case ("is-enabled", let buttons):
            guard let buttonNames = buttons as? Array<String> else {
                print("button names are weird")
                return
            }
            for buttonName in buttonNames {
                currentScene?.buttons.object(forKey: buttonName as NSString)?.isUserInteractionEnabled = true
            }
        
        case ("text-position", let position):
            NSLayoutConstraint.deactivate([dialogueBottomConstraint])
            if position as? String == "top" {
                NSLayoutConstraint.activate([dialogueTopConstraint])
            }
            
        default:
            print("key not recognized")
        }
    }
    
    @IBAction func buttonFramePressed(_ sender: UIButton) {
        if canContinue {
            currentTutorialPage += 1
            nextPage()
            progressAction(nil)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard let touchedLocation = touches.first?.location(in: self.view) else {
            return
        }
        guard let scenePoint = currentScene?.convertPoint(fromView: touchedLocation) else {
            print("cant convert pt")
            return
        }
        if let continueRect = continueLoc {
            if continueRect.contains(scenePoint) {
                currentTutorialPage += 1
                canContinue = true
                progressAction(CGPoint(x: continueRect.midX, y: continueRect.midY))
                nextPage()
            }
        }
        else {
            progressAction(nil)
        }
    }
    
}
