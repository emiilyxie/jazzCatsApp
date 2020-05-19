//
//  FreestyleScene.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/18/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

public let staffBarHeight = 32
public let staffBarNumber = 12

public let indentLength = 100

public class LevelTemplate: SKScene {

    let gameCamera = GameCamera()
    
    public var staffTotalHeight: Int!
    public var staffHeightFromGround: Int!

    public var numberOfMeasures: Int!
    public var bpm: Int!
    public var subdivision: Int!
    public var totalDivision: Int!
    public var resultWidth: Int!
    public var divisionWidth: Int!

    public var maxPages: Int!
    public var pages: Array<Array<Note>>!
    public var pageIndex = 0
    
    var bgNode: SKSpriteNode!
    let barsNode = SKNode()
    var measureBar: SKSpriteNode!
    var selectedNoteType = NoteType.piano
    var currentMode = "addMode"
    var yayYouDidIt: SKSpriteNode!
    var sorryTryAgain: SKSpriteNode!
    
    var file: AKAudioFile!
    var sampler = AKAppleSampler()
    
    var lvlAns: Array<[Set<String>]>!
    var myAns: Array<[Set<String>]>!
    var hintNum = 0
    
    public override func didMove(to view: SKView) {
        //setUpVars()
        layoutScene()
        setUpPhysics()
        setUpButtons()
        setUpSound()
    }

    /*
    func setUpVars() {
        staffTotalHeight = staffBarHeight * staffBarNumber
        staffHeightFromGround = sceneHeight / 2 - staffBarHeight * staffBarNumber / 2
        
        totalDivision = numberOfMeasures * bpm * subdivision
        resultWidth = sceneWidth - indentLength
        divisionWidth = resultWidth / totalDivision
        
        pages = [[Note]](repeating: [], count: maxPages)
        
        //lvlAns = Array(repeating: [Set<String>](repeating: [], count: totalDivision), count: maxPages)
        myAns = Array(repeating: [Set<String>](repeating: [], count: totalDivision), count: maxPages)
    }
 */
    
    func layoutScene() {
        
        if let bgNode = childNode(withName: "background") as? SKSpriteNode {
            self.bgNode = bgNode
        }
        
        barsNode.position = CGPoint(x: bgNode.frame.minX, y: bgNode.frame.minY + CGFloat(staffHeightFromGround))
        
        // creating the staff
        for i in 0...staffBarNumber - 1 {
            let staffBar = StaffBar(barIndex: i)
            staffBar.anchorPoint = CGPoint(x: 0, y: 0)
            staffBar.position = CGPoint(x: 0, y: (i * Int(staffBar.size.height)))
            staffBar.name = "staffBar"
            if i == 0 {
                continue
            }
                
            else if i % 2 == 0 {
                staffBar.drawLineThru()
            }

            barsNode.addChild(staffBar)
        }
        
        // creating the staff & its time
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
        
        // final bar with physics
        let finalBar = SKSpriteNode(color: UIColor.black, size: CGSize(width: 6, height: staffTotalHeight))
        finalBar.position = CGPoint(x: indentLength + totalDivision * divisionWidth, y: Int(finalBar.size.height) / 2)
        finalBar.physicsBody = SKPhysicsBody(rectangleOf: finalBar.size)
        finalBar.physicsBody?.isDynamic = false
        finalBar.physicsBody?.categoryBitMask = PhysicsCategories.finalBarCategory
        finalBar.physicsBody?.contactTestBitMask = PhysicsCategories.measureBarCategory
        finalBar.physicsBody?.collisionBitMask = PhysicsCategories.none
        barsNode.addChild(finalBar)
        
        // staff is complete
        addChild(barsNode)
        
        // adding white measure bar to hit notes
        measureBar = SKSpriteNode(color: UIColor.white, size: CGSize(width: 4, height: staffTotalHeight + 30))
        measureBar.position.x = CGFloat(Int(bgNode.frame.minX) + indentLength - 20)
        //let measureBarWiggleRoom =  staffTotalHeight / 2 - 15
        //measureBar.position.y = CGFloat(Int(frame.minY) + staffHeightFromGround + measureBarWiggleRoom)
        measureBar.position.y = barsNode.position.y + measureBar.size.height/2
        measureBar.zPosition = 20
        measureBar.physicsBody = SKPhysicsBody(rectangleOf: measureBar.size)
        measureBar.physicsBody?.categoryBitMask = PhysicsCategories.measureBarCategory
        measureBar.physicsBody?.contactTestBitMask = PhysicsCategories.noteCategory | PhysicsCategories.finalBarCategory
        measureBar.physicsBody?.collisionBitMask = PhysicsCategories.none
        measureBar.physicsBody?.affectedByGravity = false
        measureBar.physicsBody?.friction = 0
        measureBar.physicsBody?.linearDamping = 0
        addChild(measureBar)
        
        // adding treble clef
        let trebleClef = SKSpriteNode(imageNamed: "treble_clef.png")
        let trebleClefScaledSize = CGSize(width: trebleClef.frame.width / 8, height: trebleClef.frame.height / 8)
        trebleClef.scale(to: trebleClefScaledSize)
        trebleClef.anchorPoint = CGPoint(x: 0, y: 0)
        trebleClef.position = CGPoint(x: 0, y: 0)
        barsNode.addChild(trebleClef)
        
        // level is complete (hidden)
        yayYouDidIt = SKSpriteNode(imageNamed: "you-did-it.jpeg")
        let yayYouDidItScaledSize = scaleNode(size: yayYouDidIt.size, factor: Double(0.5))
        yayYouDidIt.scale(to: yayYouDidItScaledSize)
        yayYouDidIt.position = CGPoint(x: frame.midX, y: frame.midY)
        yayYouDidIt.zPosition = -100
        yayYouDidIt.alpha = CGFloat(0)
        addChild(yayYouDidIt)
        
        // try again (hidden)
        sorryTryAgain = SKSpriteNode(imageNamed: "try-again.jpg")
        let sorryTryAgainScaledSize = scaleNode(size: sorryTryAgain.size, factor: Double(0.5))
        sorryTryAgain.scale(to: sorryTryAgainScaledSize)
        sorryTryAgain.position = CGPoint(x: frame.midX, y: frame.midY)
        sorryTryAgain.zPosition = -100
        sorryTryAgain.alpha = CGFloat(0)
        addChild(sorryTryAgain)
        
        addCamera()
    }
    
