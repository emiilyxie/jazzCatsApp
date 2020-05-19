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

class FreestyleScene: SKScene {
    
    public let sceneWidth = 720
    public let sceneHeight = 480

    public let staffBarHeight = 16
    public let staffBarNumber = 12
    public var staffTotalHeight: Int!
    public var staffHeightFromGround: Int!

    public let indentLength = 100
    public var numberOfMeasures: Int!
    public var bpm: Int!
    public var subdivision: Int!
    public var totalDivision: Int!
    public var resultWidth: Int!
    public var divisionWidth: Int!

    public var maxPages: Int!
    public var pages: Array<Array<Note>>!
    public var pageIndex = 0
    
    let barsNode = SKNode()
    var measureBar: SKSpriteNode!
    var selectedNoteType = NoteType.piano
    var currentMode = "addMode"
    var yayYouDidIt: SKSpriteNode!
    var sorryTryAgain: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        setUpVars()
        layoutScene()
        setUpPhysics()
    }

    func setUpVars() {
        staffTotalHeight = staffBarHeight * staffBarNumber
        staffHeightFromGround = sceneHeight / 2 - staffBarHeight * staffBarNumber / 2
        
        totalDivision = numberOfMeasures * bpm * subdivision
        resultWidth = sceneWidth - indentLength
        divisionWidth = resultWidth / totalDivision
        
        pages = [[Note]](repeating: [], count: maxPages)
    }
    
    func layoutScene() {
        barsNode.position = CGPoint(x: 0, y: staffHeightFromGround)
        
        // creating the staff
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
        measureBar = SKSpriteNode(color: UIColor.white, size: CGSize(width: 2, height: staffBarNumber * staffBarHeight + 30))
        measureBar.position = CGPoint(x: indentLength - 20, y: staffHeightFromGround + staffBarNumber * staffBarHeight / 2 - 15)
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
        let trebleClefScaledSize = CGSize(width: trebleClef.frame.width / 10, height: trebleClef.frame.height / 10)
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
    }
    
    func setUpPhysics() {
        physicsWorld.gravity = CGVector(dx: 2, dy: 0)
        physicsWorld.contactDelegate = self
    }
}
*/
