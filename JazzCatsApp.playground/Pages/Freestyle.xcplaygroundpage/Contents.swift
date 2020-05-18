
/*:
 
 [Previous](@previous)
 
 # Freestyle Mode
 
 Freestyle mode! Create your own Jazzcat compositions. Explore musical ideas. Show your amazing creations to your friends.
 
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
//#-end-hidden-code
//: Before you get started, you can edit the number of measures per page, beats per measure,  subdivision per beat, and tempo (measure bar velocity) by changing any of the values below. (Make sure they're integers)
let numberOfMeasures = /*#-editable-code number of repetitions*/2/*#-end-editable-code*/
let bpm = /*#-editable-code number of repetitions*/4/*#-end-editable-code*/
let subdivision = /*#-editable-code number of repetitions*/2/*#-end-editable-code*/
let tempo = /*#-editable-code number of repetitions*/200/*#-end-editable-code*/
//#-hidden-code
let totalDivision = numberOfMeasures * bpm * subdivision
let divisionWidth = (sceneWidth - indentLength) / totalDivision
//#-end-hidden-code
//: Even change up the length of the song! (Make sure they're integers)
var maxPages = /*#-editable-code number of repetitions*/16/*#-end-editable-code*/

//: Now, hit "Run My Code" !

//#-hidden-code
var pages = [[Note]](repeating: [], count: maxPages)
var pageIndex = 0

class GameScene: SKScene {
    
    let barsNode = SKNode()
    var measureBar: SKSpriteNode!
    var selectedNoteType = NoteType.piano
    var currentMode = "addMode"
    

    //var pages: [[Set<Int>]] = []
    //var sampleNotes = [Set<Int>](repeating: [], count: totalDivision)
    
    override func didMove(to view: SKView) {
        layoutScene()
        setUpPhysics()
        setUpButtons()
        //extraDebug()
    }
    
    func layoutScene() {
        
        barsNode.position = CGPoint(x: 0, y: staffHeightFromGround)
        
        for i in 0...staffBarNumber - 1 {
            let staffBar = StaffBar(barIndex: i)
            staffBar.anchorPoint = CGPoint(x: 0, y: 0)
            staffBar.position = CGPoint(x: 0, y: (i * Int(staffBar.size.height)))
            print(staffBar.position.y)
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
        //let trebleClefScaledSize = CGSize(width: trebleClef.frame.width / 10, height: trebleClef.frame.height / 10)
        trebleClef.scale(to: trebleClefScaledSize)
        trebleClef.anchorPoint = CGPoint(x: 0, y: 0)
        trebleClef.position = CGPoint(x: 0, y: 0)
        barsNode.addChild(trebleClef)
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
        addButton(buttonImage: "sharp.png", buttonAction: enterMode, buttonIndex: 7, name: "sharpButton", buttonPosition: CGPoint(x: Int(frame.minX) + 50, y: bottomY))
        addButton(buttonImage: "flat.png", buttonAction: enterMode, buttonIndex: 8, name: "flatButton", buttonPosition: CGPoint(x: Int(frame.minX) + 100, y: bottomY))
        
        //addButton(buttonImage: UIColor.green, buttonAction: generatePage, buttonIndex: 0, name: "generateNotes", buttonPosition: CGPoint(x: Int(frame.midX) + 200, y: bottomY))
        addButton(buttonImage: "rightArrow.png", buttonAction: nextPage, buttonIndex: 0, name: "nextPage", buttonPosition: CGPoint(x: Int(frame.midX) + 250, y: bottomY))
        addButton(buttonImage: "leftArrow.png", buttonAction: prevPage, buttonIndex: 0, name: "prevPage", buttonPosition: CGPoint(x: Int(frame.midX) + 200, y: bottomY))
 
    }
    /*
    
    func extraDebug() {
        sampleNotes[0] = [8]
        sampleNotes[2] = [4]
        sampleNotes[3] = [5]
        sampleNotes[4] = [6]
        sampleNotes[5] = [7]
        sampleNotes[6] = [8]
        sampleNotes[8] = [4]
        sampleNotes[10] = [4]
        
        pages.append(sampleNotes)
    }
 */
 
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
                topNode?.removeFromParent()
            }
            else { return }
        case "sharpMode":
            let topNode = touchedNodes.first
            if let noteNode = topNode as? Note {
                if noteNode.isFlat {
                    noteNode.toggleFlat()
                    noteNode.removeAllChildren()
                }
                noteNode.toggleSharp()
                if noteNode.isSharp {
                    let sharp = SKSpriteNode(imageNamed: "sharp.png")
                    sharp.size = scaleNode(size: sharp.size, factor: Double(0.05))
                    sharp.position = CGPoint(x: -20, y: 0)
                    noteNode.addChild(sharp)
                }
                else {
                    noteNode.removeAllChildren()
                }
            }
        case "flatMode":
            let topNode = touchedNodes.first
            if let noteNode = topNode as? Note {
                if noteNode.isSharp {
                    noteNode.toggleSharp()
                    noteNode.removeAllChildren()
                }
                noteNode.toggleFlat()
                if noteNode.isFlat {
                    let flat = SKSpriteNode(imageNamed: "flat.png")
                    flat.size = scaleNode(size: flat.size, factor: Double(0.025))
                    flat.position = CGPoint(x: -20, y: 0)
                    noteNode.addChild(flat)
                }
                else {
                    noteNode.removeAllChildren()
                }
            }
        default: // not selected or navigateMode
            return
        }
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
        pages[pageIndex].append(note)
        barsNode.addChild(note)
    }
    
    func snapNoteLocation(touchedPoint: CGPoint) -> CGPoint {
        print("division Width: \(divisionWidth)")
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
            measureBar.physicsBody?.velocity = CGVector(dx: tempo, dy: 0)
        case 4:
            measureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        case 5:
            measureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            measureBar.position = CGPoint(x: indentLength - 20, y: staffHeightFromGround + staffBarNumber * staffBarHeight / 2)
        case 6:
            measureBar.run(SKAction.move(to: CGPoint(x: indentLength, y: staffHeightFromGround + staffBarNumber * staffBarHeight / 2), duration: 0))
        case 7:
            currentMode = "sharpMode"
        case 8:
            currentMode = "flatMode"
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
            for note in pages[pageIndex] {
                note.isHidden = false
                note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
            }
        }
    }
    
    /*
    func generatePage(index: Int) {
        var count = 0
        let noteSet = pages[index]
        for note in noteSet {
            if !note.isEmpty {
                for pitch in note {
                    let xPos = count * divisionWidth + indentLength
                    let yPos = pitch * staffBarHeight
                    addNote(noteType: selectedNoteType, notePosition: CGPoint(x: xPos, y: yPos))
                    count += 1
                }
            }
            else {
                count += 1
            }
        }
    }
 */
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.noteCategory | PhysicsCategories.measureBarCategory {
            if let hitInstrument = contact.bodyA.node?.name != nil ? contact.bodyA.node as? Note : contact.bodyB.node as? Note {
                //print(hitInstrument.noteType)
                print(hitInstrument.getAudioFile())
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
sceneView.presentScene(scene)

PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
//GameScene.self

//#-end-hidden-code
