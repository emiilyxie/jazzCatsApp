import SpriteKit
import UIKit

public class Button: SKSpriteNode {
    
    public var defaultButton: SKTexture
    public var action: (Int) -> Void
    public var index: Int
    
    public init(defaultButtonImage: String, action: @escaping (Int) -> Void, index: Int, buttonName: String) {
        //defaultButton = SKSpriteNode(color: defaultButtonImage, size: CGSize(width: 30, height: 30))
        defaultButton = SKTexture(imageNamed: defaultButtonImage)
        self.action = action
        self.index = index
        
        super.init(texture: defaultButton, color: UIColor.clear, size: CGSize(width: 50, height: 50))
        self.name = buttonName
        
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        action(index)
    }
}
