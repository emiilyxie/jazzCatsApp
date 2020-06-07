//
//  LevelSetup.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/19/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import FirebaseFirestore

public class LevelSetup {

    static public let indentLength = 100
    
    static let defaultStaffBarHeight = 32
    static let defaultStaffBarNumber = 12
    static let defaultNumberOfMeasures = 2
    static let defaultBpm = 4
    static let defaultSubdivision = 2
    static let defaultMaxPages = 2
    
    static var lvlGroup: String!
    static var lvlAns: Array<Set<[Int]>>!

    static public func prepareLevel(level: LevelTemplate, levelGroup: String, levelNum: Int, showScene: @escaping () -> Void) {
        
        getLvlInfo(level: level, levelGroup: levelGroup, levelNum: levelNum) {
            showScene()
        }
        
    }
    
    static public func getLvlInfo(level: LevelTemplate, levelGroup: String, levelNum: Int, showTheScene: @escaping () -> Void) {
        
        let db = Firestore.firestore()
        let docPath = "/level-groups/\(levelGroup)/levels"
        
        let docRef = db.collection(docPath).document("level\(levelNum)")

        docRef.getDocument { (document, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            if let document = document, document.exists {
                
                var staffBarHeight = defaultStaffBarHeight
                var staffBarNumber = defaultStaffBarNumber
                var numberOfMeasures = defaultNumberOfMeasures
                var bpm = defaultBpm
                var subdivision = defaultSubdivision
                var maxPages = defaultMaxPages
                
                if document.get("staffbar-height") != nil {
                    staffBarHeight = document.get("staffbar-height") as! Int
                }
                if document.get("staffbar-number") != nil {
                    staffBarNumber = document.get("staffbar-number") as! Int
                }
                if document.get("number-of-measures") != nil {
                    numberOfMeasures = document.get("staffbar-height") as! Int
                }
                if document.get("bpm") != nil {
                    bpm = document.get("bpm") as! Int
                }
                if document.get("subdivision") != nil {
                    subdivision = document.get("subdivision") as! Int
                }
                if document.get("maxpages") != nil {
                    maxPages = document.get("maxpages") as! Int
                }
                                
                if let lvlAnsString = document.get("answer") as? String {
                    lvlAns = parseLvlAns(json: lvlAnsString, maxPages: maxPages)
                    setUpLevel(level: level, levelNum: levelNum, staffBarHeight: staffBarHeight, staffBarNumber: staffBarNumber, numberOfMeasures: numberOfMeasures, bpm: bpm, subdivision: subdivision, maxPages: maxPages, lvlAns: lvlAns)
                    showTheScene()
                    return
                }
                else {
                    print("couldn't get the level answer from the doc")
                    return
                }
            }
            else {
                print("doc doesn't exist")
                return
            }
        }
    }

    static public func setUpLevel(level: LevelTemplate, levelNum: Int, staffBarHeight: Int, staffBarNumber: Int, numberOfMeasures: Int, bpm: Int, subdivision: Int, maxPages: Int, lvlAns: Array<Set<[Int]>>) {
        
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
        
        level.lvlAnsSong = "lvl\(levelNum)song.mp3"
        level.lvlAns = lvlAns
        level.myAns = Array(repeating: Set([]), count: maxPages)
    }

    static public func prepareFreestyle(freestyleLevel: Freestyle) {
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
        freestyleLevel.oldNumOfMeasures = 2
        freestyleLevel.bpm = 4
        freestyleLevel.oldBpm = 4
        freestyleLevel.subdivision = 2
        freestyleLevel.oldSubdivision = 2
        freestyleLevel.totalDivision = freestyleLevel.numberOfMeasures * freestyleLevel.bpm * freestyleLevel.subdivision
        
        freestyleLevel.resultWidth = Int(sceneWidth) - indentLength
        freestyleLevel.divisionWidth = freestyleLevel.resultWidth / freestyleLevel.totalDivision
        
        freestyleLevel.maxPages = 2
        freestyleLevel.pages = [[Note]](repeating: [], count: freestyleLevel.maxPages)
        
    }

    static public func parseLvlAns(json: String, maxPages: Int) -> Array<Set<[Int]>> {
        let data = Data(json.utf8)
        var lvlAnsArray: Array<Array<Array<Int>>> = []
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[[Int]]] {
                print(json)
                print(type(of: json))
                lvlAnsArray = json
            }
        }
        catch let err as NSError {
            print(err.localizedDescription)
        }
        
        var ansSet = [Set<[Int]>](repeatElement([], count: maxPages))
        for page in 0...lvlAnsArray.count-1 {
            for ansArr in 0...lvlAnsArray[page].count-1 {
                let currentNoteAns = lvlAnsArray[page][ansArr]
                ansSet[page].insert(currentNoteAns)
            }
        }
        return ansSet
    }

}
