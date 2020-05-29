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

    static public var lvlAns: Array<Set<[Int]>>!
    
    static public let indentLength = 100

    static public func prepareLevel(level: LevelTemplate, levelNum: Int, showScene: @escaping () -> Void) {
        
        getLvlAns(levelNum: levelNum) {
            //print(5)
            switch levelNum {
            case 1:
                setUpLevel(level: level, levelNum: levelNum,staffBarHeight: 32, staffBarNumber: 12, numberOfMeasures: 2, bpm: 3, subdivision: 2, maxPages: 1, lvlAns: lvlAns)
            case 2:
                setUpLevel(level: level, levelNum: levelNum, staffBarHeight: 32, staffBarNumber: 12, numberOfMeasures: 2, bpm: 4, subdivision: 2, maxPages: 2, lvlAns: lvlAns)
            case 3:
                setUpLevel(level: level, levelNum: levelNum, staffBarHeight: 32, staffBarNumber: 12, numberOfMeasures: 2, bpm: 4, subdivision: 2, maxPages: 4, lvlAns: lvlAns)
            default:
                setUpLevel(level: level, levelNum: levelNum, staffBarHeight: 32, staffBarNumber: 12, numberOfMeasures: 2, bpm: 4, subdivision: 2, maxPages: 1, lvlAns: [])
            }
            //print(7)
            showScene()
        }
    }

    static public func setUpLevel(level: LevelTemplate, levelNum: Int, staffBarHeight: Int, staffBarNumber: Int, numberOfMeasures: Int, bpm: Int, subdivision: Int, maxPages: Int, lvlAns: Array<Set<[Int]>>) {
        
        //print(6)
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
    
    static public func getLvlAns(levelNum: Int, setUpTheLevel: @escaping () -> Void) {
        //print(3)
        let db = Firestore.firestore()
        
        let docRef = db.collection("levels").document("level\(levelNum)")

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                //print("Document data: \(dataDescription)")
                print("\(dataDescription)")
                if let lvlAnsString = document.get("answer") as? String, let maxPages = document.get("maxpages") as? Int {
                    lvlAns = parseLvlAns(json: lvlAnsString, maxPages: maxPages)
                    //print(lvlAns)
                    //print(3.1)
                    setUpTheLevel()
                    //print(3.2)
                    return
                }
                else {
                    print("couldn't get the data from the doc")
                    return
                }
            }
            else {
                //print("Document does not exist")
                print("doc doesn't exist")
                //completion()
                return
            }
        }
        
        //print(4)
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
