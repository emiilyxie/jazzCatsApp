//
//  FreestyleScene.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/18/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

/*
import UIKit
import SpriteKit
import AudioKit
//import AVFoundation.AVAudioMix

public class FreestyleRecordingFails: SKScene, AVAudioRecorderDelegate {

    weak var viewController: UIViewController?
    let gameCamera = GameCamera()
    
    public var staffBarHeight: Int!
    public var staffBarNumber: Int!
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
    var pgCountLabel: SKLabelNode!
    
    var bgNode: SKSpriteNode!
    let barsNode = SKNode()
    var measureBar: SKSpriteNode!
    var selectedNoteType = NoteType.piano
    var currentMode = "addMode"
    
    var file: AKAudioFile!
    var sampler = AKAppleSampler()
    
    /*
    
     //vars for avaudio recording
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder!
    var recordButton: Button!
    var playRecordingButton: Button!
    var currentlyRecording = false
 */
    
    /*
    
    //vars for audiokit recording
    var micMixer: AKMixer!
    var recorder: AKNodeRecorder!
    var player: AKPlayer!
    var tape: AKAudioFile!
    var micBooster: AKBooster!
    let mic = AKMicrophone()
    var recordButton: Button!
    var playRecordingButton: Button!
    var currentlyRecording = false
 
 */
    
    public override func didMove(to view: SKView) {
        //setUpVars()
        layoutScene()
        setUpPhysics()
        setUpButtons()
        setUpSound()
    }
    
    deinit {
        print("deinitialized")
    }
    
    func layoutScene() {
        
        if let bgNode = childNode(withName: "background") as? SKSpriteNode {
            self.bgNode = bgNode
        }
        
        barsNode.position = CGPoint(x: bgNode.frame.minX, y: bgNode.frame.minY + CGFloat(staffHeightFromGround))
        
        // creating the staff
        for i in 0...staffBarNumber - 1 {
            let staffBar = StaffBar(barIndex: i, barHeight: staffBarHeight)
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
                let xPos = LevelSetup.indentLength + i * divisionWidth
                let measureLine = SKShapeNode(rect: CGRect(x: xPos, y: 0, width: lineWidth, height: staffTotalHeight))
                measureLine.fillColor = UIColor.black
                measureLine.strokeColor = UIColor.clear
                barsNode.addChild(measureLine)
            }
        }
        
        // final bar with physics
        let finalBar = SKSpriteNode(color: UIColor.black, size: CGSize(width: 6, height: staffTotalHeight))
        finalBar.position = CGPoint(x: LevelSetup.indentLength + totalDivision * divisionWidth, y: Int(finalBar.size.height) / 2)
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
        measureBar.position.x = CGFloat(Int(bgNode.frame.minX) + LevelSetup.indentLength - 20)
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
        
        guard let view = view else {
            return
        }
        
        let topY = Int(view.bounds.size.height) * 0.75
        let bottomY = Int(view.bounds.size.height) * -0.75
        
        addButton(buttonImage: "play.png", buttonAction: returnToWelcomeScreen, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: Double(frame.minX), y: topY))
        addButton(buttonImage: "play.png", buttonAction: enterMode, buttonIndex: 3, name: "playButton", buttonPosition: CGPoint(x: Int(frame.minX) + 50, y: topY))
        addButton(buttonImage: "pause.png", buttonAction: enterMode, buttonIndex: 4, name: "pauseButton", buttonPosition: CGPoint(x: Int(frame.minX) + 100, y: topY))
        addButton(buttonImage: "stop.png", buttonAction: enterMode, buttonIndex: 5, name: "stopButton", buttonPosition: CGPoint(x: Int(frame.minX) + 150, y: topY))
        
        addButton(buttonImage: "piano.png", buttonAction: selectNoteType, buttonIndex: 0, name: "pianoButton", buttonPosition: CGPoint(x: Int(frame.midX) - 25, y: bottomY + 25))
        addButton(buttonImage: "snare.png", buttonAction: selectNoteType, buttonIndex: 2, name: "snareButton", buttonPosition: CGPoint(x: Int(frame.midX) + 25, y: bottomY + 25))
        addButton(buttonImage: "cat.png", buttonAction: selectNoteType, buttonIndex: 4, name: "catButton", buttonPosition: CGPoint(x: Int(frame.midX) - 25, y: bottomY - 25))
        addButton(buttonImage: "eraser.png", buttonAction: enterMode, buttonIndex: 1, name: "eraseButton", buttonPosition: CGPoint(x: Int(frame.midX) + 25, y: bottomY - 25))
        addButton(buttonImage: "sharp.png", buttonAction: enterMode, buttonIndex: 7, name: "sharpButton", buttonPosition: CGPoint(x: Int(frame.minX) + 50, y: bottomY))
        addButton(buttonImage: "flat.png", buttonAction: enterMode, buttonIndex: 8, name: "flatButton", buttonPosition: CGPoint(x: Int(frame.minX) + 100, y: bottomY))
        
        addButton(buttonImage: "rightArrow.png", buttonAction: nextPage, buttonIndex: 0, name: "nextPage", buttonPosition: CGPoint(x: Int(frame.midX) + 250, y: bottomY))
        addButton(buttonImage: "leftArrow.png", buttonAction: prevPage, buttonIndex: 0, name: "prevPage", buttonPosition: CGPoint(x: Int(frame.midX) + 200, y: bottomY))
        pgCountLabel = SKLabelNode(text: "page: \(pageIndex+1)/\(maxPages!)")
        pgCountLabel.fontColor = UIColor.black
        pgCountLabel.fontSize = 30
        pgCountLabel.fontName = "Hiragino Mincho ProN"
        pgCountLabel.position = CGPoint(x: Int(frame.midX) + 200, y: bottomY - 70)
        addChild(pgCountLabel)
        
        /*
        //buttons for audiokit recording
        recordButton = Button(defaultButtonImage: "stop.png", action: record, index: 0, buttonName: "recordButton")
        recordButton.isUserInteractionEnabled = true
        addButton(button: recordButton, buttonPosition: CGPoint(x: Int(frame.midX) + 250, y: topY))
        
        playRecordingButton = Button(defaultButtonImage: "audio.png", action: playRecording, index: 0, buttonName: "playRecordingButton")
        playRecordingButton.isUserInteractionEnabled = false
        addButton(button: playRecordingButton, buttonPosition: CGPoint(x: Int(frame.midX) + 200, y: topY))
 */
        /*
        //vars for avaudio recording
        recordButton = Button(defaultButtonImage: "stop.png", action: startRecording, index: 0, buttonName: "recordButton")
        recordButton.isUserInteractionEnabled = true
        addButton(button: recordButton, buttonPosition: CGPoint(x: Int(frame.midX) + 250, y: topY))
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
        /*
        //audio setup for avaudio recording
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        print("allowed!!!")
                        self.loadRecordingUI()
                    } else {
                        // failed to record!
                    }
                }
            }
        } catch {
            print(error)
        }
 */
        
        /*
        //audio setup for audiokit recording
        // Clean tempFiles !
        AKAudioFile.cleanTempDirectory()

        // Session settings
        AKSettings.bufferLength = .medium

        do {
            try AKSettings.setSession(category: .playAndRecord, with: .allowBluetoothA2DP)
        } catch {
            AKLog("Could not set session category.")
        }

        AKSettings.defaultToSpeaker = true
        
        let monoToStereo = AKStereoFieldLimiter(mic, amount: 1)
        micMixer = AKMixer(monoToStereo)
        micBooster = AKBooster(micMixer)
        
        recorder = try? AKNodeRecorder(node: micMixer)
        if let recordFile = recorder.audioFile {
            player = AKPlayer(audioFile: recordFile)
        }
        player.isLooping = false
        player.completionHandler = playingEnded
        
        do {
            file = try AKAudioFile(readFileName: "kitten-meow.wav")
            //player = try AKAudioPlayer(file: file!)
            try sampler.loadAudioFile(file)
        }
        catch {
            print(error)
            return
        }
        
        let mainMixer = AKMixer(micBooster, player, sampler)
        
        AudioKit.output = mainMixer
        do {
            try AudioKit.start()
        }
        catch {
            print(error)
        }
        
        micBooster.gain = 0
 */
    }
    
    /*
    //funcs for audiokit recording
    func record(index: Int) {
        if !currentlyRecording {
            if AKSettings.headPhonesPlugged {
                micBooster.gain = 1
            }
            do {
                try recorder.record()
            } catch { AKLog("Errored recording.") }
            currentlyRecording = true
        }
        else {
            // Microphone monitoring is muted
            micBooster.gain = 0
            tape = recorder.audioFile!
            player.load(audioFile: tape)

            if let _ = player.audioFile?.duration {
                recorder.stop()
                tape.exportAsynchronously(name: "TempTestFile.m4a",
                                          baseDir: .documents,
                                          exportFormat: .m4a) {_, exportError in
                    if let error = exportError {
                        AKLog("Export Failed \(error)")
                    } else {
                        AKLog("Export succeeded")
                    }
                }
                setupUIForPlaying()
            }
            currentlyRecording = false
            playRecordingButton.isUserInteractionEnabled = true
        }
    }
    
    func playRecording(index: Int) {
        player.play()
    }
    
    func playingEnded() {
        DispatchQueue.main.async {
            print("playing has ended")
            self.setupUIForPlaying()
        }
    }
    
    func setupUIForPlaying() {
        recordButton.color = UIColor.white
    }
 */
    /*
     //funcs for avaudio recording
    func loadRecordingUI() {
        print("recording UI loaded")
    }
    
    func startRecording(index: Int) {
        let audioFilename = getDocumentsDirectory().appendingPathComponent("recording.m4a")

        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            try audioRecorder =  AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()

            print("started recording")
        } catch {
            finishRecording(success: false)
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func finishRecording(success: Bool) {
        audioRecorder.stop()
        audioRecorder = nil

        if success {
            print("finished recording")
        } else {
            print("recording failed agh")
            // recording failed :(
        }
    }
 */
    
    func addButton(buttonImage: String, buttonAction: @escaping (Int) -> (), buttonIndex: Int, name: String, buttonPosition: CGPoint) {
        //let buttonYPosition = staffHeightFromGround - 20
        let newButton = Button(defaultButtonImage: buttonImage, action: buttonAction, index: buttonIndex, buttonName: name)
        newButton.position = CGPoint(x: buttonPosition.x, y: buttonPosition.y)
        //buttonXPosition += 40
        addChild(newButton)
    }
    
    func addButton(button: Button, buttonPosition: CGPoint) {
        button.position = CGPoint(x: buttonPosition.x, y: buttonPosition.y)
        addChild(button)
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
                let maxX = CGFloat(LevelSetup.indentLength + resultWidth - divisionWidth/2)
                if location.x >= CGFloat(LevelSetup.indentLength) && location.x < maxX {
                    let snappedLocation = snapNoteLocation(touchedPoint: location)
                    addNote(noteType: selectedNote, notePosition: snappedLocation)
                }
                
            }
        case "eraseMode": // if in eraseMode
            for node in touchedNodes {
                if let noteNode = node as? Note {
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
    
    func addNote(noteType: String, notePosition: CGPoint) {
        let note = Note(type: noteType)
        note.name = "note"
        note.position = notePosition
        note.positionInStaff = getStaffPosition(notePosition: notePosition)
        note.physicsBody = SKPhysicsBody(rectangleOf: note.size)
        note.physicsBody?.isDynamic = false
        note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
        note.physicsBody?.contactTestBitMask = PhysicsCategories.measureBarCategory
        note.physicsBody?.collisionBitMask = PhysicsCategories.none
        pages[pageIndex].append(note)
        barsNode.addChild(note)
    }
    
    func snapNoteLocation(touchedPoint: CGPoint) -> CGPoint {
        let divisionWidthFloat = CGFloat(divisionWidth)
        let indentLengthFloat = CGFloat(LevelSetup.indentLength)
        let xPos = Int(round((touchedPoint.x - indentLengthFloat) / divisionWidthFloat) * divisionWidthFloat) + LevelSetup.indentLength
        
        let staffBarHeightFloat = CGFloat(staffBarHeight)
        //print("before: \(touchedPoint.y)")
        let yPos = Int(round(touchedPoint.y / staffBarHeightFloat) * staffBarHeightFloat - (staffBarHeightFloat / 2))
        //print("after: \(yPos)")
        return CGPoint(x: xPos, y: yPos)
    }
    
    func getStaffPosition(notePosition: CGPoint) -> Array<Int> {
        let xPos = (Int(notePosition.x) - LevelSetup.indentLength + 15) / divisionWidth
        let yPos = Int(notePosition.y) / staffBarHeight
        return [xPos, yPos]
    }
    
    func enterMode(index: Int) {
        let measureBarResetPos = CGPoint(x: CGFloat(Int(bgNode.frame.minX) + LevelSetup.indentLength - 20), y: barsNode.position.y + measureBar.size.height/2)
        let measureBarContinuePos = CGPoint(x: CGFloat(Int(bgNode.frame.minX) + LevelSetup.indentLength), y: barsNode.position.y + measureBar.size.height/2)
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
            //print("now on page \(pageIndex)")
            for note in pages[pageIndex] {
                note.isHidden = false
                note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
            }
        }
        updatePgCount()
    }
    
    func prevPage(index: Int) {
        if pageIndex >= 1 {
            for note in pages[pageIndex] {
                note.isHidden = true
                note.physicsBody?.categoryBitMask = PhysicsCategories.none
            }
            pageIndex -= 1
            //print("now on page \(pageIndex)")
            for note in pages[pageIndex] {
                note.isHidden = false
                note.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
            }
        }
        updatePgCount()
    }
    
    func updatePgCount() {
        pgCountLabel.text = "page: \(pageIndex+1)/\(maxPages!)"
    }
        
    func returnToWelcomeScreen(index: Int) {
        do {
            try sampler.stop()
            sampler.detach()
            AudioKit.disconnectAllInputs()
            try AudioKit.shutdown()
            AudioKit.output = nil
        }
        catch {
            print(error)
        }

        for child in self.children {
            child.removeAllActions()
            child.removeFromParent()
        }
        self.scene!.removeAllActions()
        self.scene!.removeAllChildren()
        self.scene!.removeFromParent()
        self.view?.presentScene(nil)
        
        guard let gameVC = self.viewController as! GameViewController? else {
            return
        }

        gameVC.unwindFromGameToWelcome(gameVC)

        print("bye bitch")
    }
}

extension FreestyleRecordingFails: SKPhysicsContactDelegate {
    public func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.noteCategory | PhysicsCategories.measureBarCategory {
            if let hitInstrument = contact.bodyA.node?.name != nil ? contact.bodyA.node as? Note : contact.bodyB.node as? Note {
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

 */
