//
//  NumberControls.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/21/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit

public class NumberControls: SKSpriteNode {
    
    public var minVal: Int!
    public var maxVal: Int!
    public var isPlus: Bool!
    
    public init(minVal: Int, maxVal: Int, isPlus: Bool) {
        self.minVal = minVal
        self.maxVal = maxVal
        self.isPlus = isPlus
        var image: SKTexture!
        if isPlus {
            image = SKTexture(imageNamed: "sharp.png")
        }
        else {
            image = SKTexture(imageNamed: "flat.png")
        }
        
        super.init(texture: image, color: UIColor.clear, size: CGSize(width: 30, height: 30))
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("number control touched")
        if let parentLabel = self.parent as! SKLabelNode? {
            let numberVal = Int(parentLabel.text!) ?? 0
            if isPlus {
                if numberVal < maxVal {
                    parentLabel.text = String(numberVal + 1)
                }
            }
            else {
                if numberVal > minVal {
                    parentLabel.text = String(numberVal - 1)
                }
            }
        }
    }
    
}
