import SpriteKit
import UIKit

public class Button: SKSpriteNode {
    
    //var bkgdShape: SKShapeNode
    var defaultButton: SKTexture
    var action: (Int) -> Void
    var index: Int
    
    public init(defaultButtonImage: UIImage?, action: @escaping (Int) -> Void, index: Int, buttonName: String, buttonLabel: String) {

        defaultButton = SKTexture(image: defaultButtonImage ?? UIImage())
        self.action = action
        self.index = index
        
        super.init(texture: defaultButton, color: UIColor.clear, size: CGSize(width: 70, height: 70))
        self.name = buttonName
        isUserInteractionEnabled = true
        
        let bkgdShape = SKShapeNode(rectOf: CGSize(width: 100, height: 100), cornerRadius: 20)
        bkgdShape.lineWidth = 6
        bkgdShape.strokeColor = ColorPalette.lineColor
        bkgdShape.fillColor = ColorPalette.unselectedButton
        bkgdShape.zPosition = -1
        bkgdShape.position = CGPoint(x: 0, y: -20)
        self.addChild(bkgdShape)
        
        let label = SKLabelNode(text: buttonLabel)
        label.fontName = "Gaegu-Regular"
        label.fontSize = CGFloat(30)
        label.fontColor = ColorPalette.lineColor
        label.zPosition = 500
        bkgdShape.addChild(label)
        label.position = CGPoint(x: 0, y: -35)
        label.color = ColorPalette.lineColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        action(index)
    }
}
