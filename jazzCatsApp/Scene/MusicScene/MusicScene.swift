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
    
    //weak var viewController: UIViewController?
    
    var staffBarHeight: CGFloat = LevelSetup.defaultStaffBarHeight
    var staffBarNumber: Int = LevelSetup.defaultStaffBarNumber
    var staffTotalHeight: CGFloat

    var tempo: Int = LevelSetup.defaultTempo
    var numberOfMeasures: Int = LevelSetup.defaultNumberOfMeasures
    var bpm: Int = LevelSetup.defaultBpm
    var subdivision: Int = LevelSetup.defaultSubdivision
    var totalDivision: Int
    var totalBeats: Int
    var resultWidth: CGFloat
    var measureWidth: CGFloat
    var beatWidth: CGFloat
    var divisionWidth: CGFloat

    var maxPages: Int = LevelSetup.defaultMaxPages
    var pages: Array<Array<Note>>
    var pageIndex = 0
    var pgCountLabel: SKLabelNode
    
    var barsNode = SKNode()
    var measureBar: SKSpriteNode
    var barVelocity: CGFloat
    var selectedNote: String = "cat_basic1"
    weak var selectedButton: Button?
    var currentMode: String = "addMode"
    var buttons = NSMapTable<NSString, Button>.init(keyOptions: .copyIn, valueOptions: .weakMemory)
    var noteData = Set<[CGFloat]>()
    
    var currentSounds = GameUser.sounds
    //var samplers: Array<AKAppleSampler> = []
    var samplers: Array<AKMIDISampler> = []
    var mixer = AKMixer()
    var sequencer = AKAppleSequencer()
    //let conductor = Conductor()

    public init(size: CGSize, tempo: Int?, numberOfMeasures: Int?, bpm: Int?, subdivision: Int?, maxPages: Int?) {
        
        self.tempo = tempo ?? LevelSetup.defaultTempo
        self.numberOfMeasures = numberOfMeasures ?? LevelSetup.defaultNumberOfMeasures
        self.bpm = bpm ?? LevelSetup.defaultBpm
        self.subdivision = subdivision ?? LevelSetup.defaultSubdivision
        self.maxPages = maxPages ?? LevelSetup.defaultMaxPages
        self.pgCountLabel = SKLabelNode(text: "page: \(pageIndex+1)/\(self.maxPages)")
        
        self.staffTotalHeight = self.staffBarHeight*CGFloat(self.staffBarNumber)
        self.totalDivision = self.numberOfMeasures * self.bpm * self.subdivision
        self.totalBeats = self.numberOfMeasures * self.bpm
        self.resultWidth = size.width - LevelSetup.indentLength
        self.measureWidth = self.resultWidth/CGFloat(self.numberOfMeasures)
        self.beatWidth = self.resultWidth/CGFloat(self.totalBeats)
        self.divisionWidth = self.resultWidth/CGFloat(self.totalDivision)
        self.pages = [[Note]](repeating: [], count: self.maxPages)
        self.measureBar = SKSpriteNode(color: UIColor.white, size: CGSize(width: 4, height: self.staffTotalHeight + 30))
        self.barVelocity = CGFloat(self.tempo) / 60 * self.beatWidth
                
        //conductor.setUpTracks()
        super.init(size: size)
        self.backgroundColor = ColorPalette.brightManuscript

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func didMove(to view: SKView) {
        layoutScene()
        setUpPhysics()
        setUpSound()
    }
    
    deinit {
        print("byebyebye")
    }
}
