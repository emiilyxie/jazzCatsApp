//
//  LevelLayout.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/22/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension LevelTemplate {
    
    func layoutScene() {
        setUpBackground()
        setUpStaff()
        setUpMeasureBar()
        setUpImages()
    }
    
    func setUpBackground() {
        if let bgNode = childNode(withName: "background") as? SKSpriteNode {
            self.bgNode = bgNode
        }
    }
    
    func setUpStaff() {
        barsNode.position = CGPoint(x: 0, y: staffHeightFromGround)
        // creating the staff
        for i in 0...staffBarNumber - 1 {
            let staffBar = StaffBar(barIndex: i, barHeight: staffBarHeight)
            staffBar.anchorPoint = CGPoint(x: 0, y: 0)
            staffBar.position = CGPoint(x: 0, y: (i * Int(staffBar.size.height)))
            staffBar.name = "staffBar"
            if i == 0 {
                //staffBar.colorDebug(i: i)
                continue
            }
                
            else if i % 2 == 0 {
                //staffBar.colorDebug(i: i)
                staffBar.drawLineThru()
            }

            barsNode.addChild(staffBar)
        }
        
        // creating the staff & its time
        for i in 0...totalDivision - 1 {
            var lineWidth = 0
            if i % subdivision == 0 {
                lineWidth += 2
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
        finalBar.anchorPoint = CGPoint(x: 1, y: 0)
        finalBar.position = CGPoint(x: LevelSetup.indentLength + totalDivision * divisionWidth, y: 0)
        finalBar.physicsBody = SKPhysicsBody(rectangleOf: finalBar.size)
        finalBar.physicsBody?.isDynamic = false
        finalBar.physicsBody?.categoryBitMask = PhysicsCategories.finalBarCategory
        finalBar.physicsBody?.contactTestBitMask = PhysicsCategories.measureBarCategory
        finalBar.physicsBody?.collisionBitMask = PhysicsCategories.none
        barsNode.addChild(finalBar)
        addChild(barsNode)
    }
    
    func setUpMeasureBar() {
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
    }
    
    func setUpImages() {
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
    }
    
    func addCamera() {
        addChild(gameCamera)
        gameCamera.position = CGPoint(x: 0, y: 0)
        let maxScale = bgNode.size.width/frame.size.width
        gameCamera.setScale(maxScale)
        camera = gameCamera
    }
}
