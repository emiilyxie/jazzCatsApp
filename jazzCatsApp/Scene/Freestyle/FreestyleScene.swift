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

public class Freestyle: MusicScene {
    
    //weak var viewController: UIViewController?

    
    init(size: CGSize) {
        super.init(size: size, tempo: nil, numberOfMeasures: nil, bpm: nil, subdivision: nil, maxPages: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("deinitialized")
    }
}
