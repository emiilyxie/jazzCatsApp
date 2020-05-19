//
//  GameScene.swift
//  colorSwitch
//
//  Created by Emily Xie on 4/10/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//
/*

import SpriteKit
import AudioKit

class GameScene: SKScene {
    
    var barsNode = SKTileMapNode()
    var bgNode = SKSpriteNode()
    var measureBar: SKSpriteNode!
    var visibleMeasureBar: SKSpriteNode!
    var selectedNoteType = NoteType.piano
    //var selectedNoteTypeArray = [(NoteType.piano, true), (NoteType.bass, false), (NoteType.snare, false), (NoteType.hihat, false)]
    let anchor = SKSpriteNode()
    var eraseMode = false
    //var modes = [("addMode", false), ("eraseMode", false), ("navigateMode", true)]
    var currentMode = "navigateMode"
    var buttonXPosition = 200
    
    let gameCamera = GameCamera()
    var panRecognizer = UIPanGestureRecognizer()
    var pinchRecognizer = UIPinchGestureRecognizer()
    var editNotesTapRecognizer = UITapGestureRecognizer()
    var maxScale: CGFloat = 0
    
    var file: AKAudioFile!
    var sampler = AKAppleSampler()
    
    let midiNoteDict = [("F2", 41), ("G2", 43), ("A2", 45), ("B2", 47), ("C3", 48), ("D3", 50), ("E3", 52), ("F3", 53), ("G3", 55), ("A3", 57), ("B3", 59), ("C4", 60), ("D4", 62), ("E4", 64), ("F4", 65), ("G4", 67), ("A4", 69), ("B4", 71), ("C5", 72), ("D5", 74), ("E5", 76), ("F5", 77), ("G5", 79)]
    
    override func didMove(to view: SKView) {
        setUpLevel()
        layoutScene()
        setUpPhysics()
        setUpGestureRecognizers()
        setUpButtons()
        setUpSound()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            editNotes(touch: firstTouch)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        if let touch = touches.first {
            if note.grabbed {
                let location = touch.location(in: self)
                note.position = location
            }
        }
 */
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        /*
        if let touch = touches.first {
            let location = touch.location(in: self)
            if barsNode.contains(location) {
                if note.grabbed {
                    note.grabbed = false
                    panRecognizer.isEnabled = true
                }
            }
            else {
                note.removeFromParent()
                panRecognizer.isEnabled = true
            }
        }
 */
    }
    
    func setUpGestureRecognizers() {
        guard let view = view else {
            return
        }
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(pan))
        view.addGestureRecognizer(panRecognizer)
        
        pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        view.addGestureRecognizer(pinchRecognizer)
        
        //editNotesTapRecognizer = UITapGestureRecognizer(target: self.barsNode, action: #selector(editNotes))
        
    }
    
    func setUpLevel() {
        if let barsNode = childNode(withName: "bars") as? SKTileMapNode {
            self.barsNode = barsNode
            let scalePadding = CGFloat(200)
            maxScale = (barsNode.mapSize.height + scalePadding)/frame.size.height
        }
        
        if let bgNode = childNode(withName: "background") as? SKSpriteNode {
            self.bgNode = bgNode
            bgNode.size.width = barsNode.mapSize.width * barsNode.xScale
        }
        
        addCamera()
        anchor.position = CGPoint(x: barsNode.frame.midX/4, y: barsNode.frame.midY/4)
        addChild(anchor)
    }
    
    func addCamera() {
        guard let view = view else {
            return
        }
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: view.bounds.size.width/2, y: barsNode.position.y + barsNode.mapSize.height/2)
        camera = gameCamera
        
        gameCamera.setConstraints(with: self, and: bgNode.frame, to: nil)
    }
    
    func setUpPhysics() {
        physicsWorld.gravity = CGVector(dx: 2, dy: 0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene() {
        //backgroundColor = UIColor(red: 200/255, green: 150/255, blue: 180/255, alpha: 1.0)
        
        measureBar = SKSpriteNode(color: UIColor.clear, size: CGSize(width: 10, height: barsNode.mapSize.height))
        measureBar.position = CGPoint(x: frame.minX + measureBar.size.width/2, y: barsNode.position.y - barsNode.mapSize.height/2)
        measureBar.physicsBody = SKPhysicsBody(rectangleOf: measureBar.size)
        measureBar.physicsBody?.categoryBitMask = PhysicsCategories.measureBarCategory
        measureBar.physicsBody?.contactTestBitMask = PhysicsCategories.noteCategory
        measureBar.physicsBody?.collisionBitMask = PhysicsCategories.none
        measureBar.physicsBody?.affectedByGravity = false
        measureBar.physicsBody?.friction = 0
        measureBar.physicsBody?.linearDamping = 0
        //measureBar.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
        //measureBar.run(SKAction.moveTo(x: barsNode.mapSize.width, duration: 8))
        
        visibleMeasureBar = SKSpriteNode(color: UIColor.white, size: CGSize(width: 10, height: barsNode.mapSize.height))
        visibleMeasureBar.position = CGPoint(x: frame.minX + measureBar.size.width/2, y: barsNode.position.y - barsNode.mapSize.height/2)
        visibleMeasureBar.zPosition = 100
        visibleMeasureBar.physicsBody = SKPhysicsBody(rectangleOf: measureBar.size)
        visibleMeasureBar.physicsBody?.collisionBitMask = PhysicsCategories.none
        visibleMeasureBar.physicsBody?.affectedByGravity = false
        visibleMeasureBar.physicsBody?.friction = 0
        visibleMeasureBar.physicsBody?.linearDamping = 0
        
        barsNode.addChild(measureBar)
        barsNode.addChild(visibleMeasureBar)
        
        //addNote(noteType: selectedNoteType, notePosition: CGPoint(x: 400, y: 400))
        
    }
    
    func setUpButtons() {
        
        /*
        
        addButton(buttonImage: UIColor.orange, buttonAction: enterMode, buttonIndex: 0, name: "addButton")
        addButton(buttonImage: UIColor.systemPink, buttonAction: enterMode, buttonIndex: 1, name: "eraseButton")
        addButton(buttonImage: UIColor.purple, buttonAction: enterMode, buttonIndex: 2, name: "navigateButton")
        addButton(buttonImage: UIColor.white, buttonAction: enterMode, buttonIndex: 3, name: "playButton")
        addButton(buttonImage: UIColor.gray, buttonAction: enterMode, buttonIndex: 4, name: "pauseButton")
        addButton(buttonImage: UIColor.black, buttonAction: enterMode, buttonIndex: 5, name: "stopButton")
        addButton(buttonImage: UIColor.red, buttonAction: selectNoteType, buttonIndex: 0, name: "pianoButton")
        addButton(buttonImage: UIColor.blue, buttonAction: selectNoteType, buttonIndex: 1, name: "bassButton")
        addButton(buttonImage: UIColor.green, buttonAction: selectNoteType, buttonIndex: 2, name: "snareButton")
        addButton(buttonImage: UIColor.yellow, buttonAction: selectNoteType, buttonIndex: 3, name: "hihatButton")
 
 */
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
    
    func addButton(buttonImage: String, buttonAction: @escaping (Int) -> (), buttonIndex: Int, name: String) {
        let buttonYPosition = Int(barsNode.position.y - 50)
        let newButton = Button(defaultButtonImage: buttonImage, action: buttonAction, index: buttonIndex, buttonName: name)
        newButton.position = CGPoint(x: buttonXPosition, y: buttonYPosition)
        buttonXPosition += 40
        addChild(newButton)
    }
    
    func enterMode(index: Int) {
        /*
        for i in 0...modes.count-1 {
            modes[i].1 = false
        }
        modes[index].1 = true
        print(modes[index].0)
 */
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
            visibleMeasureBar.physicsBody?.velocity = CGVector(dx: 200, dy: 0)
            
        case 4:
            measureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            visibleMeasureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        case 5:
            measureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            measureBar.position = CGPoint(x: frame.minX + measureBar.size.width/2, y: barsNode.position.y - barsNode.mapSize.height/2)
            visibleMeasureBar.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            visibleMeasureBar.position = CGPoint(x: frame.minX + measureBar.size.width/2, y: barsNode.position.y - barsNode.mapSize.height/2)
        default:
            currentMode = "navigateMode"
        }
    }
    
    func selectNoteType(index: Int) {
        /*
        enterMode(index: 0)
        for i in 0...selectedNoteTypeArray.count-1 {
            selectedNoteTypeArray[i].1 = false
        }
        selectedNoteTypeArray[index].1 = true
        selectedNoteType = selectedNoteTypeArray[index].0
 */
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
    
    func addNote(noteType: NoteType, notePosition: CGPoint, notePointInTileMap: CGPoint) {
        let note = Note(type: noteType)
        note.name = "note"
        note.position = notePosition
        note.positionInTileMap = getPositionInTileMap(point: notePointInTileMap)
        note.physicsBody = SKPhysicsBody(rectangleOf: note.size)
        note.physicsBody?.isDynamic = false
        note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
        note.physicsBody?.contactTestBitMask = PhysicsCategories.measureBarCategory
        note.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(note)
    }
    
    func editNotes(touch: UITouch) {
        var location = touch.location(in: self)
        let touchedNodes = nodes(at: location)
        
        switch currentMode {
        case "addMode": // if in addMode
            if barsNode.contains(location) {
                location = touch.location(in: barsNode)
                let mapPosition = getPositionInTileMap(point: location)
                let snappedLocation = convertTileMapPosition(tmPosition: mapPosition)
                addNote(noteType: selectedNoteType, notePosition: snappedLocation, notePointInTileMap: location)
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
    
    
    /*
    func addNoteMenu() {
        let noteTypes = NoteType.allTypes
        var xPosition = 0
        for instrument in noteTypes {
            let newNote = Note(type: instrument)
            newNote.isPartOfMenu = true
            addNote(note: newNote, noteType: instrument, notePosition: CGPoint(x: Int(anchor.position.x) + xPosition, y: Int(anchor.position.y)))
            xPosition += 100
        }
        
    }
 */
    
    /*
    func spawnNote(noteType: UIColor, instrument: String) {
        let note = SKSpriteNode(color: noteType, size: CGSize(width: 10, height: 10))
        note.name = instrument
        let noteDisplacementX = Int.random(in: 0...Int(barsNode.mapSize.width/2))
        let noteDisplacementY = Int.random(in: -Int(barsNode.mapSize.height/2)...Int(barsNode.mapSize.height/2))
        note.position = CGPoint(x: noteDisplacementX, y: noteDisplacementY)
        note.physicsBody = SKPhysicsBody(rectangleOf: note.size)
        note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
        //note.physicsBody?.contactTestBitMask = PhysicsCategories.measureBarCategory
        //note.physicsBody?.collisionBitMask = PhysicsCategories.none
        note.physicsBody?.isDynamic = false
        barsNode.addChild(note)
        var _ = getNodePositionInTileMap(node: note)
    }
 */
    
    func getPositionInTileMap(point: CGPoint) -> Array<Int> {
        print("old point: \(point.x), \(point.y)")
        let xIndex = barsNode.tileColumnIndex(fromPosition: point)
        let yIndex = barsNode.tileRowIndex(fromPosition: point)
        let indexArray = [xIndex, yIndex]
        print("note position: \(indexArray[0]), \(indexArray[1])")
        return indexArray
    }
    
    func convertTileMapPosition(tmPosition: Array<Int>) -> CGPoint {
        let xPoint = CGFloat(tmPosition[0] * Int(barsNode.tileSize.width) * Int(barsNode.xScale)) + barsNode.position.x + barsNode.tileSize.width/2
        let yPoint = CGFloat(tmPosition[1] * Int(barsNode.tileSize.height) * Int(barsNode.yScale)) + barsNode.position.y + barsNode.tileSize.height/2
        print("new point: \(xPoint), \(yPoint)")
        return CGPoint(x: xPoint, y: yPoint)
    }
 
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.noteCategory | PhysicsCategories.measureBarCategory {
            if let hitInstrument = contact.bodyA.node?.name != nil ? contact.bodyA.node as? Note : contact.bodyB.node as? Note {
                print(hitInstrument.noteType)
                //let whichNote = UInt8(hitInstrument.positionInTileMap[1] + 60 - barsNode.numberOfRows/2)
                let whichNote = midiNoteDict[hitInstrument.positionInTileMap[1]].1
                print(whichNote)
                do {
                    try sampler.play(noteNumber: UInt8(whichNote), velocity: 127, channel: 0)
                }
                catch {
                    print(error)
                }
            }
        }
    }
}

extension GameScene {
    
    @objc func pan(sender: UIPanGestureRecognizer) {
        guard let view = view else {
            return
        }
        if sender.numberOfTouches == 2{
            let translation = sender.translation(in: view) * gameCamera.yScale
            gameCamera.position = CGPoint(x: gameCamera.position.x - translation.x, y: gameCamera.position.y + translation.y)
            sender.setTranslation(CGPoint.zero, in: view)
        }
    }
    
    @objc func pinch(sender: UIPinchGestureRecognizer) {
        guard let view = view else {
            return
        }
        if sender.numberOfTouches == 2 {
            let locationInView = sender.location(in: view)
            let location = convertPoint(fromView: locationInView)
            if sender.state == .changed {
                let convertedScale = 1/sender.scale
                let newScale = gameCamera.yScale * convertedScale
                if newScale < maxScale && newScale > 0.5 {
                    gameCamera.setScale(newScale)
                }
                
                let locationAfterScale = convertPoint(fromView: locationInView)
                let locationDelta = location - locationAfterScale
                let newPosition = gameCamera.position + locationDelta
                gameCamera.position = newPosition
                sender.scale = 1.0
                gameCamera.setConstraints(with: self, and: bgNode.frame, to: nil)
            }
        }
    }
    
    /*
    @objc func editNotes(sender: UITapGestureRecognizer) {
        guard let view = view else {
            return
        }
        var location = sender.location(in: view)
        let touchedNodes = nodes(at: location)
        if !eraseMode {
            location = sender.location(in: view)
            let mapPosition = getPositionInTileMap(point: location)
            let snappedLocation = convertTileMapPosition(tmPosition: mapPosition)
            addNote(noteType: selectedNoteType, notePosition: snappedLocation)
        }
        else {
            for node in touchedNodes {
                if node.name == "note" {
                    node.removeFromParent()
                }
            }
        }
    }
 */
}
*/
