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

public class Freestyle: SKScene {

    weak var viewController: UIViewController?
    let gameCamera = GameCamera()
    
    public var staffBarHeight: Int!
    public var staffBarNumber: Int!
    public var staffTotalHeight: Int!
    public var staffHeightFromGround: Int!

    public var numberOfMeasures: Int!
    public var oldNumOfMeasures: Int!
    public var bpm: Int!
    public var oldBpm: Int!
    public var subdivision: Int!
    public var oldSubdivision: Int!
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
    var selectedNoteType = NoteType.piano
    var currentMode = "addMode"
    var settingsPopup: SKShapeNode!
    
    var samplers: Array<AKAppleSampler>!
    var mixer: AKMixer!
    
    public override func didMove(to view: SKView) {
        layoutScene()
        setUpPhysics()
        setUpSound()
    }
    
    deinit {
        print("deinitialized")
    }
}
