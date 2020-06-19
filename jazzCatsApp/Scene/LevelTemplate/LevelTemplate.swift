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

public class LevelTemplate: SKScene {

    weak var viewController: UIViewController?
    let gameCamera = GameCamera()
    var whichLevel: Int!
    
    public var staffBarHeight = 32
    public var staffBarNumber: Int!
    public var staffTotalHeight: Int!
    public var staffHeightFromGround: Int!

    public var numberOfMeasures: Int!
    public var bpm: Int!
    public var subdivision: Int!
    public var totalDivision: Int!
    public var resultWidth: Int!
    public var divisionWidth: Int!

    public var maxPages: Int!
    public var pages: Array<Array<Note>>!
    public var pageIndex = 0
    var pgCountLabel: SKLabelNode!
    
    var bgNode: SKSpriteNode!
    let barsNode = SKNode()
    var measureBar: SKSpriteNode!
    //var selectedNoteType = NoteType.piano
    var selectedNote = "cat_basic1"
    weak var noteButton: Button!
    var currentMode = "addMode"
    var yayYouDidIt: SKSpriteNode!
    var sorryTryAgain: SKSpriteNode!
    
    var samplers: Array<AKAppleSampler>!
    var mixer: AKMixer!
    var ansSongPlayer: AKAudioPlayer!
    
    var currentSounds = Array(GameUser.sounds.keys)
    var lvlAnsSong: String!
    var lvlAns: [Set<[Int]>] = []
    var myAns: [Set<[Int]>] = []
    var hintNum = 0
    
    public override func didMove(to view: SKView) {
        layoutScene()
        setUpPhysics()
        setUpButtons()
        setUpSound()
        print(currentSounds)
    }
    
    deinit {
        print("deinitialized")
    }
    
}

