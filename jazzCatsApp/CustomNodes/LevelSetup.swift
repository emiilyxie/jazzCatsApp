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

    static public var lvl1Ans = [Set(arrayLiteral: [0, 74], [2, 67], [3, 69], [4, 71], [5, 72], [6, 74], [8, 67], [10, 67])]

    static public var lvl2Ans = [Set(arrayLiteral: [1, 69], [2, 65], [3, 74], [4, 72], [6, 69], [7, 65], [9, 62], [10, 67]), Set(arrayLiteral: [0, 65], [1, 67], [2, 69], [3, 74], [5, 76], [6, 77], [7, 72])]

    static public var lvl3Ans = [Set([[2, 76], [3, 79], [1, 72], [13, 72], [7, 76], [8, 74], [10, 67], [0, 69], [12, 70], [15, 77], [14, 74], [4, 78], [9, 71]]), Set([[11, 64], [1, 70], [0, 75], [13, 68], [10, 63], [4, 68], [15, 71], [9, 61], [2, 67], [5, 64], [7, 61], [8, 59], [14, 70], [12, 66], [6, 63]]), Set([[8, 67], [3, 63], [6, 70], [7, 68], [1, 68], [11, 79], [12, 70], [5, 71], [4, 62], [15, 80], [13, 73], [9, 70], [14, 76], [2, 65], [10, 75], [0, 72]]), Set([[11, 74], [0, 71], [8, 78], [4, 72], [5, 76], [2, 75], [7, 81], [10, 76], [1, 73], [3, 78], [6, 78]])]

    static public func prepareLevel(level: LevelTemplate, levelNum: Int, showScene: @escaping () -> Void) {
        
        //print(2)
        getLvlAns(levelNum: levelNum) {
            //print(5)
            switch levelNum {
            case 1:
                setUpLevel(level: level, levelNum: levelNum,staffBarHeight: 32, staffBarNumber: 12, numberOfMeasures: 2, bpm: 3, subdivision: 2, maxPages: 1, lvlAns: lvl1Ans)
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
