//
//  Button.swift
//  colorSwitch
//
//  Created by Emily Xie on 4/21/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import SpriteKit

class Button: SKSpriteNode {
    
    var defaultButton: SKSpriteNode
    var action: (Int) -> Void
    var index: Int
    
    init(defaultButtonImage: UIColor, action: @escaping (Int) -> Void, index: Int, buttonName: String) {
        defaultButton = SKSpriteNode(color: defaultButtonImage, size:
        CGSize(width: 30, height: 30))
        self.action = action
        self.index = index
        
        super.init(texture: nil, color: defaultButton.color, size: defaultButton.size)
        self.name = buttonName
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        action(index)
    }
    
    
}
