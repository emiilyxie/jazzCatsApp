//
//  LevelSetup.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/19/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit

public let indentLength = 100

public var lvl1Ans = [[Set(["D5"]), Set([]), Set(["G4"]), Set(["A4"]), Set(["B4"]), Set(["C5"]), Set(["D5"]), Set([]), Set(["G4"]), Set([]), Set(["G4"]), Set([])]]

public var lvl3Ans = [[Set(["A4"]), Set(["C5"]), Set(["E5"]), Set(["G5"]), Set(["F5s"]), Set([]), Set([]), Set(["E5"]), Set(["D5"]), Set(["B4"]), Set(["G4"]), Set([]), Set(["A4s"]), Set(["C5"]), Set(["D5"]), Set(["F5"])], [Set(["D5s"]), Set(["A4s"]), Set(["G4"]), Set([]), Set(["G4s"]), Set(["E4"]), Set(["D4s"]), Set(["C4s"]), Set(["B3"]), Set(["C4s"]), Set(["D4s"]), Set(["E4"]), Set(["F4s"]), Set(["G4s"]), Set(["A4s"]), Set(["B4"])], [Set(["C5"]), Set(["G4s"]), Set(["F4"]), Set(["D4s"]), Set(["D4"]), Set(["B4"]), Set(["A4s"]), Set(["G4s"]), Set(["G4"]), Set(["A4s"]), Set(["D5s"]), Set(["G5"]), Set(["A4s"]), Set(["C5s"]), Set(["E5"]), Set(["G5s"])], [Set(["B4"]), Set(["C5s"]), Set(["D5s"]), Set(["F5s"]), Set(["C5"]), Set(["E5"]), Set(["F5s"]), Set(["G5s"]), Set(["F5s"]), Set([]), Set(["E5"]), Set(["D5"]), Set([]), Set([]), Set([]), Set([])]]

public func prepareLevel(level: LevelTemplate, levelNum: Int) {
    switch levelNum {
    case 1:
        setUpLevel(level: level, staffBarHeight: 32, staffBarNumber: 12, numberOfMeasures: 2, bpm: 3, subdivision: 2, maxPages: 1, lvlAns: lvl1Ans)
    case 3:
        setUpLevel(level: level, staffBarHeight: 32, staffBarNumber: 12, numberOfMeasures: 2, bpm: 4, subdivision: 2, maxPages: 4, lvlAns: lvl3Ans)
    default:
        setUpLevel(level: level, staffBarHeight: 32, staffBarNumber: 12, numberOfMeasures: 2, bpm: 4, subdivision: 2, maxPages: 1, lvlAns: lvl1Ans)
    }
}

public func setUpLevel(level: LevelTemplate, staffBarHeight: Int, staffBarNumber: Int, numberOfMeasures: Int, bpm: Int, subdivision: Int, maxPages: Int, lvlAns: Array<[Set<String>]>) {
    
    //print(sceneWidth)
    //print(sceneHeight)
    
    level.staffBarHeight = staffBarHeight
    level.staffBarNumber = staffBarNumber
    level.staffTotalHeight = staffBarHeight * staffBarNumber
    let halfHeight = Int(level.size.height) / 2
    let halfStaffHeight = level.staffTotalHeight / 2
    let staffHeightFromGround = halfHeight - halfStaffHeight
    level.staffHeightFromGround = staffHeightFromGround
    
    level.numberOfMeasures = numberOfMeasures
    level.bpm = bpm
    level.subdivision = subdivision
    level.totalDivision = numberOfMeasures * bpm * subdivision
    
    level.resultWidth = Int(level.size.width) - indentLength
    level.divisionWidth = level.resultWidth / level.totalDivision
    
    level.maxPages = maxPages
    level.pages = [[Note]](repeating: [], count: maxPages)
    
    //lvlAns = Array(repeating: [Set<String>](repeating: [], count: totalDivision), count: maxPages)
    level.lvlAns = lvlAns
    level.myAns = Array(repeating: [Set<String>](repeating: [], count: level.totalDivision), count: maxPages)
}

public func prepareFreestyle(freestyleLevel: Freestyle) {
    sceneWidth = CGFloat(freestyleLevel.size.width)
    sceneHeight = CGFloat(freestyleLevel.size.height)
    
    freestyleLevel.staffBarHeight = 32
    freestyleLevel.staffBarNumber = 12
    freestyleLevel.staffTotalHeight = freestyleLevel.staffBarHeight * freestyleLevel.staffBarNumber
    let halfHeight = Int(sceneHeight) / 2
    let halfStaffHeight = freestyleLevel.staffTotalHeight / 2
    let staffHeightFromGround = halfHeight - halfStaffHeight
    freestyleLevel.staffHeightFromGround = staffHeightFromGround
    
    freestyleLevel.numberOfMeasures = 2
    freestyleLevel.bpm = 5
    freestyleLevel.subdivision = 2
    freestyleLevel.oldSubdivision = 2
    freestyleLevel.totalDivision = freestyleLevel.numberOfMeasures * freestyleLevel.bpm * freestyleLevel.subdivision
    
    freestyleLevel.resultWidth = Int(sceneWidth) - indentLength
    freestyleLevel.divisionWidth = freestyleLevel.resultWidth / freestyleLevel.totalDivision
    
    freestyleLevel.maxPages = 2
    freestyleLevel.pages = [[Note]](repeating: [], count: freestyleLevel.maxPages)
    
}
