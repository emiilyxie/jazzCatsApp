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
    @IBOutlet weak var tapToContinue: UILabel!
    
    
    var whereToPress = SKSpriteNode()
    
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
        
        UIStyling.setButtonStyle(button: buttonFrame)
        
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
        whereToPress.removeFromParent()
        tapToContinue.isHidden = false
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
            tapToContinue.isHidden = true
            
            guard let button = musicScene.buttons.object(forKey: buttonName as? NSString) else {
                print("cant get button")
                return
            }
            let sceneRect = button.calculateAccumulatedFrame()
            continueLoc = sceneRect
            whereToPress = SKSpriteNode(color: UIColor.blue.withAlphaComponent(CGFloat(0.3)), size: CGSize(width: sceneRect.width, height: sceneRect.height))
            whereToPress.anchorPoint = CGPoint(x: 0, y: 0)
            whereToPress.position = CGPoint(x: sceneRect.minX, y: sceneRect.minY)
            musicScene.addChild(whereToPress)
            
            let action = {(_: CGPoint?) -> () in
                button.action(button, button.index)
            }
            progressAction = action
            
        case ("progress-rect", let rect):
            canContinue = false
            tapToContinue.isHidden = true
            guard let rectDict = rect as? Dictionary<String, Any> else {
                print("cant parse rect")
                return
            }
            
            guard let note = rectDict["note"] as? Array<CGFloat>,
                let size = rectDict["size"] as? CGFloat else {
                print("cant get dict note")
                    return
            }
            
            //let staffOrigin = musicScene.staffPosToScenePos(staffPos: [rectArray[0], rectArray[1]])
            //let staffOrigin = musicScene.noteInfoToScenePos(noteInfo: [rectArray[0], rectArray[1]])
            let staffOrigin = musicScene.noteInfoToScenePos(noteInfo: note)
            let rectOrigin = musicScene.convert(staffOrigin, from: musicScene.barsNode)
            print("rect origin: \(rectOrigin)")
            let rectDiameter = CGFloat(size)
            let rectRadius = rectDiameter/2
            let sceneRect = CGRect(x: rectOrigin.x - rectRadius, y: rectOrigin.y - rectRadius, width: rectDiameter, height: rectDiameter)
            continueLoc = sceneRect
            whereToPress = SKSpriteNode(color: UIColor.blue.withAlphaComponent(CGFloat(0.3)), size: CGSize(width: rectDiameter, height: rectDiameter))
            whereToPress.anchorPoint = CGPoint(x: 0, y: 0)
            whereToPress.position = CGPoint(x: sceneRect.minX, y: sceneRect.minY)
            musicScene.addChild(whereToPress)
            
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
            progressAction(nil)
            currentTutorialPage += 1
            nextPage()
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
