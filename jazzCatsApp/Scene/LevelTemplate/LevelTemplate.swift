//
//  FreestyleScene.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/18/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

public class LevelTemplate: MusicScene {
    
    //weak var viewController: UIViewController?
    var levelGroup: String
    var levelNum: Int
    var from: String?
    
    var hintCount: SKLabelNode = {
        let label = SKLabelNode(text: String(GameUser.hints))
        label.fontName = "Gaegu-Bold"
        label.fontColor = .white
        label.fontSize = CGFloat(20)
        label.zPosition = 501
        label.position = CGPoint(x: 0, y: 0)
        return label
    }()
    var yayYouDidIt: SKSpriteNode
    var sorryTryAgain: SKSpriteNode
    
    var lvlAnsSong: String
    var ansSongPlayer: AKAudioPlayer?
    
    var lvlAns = Set<[CGFloat]>()
    var myAns = Set<[CGFloat]>()
    var hintNum = 0
    var reward: Dictionary<String, Any>
    
    public init(size: CGSize, levelGroup: String, levelNum: Int, from: String?, tempo: Int?, numberOfMeasures: Int?, bpm: Int?, subdivision: Int?, maxPages: Int?, lvlAns: Set<[CGFloat]>, reward: Dictionary<String, Any>?) {
        
        self.levelGroup = levelGroup
        self.levelNum = levelNum
        self.from = from
        self.yayYouDidIt = SKSpriteNode(imageNamed: "temp-you-did-it")
        self.sorryTryAgain = SKSpriteNode(imageNamed: "temp-try-again")
        self.lvlAnsSong = "\(levelGroup)\(levelNum).mp3"
        self.lvlAns = lvlAns
        //self.myAns = Array(repeating: Set([]), count: maxPages ?? LevelSetup.defaultMaxPages)
        //self.myAns: Set<[CGFloat]> = []
        self.reward = reward ?? LevelSetup.defaultReward
        
        super.init(size: size, tempo: tempo, numberOfMeasures: numberOfMeasures, bpm: bpm, subdivision: subdivision, maxPages: maxPages)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinitialized")
    }
    
}

