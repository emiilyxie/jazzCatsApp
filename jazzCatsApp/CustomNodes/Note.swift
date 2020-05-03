//
//  Note.swift
//  colorSwitch
//
//  Created by Emily Xie on 4/16/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import SpriteKit
import AVFoundation

class Note: SKSpriteNode {

    let noteType: NoteType
    var positionInTileMap = [0,0]
    
    init(type: NoteType) {
        noteType = type
        
        let color: UIColor!
        switch type {
        case .piano:
            color = UIColor.red
        case .bass:
            color = UIColor.blue
        case .snare:
            color = UIColor.green
        case .hihat:
            color = UIColor.yellow
        }
        
        super.init(texture: nil, color: color, size: CGSize(width: 30, height: 30))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
