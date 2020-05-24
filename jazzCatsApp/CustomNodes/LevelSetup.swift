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

//public var lvl1Ans = [[Set(["D5"]), Set([]), Set(["G4"]), Set(["A4"]), Set(["B4"]), Set(["C5"]), Set(["D5"]), Set([]), Set(["G4"]), Set([]), Set(["G4"]), Set([])]]

public var lvl1Ans = [Set(arrayLiteral: [0, 74], [2, 67], [3, 69], [4, 71], [5, 72], [6, 74], [8, 67], [10, 67])]

public var lvl2Ans = [Set(arrayLiteral: [1, 69], [2, 65], [3, 74], [4, 72], [6, 69], [7, 65], [9, 62], [10, 67]), Set(arrayLiteral: [0, 65], [1, 67], [2, 69], [3, 74], [5, 76], [6, 77], [7, 72])]

public var lvl3Ans = [Set([[2, 76], [3, 79], [1, 72], [13, 72], [7, 76], [8, 74], [10, 67], [0, 69], [12, 70], [15, 77], [14, 74], [4, 78], [9, 71]]), Set([[11, 64], [1, 70], [0, 75], [13, 68], [10, 63], [4, 68], [15, 71], [9, 61], [2, 67], [5, 64], [7, 61], [8, 59], [14, 70], [12, 66], [6, 63]]), Set([[8, 67], [3, 63], [6, 70], [7, 68], [1, 68], [11, 79], [12, 70], [5, 71], [4, 62], [15, 80], [13, 73], [9, 70], [14, 76], [2, 65], [10, 75], [0, 72]]), Set([[11, 74], [0, 71], [8, 78], [4, 72], [5, 76], [2, 75], [7, 81], [10, 76], [1, 73], [3, 78], [6, 78]])]

//public var lvl3Ans = [[Set(["A4"]), Set(["C5"]), Set(["E5"]), Set(["G5"]), Set(["F5s"]), Set([]), Set([]), Set(["E5"]), Set(["D5"]), Set(["B4"]), Set(["G4"]), Set([]), Set(["A4s"]), Set(["C5"]), Set(["D5"]), Set(["F5"])], [Set(["D5s"]), Set(["A4s"]), Set(["G4"]), Set([]), Set(["G4s"]), Set(["E4"]), Set(["D4s"]), Set(["C4s"]), Set(["B3"]), Set(["C4s"]), Set(["D4s"]), Set(["E4"]), Set(["F4s"]), Set(["G4s"]), Set(["A4s"]), Set(["B4"])], [Set(["C5"]), Set(["G4s"]), Set(["F4"]), Set(["D4s"]), Set(["D4"]), Set(["B4"]), Set(["A4s"]), Set(["G4s"]), Set(["G4"]), Set(["A4s"]), Set(["D5s"]), Set(["G5"]), Set(["A4s"]), Set(["C5s"]), Set(["E5"]), Set(["G5s"])], [Set(["B4"]), Set(["C5s"]), Set(["D5s"]), Set(["F5s"]), Set(["C5"]), Set(["E5"]), Set(["F5s"]), Set(["G5s"]), Set(["F5s"]), Set([]), Set(["E5"]), Set(["D5"]), Set([]), Set([]), Set([]), Set([])]]

public func prepareLevel(level: LevelTemplate, levelNum: Int) {
    switch levelNum {
    case 1:
        setUpLevel(level: level, levelNum: levelNum,staffBarHeight: 32, staffBarNumber: 12, numberOfMeasures: 2, bpm: 3, subdivision: 2, maxPages: 1, lvlAns: lvl1Ans)
    case 2:
        setUpLevel(level: level, levelNum: levelNum, staffBarHeight: 32, staffBarNumber: 12, numberOfMeasures: 2, bpm: 4, subdivision: 2, maxPages: 2, lvlAns: lvl2Ans)
    case 3:
        setUpLevel(level: level, levelNum: levelNum, staffBarHeight: 32, staffBarNumber: 12, numberOfMeasures: 2, bpm: 4, subdivision: 2, maxPages: 4, lvlAns: lvl3Ans)
    default:
        setUpLevel(level: level, levelNum: levelNum, staffBarHeight: 32, staffBarNumber: 12, numberOfMeasures: 2, bpm: 4, subdivision: 2, maxPages: 1, lvlAns: lvl1Ans)
    }
}

public func setUpLevel(level: LevelTemplate, levelNum: Int, staffBarHeight: Int, staffBarNumber: Int, numberOfMeasures: Int, bpm: Int, subdivision: Int, maxPages: Int, lvlAns: Array<Set<[Int]>>) {
    
    level.whichLevel = levelNum
    
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
    level.lvlAnsSong = "lvl\(levelNum)song.mp3"
    level.lvlAns = lvlAns
    //level.myAns = Array(repeating: [Set<String>](repeating: [], count: level.totalDivision), count: maxPages)
    level.myAns = Array(repeating: Set([]), count: maxPages)
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
