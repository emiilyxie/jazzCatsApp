

/*:
 [Previous](@previous)
 
 # Level 2
 
 This level is a little harder now. Disenable "Enable Results" and press "Run My Code"
 
 On the bottom right, the arrows allow you to move between pages of your composition.
 
 In this level, transcribe the **trumpet** melody. This audio sample will use two pages.
 
 Even with the easiest of melodies, it's difficult, especially if you're not familliar with music. This audio sample took 10 minutes to transcribe for my dad, who casually plays the ukelele.
 
 Here are some transcription tips:
 * sing the melody out loud and get it ingrained into your head
 * guess & check constantly
 * beware of the rhythms -- even if you get the correct notes, the rhythm that's transcribed must also be correct to pass.
 
 Let's meet at level 3!
 
 [Next](@next)
 
 */


//#-hidden-code

import PlaygroundSupport
import SpriteKit
import UIKit

let sceneWidth = 720
let sceneHeight = 480

let staffBarHeight = 16
let staffBarNumber = 12
let staffTotalHeight = staffBarHeight * staffBarNumber
let staffHeightFromGround = sceneHeight / 2 - staffBarHeight * staffBarNumber / 2

let indentLength = 100
let numberOfMeasures = 2
let bpm = 4
let subdivision = 2
let totalDivision = numberOfMeasures * bpm * subdivision
let resultWidth = sceneWidth - indentLength
let divisionWidth = resultWidth / totalDivision

var maxPages = 2
var pages = [[Note]](repeating: [], count: maxPages)
var pageIndex = 0

var pg1Ans = [Set<String>](repeating: [], count: totalDivision)
var pg2Ans = [Set<String>](repeating: [], count: totalDivision)
//(lvl2Ans)
var hintNum = 0

func generateLvlAns() {
    pg1Ans[1] = ["A4"]
    pg1Ans[2] = ["F4"]
    pg1Ans[3] = ["D5"]
    pg1Ans[4] = ["C5"]
    pg1Ans[6] = ["A4"]
    pg1Ans[7] = ["F4"]
    pg1Ans[9] = ["D4"]
    pg1Ans[10] = ["G4"]
    
    pg2Ans[0] = ["F4"]
    pg2Ans[1] = ["G4"]
    pg2Ans[2] = ["A4"]
    pg2Ans[3] = ["D5"]
    pg2Ans[5] = ["E5"]
    pg2Ans[6] = ["F5"]
    pg2Ans[7] = ["C5"]
}

generateLvlAns()
let lvl2Ans = [pg1Ans, pg2Ans]

var myAns = Array(repeating: [Set<String>](repeating: [], count: totalDivision), count: maxPages)

class GameScene: SKScene {
    
