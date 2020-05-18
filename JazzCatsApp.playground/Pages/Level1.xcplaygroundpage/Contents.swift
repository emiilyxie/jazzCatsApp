
/*:
 
 [Previous](@previous)
 
 # Level 1

 First, disenable "Enable Results" and press "Run My Code" to bring up the game. It takes a little while to load the first time, so read this quick & easy tutorial while you're at it.

 On the top left: play, pause, and stop the music that you've composed. The white measure bar will fly across the view and hit notes.
 
 On the top right:
 * Audio: click to hear the sample that you will transcribe this level
 * Lightbulb: click to get a hint
 * Checkmark: check your answer
 
 On the bottom:
 * Piano or cat: select an instrument, and click anywhere in the staff to place a note
 * Drum: will select drum as an instrument. The drum won't play a particular pitch, but where it's placed will count towards the answer
 * Eraser: select the eraser tool, and click on a note to erase it
 
 Let's get transcribing (the piano melody). Bonus points if you know the name and composer of this sample.
 
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
let bpm = 3
let subdivision = 2
let totalDivision = numberOfMeasures * bpm * subdivision
let resultWidth = sceneWidth - indentLength
let divisionWidth = resultWidth / totalDivision

var lvl1Ans = [Set<String>](repeating: [], count: totalDivision)
var myAns = [Set<String>](repeating: [], count: totalDivision)
var hintNum = 0

func generateLvlAns() {
    lvl1Ans[0] = ["D5"]
    lvl1Ans[2] = ["G4"]
    lvl1Ans[3] = ["A4"]
    lvl1Ans[4] = ["B4"]
    lvl1Ans[5] = ["C5"]
    lvl1Ans[6] = ["D5"]
    lvl1Ans[8] = ["G4"]
    lvl1Ans[10] = ["G4"]
}

generateLvlAns()

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
        let trebleClefScaledSize = CGSize(width: trebleClef.frame.width / 10, height: trebleClef.frame.height / 10)
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
        //addButton(buttonImage: "rightArrow.png", buttonAction: nextPage, buttonIndex: 0, name: "generateNotes", buttonPosition: CGPoint(x: Int(frame.midX) + 250, y: bottomY))
        //addButton(buttonImage: "leftArrow.png", buttonAction: prevPage, buttonIndex: 0, name: "generateNotes", buttonPosition: CGPoint(x: Int(frame.midX) + 200, y: bottomY))
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
                    let snappedLocation = snapNoteLocation(touchedPoint: location)
                    addNote(noteType: selectedNoteType, notePosition: snappedLocation)
                }
                
            }
        case "eraseMode": // if in eraseMode
            let topNode = touchedNodes.first
            if topNode?.name == "note" {
                if let note = topNode as? Note {
                    myAns[note.positionInStaff[0]].remove(trebleNotes[note.positionInStaff[1] + 1])
                    note.removeFromParent()
                }
            }
            else { return }
        default: // not selected or navigateMode
            return
        }
    }
    
    func playSample(index: Int) {
        barsNode.run(SKAction.playSoundFileNamed("lvl1song.mp3", waitForCompletion: false))
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
        myAns[note.positionInStaff[0]].insert(trebleNotes[note.positionInStaff[1] + 1])
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
            measureBar.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
        case 4:
            measureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        case 5:
            measureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            //measureBar.position = CGPoint(x: indentLength - 20, y: staffHeightFromGround + staffBarNumber * staffBarHeight / 2)
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
    
    func submitAns(index: Int) {
        if myAns.elementsEqual(lvl1Ans) {
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
        if hintNum < lvl1Ans.count - 1 {
            for pitch in lvl1Ans[hintNum] {
                let xPos = hintNum * divisionWidth + indentLength
                let yPos = (trebleNotes.firstIndex(of: pitch)! - 1) * staffBarHeight + 10
                addNote(noteType: selectedNoteType, notePosition: CGPoint(x: xPos, y: yPos))
            }
            hintNum += 1
        }
    }
    
    func generatePage(index: Int) {
        var count = 0
        let noteSet = lvl1Ans
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
                /*
                 switch type {
                 case .piano:
                 hitInstrument.run(SKAction.playSoundFileNamed("kitten-meow.mp3", waitForCompletion: true))
                 print(hitInstrument.getAudioFile())
                 case .bass:
                 hitInstrument.run(SKAction.playSoundFileNamed("piano.m4a", waitForCompletion: true))
                 default:
                 hitInstrument.run(SKAction.playSoundFileNamed("kitten-meow.mp3", waitForCompletion: true))
                 }
                 */
            }
        }
        
        if contactMask == PhysicsCategories.measureBarCategory | PhysicsCategories.finalBarCategory {
            enterMode(index: 5)
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

