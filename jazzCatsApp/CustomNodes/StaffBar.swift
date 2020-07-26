import SpriteKit
import UIKit

public class StaffBar: SKSpriteNode {
    public let index: Int
    
    public init(barIndex: Int, barHeight: CGFloat) {
        index = barIndex
        
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: LevelSetup.sceneSize.width, height: barHeight))
        
        /*
        if let staffBarWidth = self.parent?.frame.width {
            print(staffBarWidth)
            self.size.width = staffBarWidth
        }
 */
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func drawLineThru() {
        
        let shapeNode = SKShapeNode(rect: CGRect(x: 0, y: 0, width: LevelSetup.sceneSize.width, height: 4))
        shapeNode.fillColor = ColorPalette.lineColor
        shapeNode.lineWidth = CGFloat(0)
        addChild(shapeNode)

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