    func addCamera() {
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: 0, y: 0)
        let maxScale = bgNode.size.width/frame.size.width
        gameCamera.setScale(maxScale)
        camera = gameCamera
    }
    
    func setUpPhysics() {
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    func setUpButtons() {
        //addButton(buttonImage: UIColor.orange, buttonAction: enterMode, buttonIndex: 0, name: "addButton")
        //addButton(buttonImage: UIColor.systemPink, buttonAction: enterMode, buttonIndex: 1, name: "eraseButton")
        //addButton(buttonImage: UIColor.purple, buttonAction: enterMode, buttonIndex: 2, name: "navigateButton")
        
        guard let view = view else {
            return
        }
        
        let topY = Int(view.bounds.size.height) * 0.75
        let bottomY = Int(view.bounds.size.height) * -0.75
        
        addButton(buttonImage: "play.png", buttonAction: enterMode, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: Int(frame.minX) + 50, y: topY))
        addButton(buttonImage: "pause.png", buttonAction: enterMode, buttonIndex: 4, name: "pauseButton", buttonPosition: CGPoint(x: Int(frame.minX) + 100, y: topY))
        addButton(buttonImage: "stop.png", buttonAction: enterMode, buttonIndex: 5, name: "stopButton", buttonPosition: CGPoint(x: Int(frame.minX) + 150, y: topY))
        
        
        addButton(buttonImage: "piano.png", buttonAction: selectNoteType, buttonIndex: 0, name: "pianoButton", buttonPosition: CGPoint(x: Int(frame.midX) - 25, y: bottomY + 25))
        addButton(buttonImage: "snare.png", buttonAction: selectNoteType, buttonIndex: 2, name: "snareButton", buttonPosition: CGPoint(x: Int(frame.midX) + 25, y: bottomY + 25))
        addButton(buttonImage: "cat.png", buttonAction: selectNoteType, buttonIndex: 4, name: "catButton", buttonPosition: CGPoint(x: Int(frame.midX) - 25, y: bottomY - 25))
        addButton(buttonImage: "eraser.png", buttonAction: enterMode, buttonIndex: 1, name: "eraseButton", buttonPosition: CGPoint(x: Int(frame.midX) + 25, y: bottomY - 25))
        addButton(buttonImage: "sharp.png", buttonAction: enterMode, buttonIndex: 7, name: "sharpButton", buttonPosition: CGPoint(x: Int(frame.minX) + 50, y: bottomY))
        addButton(buttonImage: "flat.png", buttonAction: enterMode, buttonIndex: 8, name: "flatButton", buttonPosition: CGPoint(x: Int(frame.minX) + 100, y: bottomY))
        
        addButton(buttonImage: "audio.png", buttonAction: playSample, buttonIndex: 0, name: "audioSampleButton", buttonPosition: CGPoint(x: Int(frame.midX) + 50, y: topY))
        addButton(buttonImage: "lightbulb.png", buttonAction: generateHint, buttonIndex: 0, name: "hintButton", buttonPosition: CGPoint(x: Int(frame.midX) + 100, y: topY))
        addButton(buttonImage: "check.png", buttonAction: submitAns, buttonIndex: 0, name: "submitButton", buttonPosition: CGPoint(x: Int(frame.midX) + 150, y: topY))
        
        
        //addButton(buttonImage: UIColor.green, buttonAction: generatePage, buttonIndex: 0, name: "generateNotes", buttonPosition: CGPoint(x: Int(frame.midX) + 200, y: bottomY))
        addButton(buttonImage: "rightArrow.png", buttonAction: nextPage, buttonIndex: 0, name: "nextPage", buttonPosition: CGPoint(x: Int(frame.midX) + 250, y: bottomY))
        addButton(buttonImage: "leftArrow.png", buttonAction: prevPage, buttonIndex: 0, name: "prevPage", buttonPosition: CGPoint(x: Int(frame.midX) + 200, y: bottomY))
    }
    
    func setUpSound() {
        do {
            file = try AKAudioFile(readFileName: "kitten-meow.wav")
            //player = try AKAudioPlayer(file: file!)
            try sampler.loadAudioFile(file)
        }
        catch {
            print(error)
            return
        }
        
        AudioKit.output = sampler
        do {
            try AudioKit.start()
        }
        catch {
            print(error)
        }
    }
    
    func addButton(buttonImage: String, buttonAction: @escaping (Int) -> (), buttonIndex: Int, name: String, buttonPosition: CGPoint) {
        //let buttonYPosition = staffHeightFromGround - 20
        let newButton = Button(defaultButtonImage: buttonImage, action: buttonAction, index: buttonIndex, buttonName: name)
        newButton.position = CGPoint(x: buttonPosition.x, y: buttonPosition.y)
        //buttonXPosition += 40
        addChild(newButton)
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
                    myAns[pageIndex][noteNode.positionInStaff[0]].remove(noteNode.getNoteName())
                    noteNode.removeFromParent()
                }
            }
        case "sharpMode":
            let topNode = touchedNodes.first
            if let noteNode = topNode as? Note {
                if noteNode.isFlat {
                    noteNode.toggleFlat()
                    noteNode.removeAllChildren()
                }
                let prevNoteVal = noteNode.getNoteName()
                noteNode.toggleSharp()
                if noteNode.isSharp {
                    //let arrayVal = getStaffPosition(notePosition: location)
                    //let noteVal = trebleNotes[arrayVal[1] + 1]
                    //location = touch.location(in: barsNode)
                    //if myAns[pageIndex][arrayVal[0]].contains(noteVal) {
                    let sharp = SKSpriteNode(imageNamed: "sharp.png")
                    sharp.size = scaleNode(size: sharp.size, factor: Double(0.05))
                    sharp.position = CGPoint(x: -20, y: 0)
                    noteNode.addChild(sharp)
                    //}
                }
                else {
                    noteNode.removeAllChildren()
                }
                myAns[pageIndex][noteNode.positionInStaff[0]].remove(prevNoteVal)
                myAns[pageIndex][noteNode.positionInStaff[0]].insert(noteNode.getNoteName())
            }
        case "flatMode":
            let topNode = touchedNodes.first
            if let noteNode = topNode as? Note {
                if noteNode.isSharp {
                    noteNode.toggleSharp()
                    noteNode.removeAllChildren()
                }
                let prevNoteVal = noteNode.getNoteName()
                noteNode.toggleFlat()
                if noteNode.isFlat {
                    myAns[pageIndex][noteNode.positionInStaff[0]].remove(prevNoteVal)
                    myAns[pageIndex][noteNode.positionInStaff[0]].insert(noteNode.getNoteName())
                    let flat = SKSpriteNode(imageNamed: "flat.png")
                    flat.size = scaleNode(size: flat.size, factor: Double(0.025))
                    flat.position = CGPoint(x: -20, y: 0)
                    noteNode.addChild(flat)
                }
                else {
                    myAns[pageIndex][noteNode.positionInStaff[0]].remove(prevNoteVal)
                    myAns[pageIndex][noteNode.positionInStaff[0]].insert(noteNode.getNoteName())
                    noteNode.removeAllChildren()
                }
            }
        default: // not selected or navigateMode
            return
        }
    }
    
    func playSample(index: Int) {
        barsNode.run(SKAction.playSoundFileNamed("lvl3song.mp3", waitForCompletion: false))
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
        let measureBarResetPos = CGPoint(x: CGFloat(Int(bgNode.frame.minX) + indentLength - 20), y: barsNode.position.y + measureBar.size.height/2)
        let measureBarContinuePos = CGPoint(x: CGFloat(Int(bgNode.frame.minX) + indentLength), y: barsNode.position.y + measureBar.size.height/2)
        let resetPostion = SKAction.move(to: measureBarResetPos, duration: 0)
        let continuePos = SKAction.move(to: measureBarContinuePos, duration: 0)
        
        switch index {
        case 0:
            currentMode = "addMode"
        case 1:
            currentMode = "eraseMode"
        case 2:
            currentMode = "navigateMode"
        case 3:
            currentMode = "playMode"
            measureBar.physicsBody?.velocity = CGVector(dx: 500, dy: 0)
        case 4:
            measureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        case 5:
            measureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            //measureBar.position = CGPoint(x: indentLength - 20, y: staffHeightFromGround + staffBarNumber * staffBarHeight / 2)
            measureBar.run(resetPostion)
        case 6:
            measureBar.run(continuePos)
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
        if myAns.elementsEqual(lvlAns) {
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
        if hintNum < lvlAns[pageIndex].count && !lvlAns[pageIndex][hintNum].isEmpty {
            for pitches in lvlAns[pageIndex][hintNum] {
                if !pitches.isEmpty && hintNum < lvlAns[pageIndex].count {
                    let xPos = hintNum * divisionWidth + indentLength
                    var yPos = (trebleNotes.firstIndex(of: pitches)! - 1) * staffBarHeight + 10
                    if pitches.contains("3") { // if it's gonna be B3 or C flat
                        yPos = 10
                        addNote(noteType: selectedNoteType, notePosition: CGPoint(x: xPos, y: yPos))
                        let currentNote = pages[pageIndex].last!
                        currentNote.toggleFlat()
                        let flat = SKSpriteNode(imageNamed: "flat.png")
                        flat.size = scaleNode(size: flat.size, factor: Double(0.05))
                        flat.position = CGPoint(x: -20, y: 0)
                        currentNote.addChild(flat)
                        myAns[pageIndex][hintNum].remove("C4")
                        myAns[pageIndex][hintNum].insert(currentNote.getNoteName())
                    }
                    else if pitches.contains("s") {
                        yPos = (trebleNotes.firstIndex(of: pitches)! - 13) * staffBarHeight + 10
                        addNote(noteType: selectedNoteType, notePosition: CGPoint(x: xPos, y: yPos))
                        let currentNote = pages[pageIndex].last!
                        currentNote.toggleSharp()
                        let sharp = SKSpriteNode(imageNamed: "sharp.png")
                        sharp.size = scaleNode(size: sharp.size, factor: Double(0.05))
                        sharp.position = CGPoint(x: -20, y: 0)
                        currentNote.addChild(sharp)
                        let naturalNote = String(pitches.prefix(2))
                        myAns[pageIndex][hintNum].remove(naturalNote)
                        myAns[pageIndex][hintNum].insert(currentNote.getNoteName())
                    }
                    else {
                        addNote(noteType: selectedNoteType, notePosition: CGPoint(x: xPos, y: yPos))
                        let currentNote = pages[pageIndex].last!
                        myAns[pageIndex][hintNum].insert(currentNote.getNoteName())
                    }
                }
            }
            hintNum += 1
            return
         }
        hintNum += 1
    }
    
    func generatePage(index: Int) {
        var count = 0
        let noteSet = lvlAns[pageIndex]
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

extension LevelTemplate: SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.noteCategory | PhysicsCategories.measureBarCategory {
            if let hitInstrument = contact.bodyA.node?.name != nil ? contact.bodyA.node as? Note : contact.bodyB.node as? Note {
                print(hitInstrument.noteType)
                print(hitInstrument.positionInStaff[1])
                print(hitInstrument.getMidiVal())
                let whichNote = hitInstrument.getMidiVal()
                do {
                    try sampler.play(noteNumber: UInt8(whichNote), velocity: 127, channel: 0)
                }
                catch {
                    print(error)
                }
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
