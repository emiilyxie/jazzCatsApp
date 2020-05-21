import SpriteKit
import UIKit

public class StaffBar: SKSpriteNode {
    public let index: Int
    
    public init(barIndex: Int, barHeight: Int) {
        index = barIndex
        
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: Int(sceneWidth), height: barHeight))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func drawLineThru() {
        /*
         let shapeNode = SKShapeNode(rect: CGRect(x: 0, y: Int(self.position.y), width: sceneWidth, height: 4))
         shapeNode.fillColor = .black
         //shapeNode.strokeColor = UIColor.black
         shapeNode.lineWidth = 1
         addChild(shapeNode)
         */
        if let linePic = UIImage(named: "long-thin.png") {
            self.texture = SKTexture(image: linePic)
        }
    }
    
    public func colorDebug(i: Int) {
        if i % 2 == 0 {
            self.color = UIColor.red
        }
        else {
            self.color = UIColor.purple
        }
    }
}
