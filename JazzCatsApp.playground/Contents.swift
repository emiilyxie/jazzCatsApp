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
let divisionWidth = (sceneWidth - indentLength) / totalDivision

class GameScene: SKScene {
    
    let barsNode = SKNode()
    var measureBar: SKSpriteNode!
    var selectedNoteType = NoteType.piano
    var currentMode = "addMode"
    //var buttonXPosition = 20
    
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
        
        addChild(barsNode)
        
        measureBar = SKSpriteNode(color: UIColor.white, size: CGSize(width: 2, height: staffBarNumber * staffBarHeight + 30))
        //measureBar.anchorPoint = CGPoint(x: 0, y: 0)
        measureBar.position = CGPoint(x: indentLength - 20, y: staffHeightFromGround + staffBarNumber * staffBarHeight / 2 - 15)
        measureBar.physicsBody = SKPhysicsBody(rectangleOf: measureBar.size)
        measureBar.physicsBody?.categoryBitMask = PhysicsCategories.measureBarCategory
        measureBar.physicsBody?.contactTestBitMask = PhysicsCategories.noteCategory
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
        
        addButton(buttonImage: UIColor.white, buttonAction: enterMode, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: Int(frame.minX) + 50, y: topY))
        addButton(buttonImage: UIColor.gray, buttonAction: enterMode, buttonIndex: 4, name: "pauseButton", buttonPosition: CGPoint(x: Int(frame.minX) + 100, y: topY))
        addButton(buttonImage: UIColor.black, buttonAction: enterMode, buttonIndex: 5, name: "stopButton", buttonPosition: CGPoint(x: Int(frame.minX) + 150, y: topY))
        
        addButton(buttonImage: UIColor.red, buttonAction: selectNoteType, buttonIndex: 0, name: "pianoButton", buttonPosition: CGPoint(x: Int(frame.midX) - 100, y: bottomY))
        addButton(buttonImage: UIColor.blue, buttonAction: selectNoteType, buttonIndex: 1, name: "bassButton", buttonPosition: CGPoint(x: Int(frame.midX) - 50, y: bottomY))
        addButton(buttonImage: UIColor.green, buttonAction: selectNoteType, buttonIndex: 2, name: "snareButton", buttonPosition: CGPoint(x: Int(frame.midX), y: bottomY))
        addButton(buttonImage: UIColor.yellow, buttonAction: selectNoteType, buttonIndex: 3, name: "hihatButton", buttonPosition: CGPoint(x: Int(frame.midX) + 50, y: bottomY))
        addButton(buttonImage: UIColor.systemPink, buttonAction: enterMode, buttonIndex: 1, name: "eraseButton", buttonPosition: CGPoint(x: Int(frame.midX) + 100, y: bottomY))
    }
    
    func addButton(buttonImage: UIColor, buttonAction: @escaping (Int) -> (), buttonIndex: Int, name: String, buttonPosition: CGPoint) {
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
        barsNode.addChild(note)
    }
    
    func snapNoteLocation(touchedPoint: CGPoint) -> CGPoint {
        let divisionWidthFloat = CGFloat(divisionWidth)
        let xPos = Int(round(touchedPoint.x / divisionWidthFloat) * divisionWidthFloat) - 15
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
            measureBar.position = CGPoint(x: indentLength - 20, y: staffHeightFromGround + staffBarNumber * staffBarHeight / 2)
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
        default:
            selectedNoteType = NoteType.piano
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.noteCategory | PhysicsCategories.measureBarCategory {
            if let hitInstrument = contact.bodyA.node?.name != nil ? contact.bodyA.node as? Note : contact.bodyB.node as? Note {
                //print(hitInstrument.noteType)
                //let type = hitInstrument.noteType
                let audioFile = hitInstrument.getAudioFile()
                hitInstrument.run(SKAction.playSoundFileNamed(audioFile, waitForCompletion: true))
                /*
                switch type {
                case .piano:
                    hitInstrument.run(SKAction.playSoundFileNamed("kitten-meow.mp3", waitForCompletion: true))
                case .bass:
                    hitInstrument.run(SKAction.playSoundFileNamed("piano.m4a", waitForCompletion: true))
                default:
                    hitInstrument.run(SKAction.playSoundFileNamed("kitten-meow.mp3", waitForCompletion: true))
                }
 */
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
