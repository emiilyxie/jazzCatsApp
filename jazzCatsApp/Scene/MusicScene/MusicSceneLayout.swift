//
//  MusicSceneLayout.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 6/20/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension MusicScene {
    
    func layoutScene() {
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        setUpStaff()
        setUpMeasureBar()
        setUpButtons()
        setUpImages()
    }
    
    func setUpStaff() {
        let halfHeight = self.size.height/2
        let halfStaffHeight = staffTotalHeight/2
        let staffHeightFromGround = halfHeight - halfStaffHeight
        barsNode.position = CGPoint(x: 0, y: staffHeightFromGround)
        
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
                lineWidth += 2
            }
            if i % (totalDivision / numberOfMeasures) == 0 {
                lineWidth += 2
            }
            if lineWidth == 0 {
                continue
            }
            else {
                let xPos = LevelSetup.indentLength + CGFloat(i) * divisionWidth
                let measureLine = SKShapeNode(rect: CGRect(x: xPos, y: 0, width: CGFloat(lineWidth), height: staffTotalHeight))
                measureLine.fillColor = ColorPalette.lineColor
                measureLine.lineWidth = CGFloat(0)
                barsNode.addChild(measureLine)
            }
        }
        
        // final bar with physics
        let finalBar = SKSpriteNode(color: UIColor.black, size: CGSize(width: 6, height: staffTotalHeight))
        finalBar.position = CGPoint(x: LevelSetup.indentLength + CGFloat(totalDivision) * divisionWidth, y: finalBar.size.height/2)
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
        measureBar = SKSpriteNode(color: UIColor.gray, size: CGSize(width: 4, height: staffTotalHeight + 30))
        measureBar.position.x = frame.minX + LevelSetup.indentLength - 50.0
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
    
    @objc func setUpImages() {
        // adding treble clef
        /*
        let trebleClef = SKSpriteNode(imageNamed: "temp-treble_clef")
        let trebleClefScaledSize = CGSize(width: trebleClef.frame.width / 8, height: trebleClef.frame.height / 8)
        trebleClef.scale(to: trebleClefScaledSize)
        trebleClef.anchorPoint = CGPoint(x: 0, y: 0)
        trebleClef.position = CGPoint(x: 0, y: 0)
        barsNode.addChild(trebleClef)
 */
    }
}
