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
    
    weak var viewController: UIViewController?

    public var oldNumOfMeasures: Int!
    public var oldBpm: Int!
    public var oldSubdivision: Int!
    
    //weak var noteButton: Button?
    
    deinit {
        print("deinitialized")
    }
}
