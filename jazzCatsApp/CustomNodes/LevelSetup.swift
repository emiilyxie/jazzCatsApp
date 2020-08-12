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

public struct LevelSetup {
    
    static public let sceneSize = CGSize(width: CGFloat(1370), height: CGFloat(1024))
    //static public let sceneSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
    static public let indentLength = CGFloat(100)
    
    static let defaultStaffBarHeight = CGFloat(32)
    static let defaultStaffBarNumber = 12
    static let defaultTempo = 100
    static let defaultNumberOfMeasures = 2
    static let defaultBpm = 4
    static let defaultSubdivision = 2
    static let defaultMaxPages = 2
    static let defaultReward = ["game-currency": 100, "hints": 1]
    
    static var lvlGroup: String!
    static var lvlAns: Array<Set<[Int]>>!

    static public func parseLvlAns(json: String, maxPages: Int) -> Set<[CGFloat]> {
        let data = Data(json.utf8)
        //var lvlAnsArray: [[[CGFloat]]]  = []
        var lvlAnsArray: [[CGFloat]]  = []
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [[CGFloat]] {
                //print(json)
                //print(type(of: json))
                lvlAnsArray = json
            }
        }
        catch let err as NSError {
            print(err.localizedDescription)
        }
        
        //var ansSet = [Set<[CGFloat]>](repeatElement([], count: maxPages))
        var ansSet = Set<[CGFloat]>()
        for ans in 0...lvlAnsArray.count-1 {
            //for ansArr in 0...lvlAnsArray[page].count-1 {
                let currentNoteAns = lvlAnsArray[ans]
                //ansSet[page].insert(currentNoteAns)
                ansSet.insert(currentNoteAns)
            //}
        }
        return ansSet
    }

}
