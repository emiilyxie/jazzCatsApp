import SpriteKit
import UIKit

public class Button: SKSpriteNode {
    
    var bkgdShape: SKShapeNode
    var defaultButton: SKTexture
    var action: (Int) -> Void
    var index: Int
    
    public init(defaultButtonImage: UIImage?, action: @escaping (Int) -> Void, index: Int, buttonName: String) {

        defaultButton = SKTexture(image: defaultButtonImage ?? UIImage())
        bkgdShape = SKShapeNode(rectOf: CGSize(width: 100, height: 100), cornerRadius: 20)
        self.action = action
        self.index = index
        
        super.init(texture: defaultButton, color: UIColor.clear, size: CGSize(width: 50, height: 50))
        self.name = buttonName
        isUserInteractionEnabled = true
        
        bkgdShape.lineWidth = 3
        bkgdShape.strokeColor = UIColor.black
        bkgdShape.fillColor = UIColor.white
        bkgdShape.zPosition = -1
        self.addChild(bkgdShape)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        action(index)
    }
}