    let barsNode = SKNode()
    var measureBar: SKSpriteNode!
    var selectedNoteType = NoteType.piano
    var currentMode = "addMode"
    //var buttonXPosition = 20
    var yayYouDidIt: SKSpriteNode!
    var sorryTryAgain: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        layoutScene()
        setUpPhysics()
        setUpButtons()
    }
    
    func layoutScene() {
        
        barsNode.position = CGPoint(x: 0, y: staffHeightFromGround)
        
        for i in 0...staffBarNumber - 1 {
            let staffBar = StaffBar(barIndex: i)
            staffBar.anchorPoint = CGPoint(x: 0, y: 0)
            staffBar.position = CGPoint(x: 0, y: (i * Int(staffBar.size.height)))
            //print(staffBar.position.y)
            staffBar.name = "staffBar"
            if i == 0 {
                continue
            }
                
            else if i % 2 == 0 {
                staffBar.drawLineThru()
            }
            //staffBar.colorDebug(i: i)
            barsNode.addChild(staffBar)
        }
        
        for i in 0...totalDivision - 1 {
            var lineWidth = 0
            if i % subdivision == 0 {
                lineWidth += 1
            }
            if i % (totalDivision / numberOfMeasures) == 0 {
                lineWidth += 2
            }
            if lineWidth == 0 {
                continue
            }
            else {
                let xPos = indentLength + i * divisionWidth
                let measureLine = SKShapeNode(rect: CGRect(x: xPos, y: 0, width: lineWidth, height: staffTotalHeight))
                measureLine.fillColor = UIColor.black
                measureLine.strokeColor = UIColor.clear
                barsNode.addChild(measureLine)
            }
        }
        
        let finalBar = SKSpriteNode(color: UIColor.black, size: CGSize(width: 6, height: staffTotalHeight))
        finalBar.position = CGPoint(x: indentLength + totalDivision * divisionWidth, y: Int(finalBar.size.height) / 2)
        finalBar.physicsBody = SKPhysicsBody(rectangleOf: finalBar.size)
        finalBar.physicsBody?.isDynamic = false
        finalBar.physicsBody?.categoryBitMask = PhysicsCategories.finalBarCategory
        finalBar.physicsBody?.contactTestBitMask = PhysicsCategories.measureBarCategory
        finalBar.physicsBody?.collisionBitMask = PhysicsCategories.none
        barsNode.addChild(finalBar)
        
        addChild(barsNode)
        
        measureBar = SKSpriteNode(color: UIColor.white, size: CGSize(width: 2, height: staffBarNumber * staffBarHeight + 30))
        //measureBar.anchorPoint = CGPoint(x: 0, y: 0)
        measureBar.position = CGPoint(x: indentLength - 20, y: staffHeightFromGround + staffBarNumber * staffBarHeight / 2 - 15)
        measureBar.physicsBody = SKPhysicsBody(rectangleOf: measureBar.size)
        measureBar.physicsBody?.categoryBitMask = PhysicsCategories.measureBarCategory
        measureBar.physicsBody?.contactTestBitMask = PhysicsCategories.noteCategory | PhysicsCategories.finalBarCategory
        measureBar.physicsBody?.collisionBitMask = PhysicsCategories.none
        measureBar.physicsBody?.affectedByGravity = false
        measureBar.physicsBody?.friction = 0
        measureBar.physicsBody?.linearDamping = 0
        //measureBar.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
        //measureBar.run(SKAction.moveTo(x: barsNode.mapSize.width, duration: 8))
        
        addChild(measureBar)
        
        let trebleClef = SKSpriteNode(imageNamed: "treble_clef.png")
        let trebleClefScaledSize = scaleNode(size: trebleClef.size, factor: Double(0.1))
        trebleClef.scale(to: trebleClefScaledSize)
        trebleClef.anchorPoint = CGPoint(x: 0, y: 0)
        trebleClef.position = CGPoint(x: 0, y: 0)
        barsNode.addChild(trebleClef)
        
        yayYouDidIt = SKSpriteNode(imageNamed: "you-did-it.jpeg")
        let yayYouDidItScaledSize = scaleNode(size: yayYouDidIt.size, factor: Double(0.5))
        yayYouDidIt.scale(to: yayYouDidItScaledSize)
        yayYouDidIt.position = CGPoint(x: frame.midX, y: frame.midY)
        yayYouDidIt.zPosition = -100
        yayYouDidIt.alpha = CGFloat(0)
        addChild(yayYouDidIt)
        
        sorryTryAgain = SKSpriteNode(imageNamed: "try-again.jpg")
        let sorryTryAgainScaledSize = scaleNode(size: sorryTryAgain.size, factor: Double(0.5))
        sorryTryAgain.scale(to: sorryTryAgainScaledSize)
        sorryTryAgain.position = CGPoint(x: frame.midX, y: frame.midY)
        sorryTryAgain.zPosition = -100
        sorryTryAgain.alpha = CGFloat(0)
        addChild(sorryTryAgain)
        
    }
    
    func setUpPhysics() {
        physicsWorld.gravity = CGVector(dx: 2, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    func setUpButtons() {
        //addButton(buttonImage: UIColor.orange, buttonAction: enterMode, buttonIndex: 0, name: "addButton")
        //addButton(buttonImage: UIColor.systemPink, buttonAction: enterMode, buttonIndex: 1, name: "eraseButton")
        //addButton(buttonImage: UIColor.purple, buttonAction: enterMode, buttonIndex: 2, name: "navigateButton")
        
        let topY = sceneHeight * 5 / 6
        let bottomY = sceneHeight / 6
        
        addButton(buttonImage: "play.png", buttonAction: enterMode, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: Int(frame.minX) + 50, y: topY))
        addButton(buttonImage: "pause.png", buttonAction: enterMode, buttonIndex: 4, name: "pauseButton", buttonPosition: CGPoint(x: Int(frame.minX) + 100, y: topY))
        addButton(buttonImage: "stop.png", buttonAction: enterMode, buttonIndex: 5, name: "stopButton", buttonPosition: CGPoint(x: Int(frame.minX) + 150, y: topY))
        
        
        addButton(buttonImage: "piano.png", buttonAction: selectNoteType, buttonIndex: 0, name: "pianoButton", buttonPosition: CGPoint(x: Int(frame.midX) - 25, y: bottomY + 25))
        addButton(buttonImage: "snare.png", buttonAction: selectNoteType, buttonIndex: 2, name: "snareButton", buttonPosition: CGPoint(x: Int(frame.midX) + 25, y: bottomY + 25))
        addButton(buttonImage: "cat.png", buttonAction: selectNoteType, buttonIndex: 4, name: "catButton", buttonPosition: CGPoint(x: Int(frame.midX) - 25, y: bottomY - 25))
        addButton(buttonImage: "eraser.png", buttonAction: enterMode, buttonIndex: 1, name: "eraseButton", buttonPosition: CGPoint(x: Int(frame.midX) + 25, y: bottomY - 25))
        //addButton(buttonImage: "sharp.png", buttonAction: enterMode, buttonIndex: 7, name: "sharpButton", buttonPosition: CGPoint(x: Int(frame.minX) + 50, y: bottomY))
        //addButton(buttonImage: "flat.png", buttonAction: enterMode, buttonIndex: 8, name: "flatButton", buttonPosition: CGPoint(x: Int(frame.minX) + 100, y: bottomY))
        
        addButton(buttonImage: "audio.png", buttonAction: playSample, buttonIndex: 0, name: "audioSampleButton", buttonPosition: CGPoint(x: Int(frame.midX) + 50, y: topY))
        addButton(buttonImage: "lightbulb.png", buttonAction: generateHint, buttonIndex: 0, name: "hintButton", buttonPosition: CGPoint(x: Int(frame.midX) + 100, y: topY))
        addButton(buttonImage: "check.png", buttonAction: submitAns, buttonIndex: 0, name: "submitButton", buttonPosition: CGPoint(x: Int(frame.midX) + 150, y: topY))
        
        
        //addButton(buttonImage: UIColor.green, buttonAction: generatePage, buttonIndex: 0, name: "generateNotes", buttonPosition: CGPoint(x: Int(frame.midX) + 200, y: bottomY))
        addButton(buttonImage: "rightArrow.png", buttonAction: nextPage, buttonIndex: 0, name: "nextPage", buttonPosition: CGPoint(x: Int(frame.midX) + 250, y: bottomY))
        addButton(buttonImage: "leftArrow.png", buttonAction: prevPage, buttonIndex: 0, name: "prevPage", buttonPosition: CGPoint(x: Int(frame.midX) + 200, y: bottomY))
    }
    
    func addButton(buttonImage: String, buttonAction: @escaping (Int) -> (), buttonIndex: Int, name: String, buttonPosition: CGPoint) {
        //let buttonYPosition = staffHeightFromGround - 20
        let newButton = Button(defaultButtonImage: buttonImage, action: buttonAction, index: buttonIndex, buttonName: name)
        newButton.position = CGPoint(x: buttonPosition.x, y: buttonPosition.y)
        //buttonXPosition += 40
        addChild(newButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            editNotes(touch: firstTouch)
        }
    }
    
    func editNotes(touch: UITouch) {
        var location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        switch currentMode {
        case "addMode": // if in addMode
            if barsNode.contains(location) {
                location = touch.location(in: barsNode)
                if location.x >= CGFloat(indentLength) {
                    let arrayVal = getStaffPosition(notePosition: location)
                    let noteVal = trebleNotes[arrayVal[1] + 1]
                    if !myAns[pageIndex][arrayVal[0]].contains(noteVal) {
                        let snappedLocation = snapNoteLocation(touchedPoint: location)
                        addNote(noteType: selectedNoteType, notePosition: snappedLocation)
                    }
                }
                
            }
        case "eraseMode": // if in eraseMode
            for node in touchedNodes {
                if let noteNode = node as? Note {
                    myAns[pageIndex][noteNode.positionInStaff[0]].remove(trebleNotes[noteNode.positionInStaff[1] + 1])
                    noteNode.removeFromParent()
                }
            }
        default: // not selected or navigateMode
            return
        }
    }
    
    func playSample(index: Int) {
        barsNode.run(SKAction.playSoundFileNamed("lvl2song.mp3", waitForCompletion: false))
    }
    
    func addNote(noteType: NoteType, notePosition: CGPoint) {
        let note = Note(type: noteType)
        note.name = "note"
        note.position = notePosition
        note.positionInStaff = getStaffPosition(notePosition: notePosition)
        note.physicsBody = SKPhysicsBody(rectangleOf: note.size)
        note.physicsBody?.isDynamic = false
        note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
        note.physicsBody?.contactTestBitMask = PhysicsCategories.measureBarCategory
        note.physicsBody?.collisionBitMask = PhysicsCategories.none
        //print(note.position)
        //print(note.positionInStaff)
        myAns[pageIndex][note.positionInStaff[0]].insert(trebleNotes[note.positionInStaff[1] + 1])
        pages[pageIndex].append(note)
        //print(myAns)
        barsNode.addChild(note)
    }
    
    func snapNoteLocation(touchedPoint: CGPoint) -> CGPoint {
        let divisionWidthFloat = CGFloat(divisionWidth)
        let indentLengthFloat = CGFloat(indentLength)
        let xPos = Int(round((touchedPoint.x - indentLengthFloat) / divisionWidthFloat) * divisionWidthFloat) + indentLength
        
        let staffBarHeightFloat = CGFloat(staffBarHeight)
        //print("before: \(touchedPoint.y)")
        let yPos = Int(round(touchedPoint.y / staffBarHeightFloat) * staffBarHeightFloat - (staffBarHeightFloat / 2))
        //print("after: \(yPos)")
        return CGPoint(x: xPos, y: yPos)
    }
    
    func getStaffPosition(notePosition: CGPoint) -> Array<Int> {
        let xPos = (Int(notePosition.x) - indentLength + 15) / divisionWidth
        let yPos = Int(notePosition.y) / staffBarHeight
        return [xPos, yPos]
    }
    
    func enterMode(index: Int) {
        switch index {
        case 0:
            currentMode = "addMode"
        case 1:
            currentMode = "eraseMode"
        case 2:
            currentMode = "navigateMode"
        case 3:
            currentMode = "playMode"
            measureBar.physicsBody?.velocity = CGVector(dx: 150, dy: 0)
        case 4:
            measureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        case 5:
            measureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            //measureBar.position = CGPoint(x: indentLength - 20, y: staffHeightFromGround + staffBarNumber * staffBarHeight / 2)
            measureBar.run(SKAction.move(to: CGPoint(x: indentLength - 20, y: staffHeightFromGround + staffBarNumber * staffBarHeight / 2), duration: 0))
        case 6:
            measureBar.run(SKAction.move(to: CGPoint(x: indentLength - 20, y: staffHeightFromGround + staffBarNumber * staffBarHeight / 2), duration: 0))
        default:
            currentMode = "addMode"
        }
    }
    
    func selectNoteType(index: Int) {
        currentMode = "addMode"
        switch index {
        case 0:
            selectedNoteType = NoteType.piano
        case 1:
            selectedNoteType = NoteType.bass
        case 2:
            selectedNoteType = NoteType.snare
        case 3:
            selectedNoteType = NoteType.hihat
        case 4:
            selectedNoteType = NoteType.cat
        default:
            selectedNoteType = NoteType.piano
        }
    }
    
    func nextPage(index: Int) {
        if pageIndex < maxPages - 1 {
            for note in pages[pageIndex] {
                note.isHidden = true
                note.physicsBody?.categoryBitMask = PhysicsCategories.none
            }
            pageIndex += 1
            hintNum = 0
            //print("now on page \(pageIndex)")
            for note in pages[pageIndex] {
                note.isHidden = false
                note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
            }
        }
    }
    
    func prevPage(index: Int) {
        if pageIndex >= 1 {
            for note in pages[pageIndex] {
                note.isHidden = true
                note.physicsBody?.categoryBitMask = PhysicsCategories.none
            }
            pageIndex -= 1
            hintNum = 0
            //print("now on page \(pageIndex)")
            for note in pages[pageIndex] {
                note.isHidden = false
                note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
            }
        }
    }
    
    func submitAns(index: Int) {
        if myAns.elementsEqual(lvl2Ans) {
            yayYouDidIt.zPosition = 100
            yayYouDidIt.run(SKAction.fadeIn(withDuration: 0.5))
        }
        else {
            sorryTryAgain.zPosition = 100
            let fadeInOut = SKAction.sequence([SKAction.fadeIn(withDuration: 0.5), SKAction.fadeOut(withDuration: 0.5)])
            sorryTryAgain.run(fadeInOut) {
                self.sorryTryAgain.zPosition = -100
            }
        }
    }
    
    func generateHint(index: Int) {
        if hintNum < lvl2Ans[pageIndex].count {
            for pitch in lvl2Ans[pageIndex][hintNum] {
                let xPos = hintNum * divisionWidth + indentLength
                let yPos = (trebleNotes.firstIndex(of: pitch)! - 1) * staffBarHeight + 10
                addNote(noteType: selectedNoteType, notePosition: CGPoint(x: xPos, y: yPos))
            }
            hintNum += 1
        }
    }
    
    func generatePage(index: Int) {
        var count = 0
        let noteSet = lvl2Ans[pageIndex]
        for note in noteSet {
            if !note.isEmpty {
                for pitch in note {
                    let xPos = count * divisionWidth + indentLength
                    let yPos = trebleNotes.firstIndex(of: pitch)! * staffBarHeight
                    addNote(noteType: selectedNoteType, notePosition: CGPoint(x: xPos, y: yPos))
                    count += 1
                }
            }
            else {
                count += 1
            }
        }
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.noteCategory | PhysicsCategories.measureBarCategory {
            if let hitInstrument = contact.bodyA.node?.name != nil ? contact.bodyA.node as? Note : contact.bodyB.node as? Note {
                //print(hitInstrument.noteType)
                //print(hitInstrument.getAudioFile())
                let audioFile = hitInstrument.getAudioFile()
                hitInstrument.run(SKAction.playSoundFileNamed(audioFile, waitForCompletion: true))
            }
        }
        
        if contactMask == PhysicsCategories.measureBarCategory | PhysicsCategories.finalBarCategory {
            if pageIndex < maxPages - 1 {
                nextPage(index: 0)
                enterMode(index: 6)
            }
            else {
                enterMode(index: 5)
            }
        }
    }
}

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: sceneWidth, height: 480))
let scene = GameScene(size: sceneView.bounds.size)
scene.backgroundColor = UIColor(red: 0.97, green: 0.92, blue: 0.91, alpha: 1.00)
scene.anchorPoint = CGPoint(x: scene.frame.minX, y: scene.frame.minY)
// Set the scale mode to scale to fit the window
scene.scaleMode = .aspectFit
// Present the scene
//sceneView.showsPhysics = true
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//GameScene.self

//#-end-hidden-code


