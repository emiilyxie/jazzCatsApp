//
//  MusicScene.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 6/19/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

public class MusicScene: SKScene {
    
    var staffBarHeight: CGFloat = LevelSetup.defaultStaffBarHeight
    var staffBarNumber: Int = LevelSetup.defaultStaffBarNumber
    var staffTotalHeight: CGFloat

    var numberOfMeasures: Int = LevelSetup.defaultNumberOfMeasures
    var bpm: Int = LevelSetup.defaultBpm
    var subdivision: Int = LevelSetup.defaultSubdivision
    var totalDivision: Int
    var resultWidth: CGFloat
    var divisionWidth: CGFloat

    var maxPages: Int = LevelSetup.defaultMaxPages
    var pages: Array<Array<Note>>
    var pageIndex = 0
    var pgCountLabel: SKLabelNode
    
    //var bgNode: SKSpriteNode?
    var barsNode = SKNode()
    var measureBar: SKSpriteNode
    var selectedNote: String = "cat_basic1"
    var currentMode: String = "addMode"
    weak var noteButton: Button?
    
    var currentSounds = Array(GameUser.sounds.keys)
    var samplers: Array<AKAppleSampler> = []
    var mixer = AKMixer()

    public init(size: CGSize, numberOfMeasures: Int?, bpm: Int?, subdivision: Int?, maxPages: Int?) {
        
        self.numberOfMeasures = numberOfMeasures ?? LevelSetup.defaultNumberOfMeasures
        self.bpm = bpm ?? LevelSetup.defaultBpm
        self.subdivision = subdivision ?? LevelSetup.defaultSubdivision
        self.maxPages = maxPages ?? LevelSetup.defaultMaxPages
        self.pgCountLabel = SKLabelNode(text: "page: \(pageIndex+1)/\(self.maxPages)")
        
        self.staffTotalHeight = self.staffBarHeight*CGFloat(self.staffBarNumber)
        self.totalDivision = self.numberOfMeasures * self.bpm * self.subdivision
        self.resultWidth = size.width - LevelSetup.indentLength
        self.divisionWidth = self.resultWidth/CGFloat(self.totalDivision)
        self.pages = [[Note]](repeating: [], count: self.maxPages)
        
        self.measureBar = SKSpriteNode(color: UIColor.white, size: CGSize(width: 4, height: self.staffTotalHeight + 30))
        
        super.init(size: size)
        self.backgroundColor = UIColor(red: 0.97, green: 0.92, blue: 0.91, alpha: 1.00)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        layoutScene()
        setUpPhysics()
        setUpButtons()
        setUpSound()
    }
    
    deinit {
        print("byebyebye")
    }
}
