import SpriteKit
import UIKit

public class Note: SKSpriteNode {
    
    public let noteType: String
    public var positionInStaff = [0,0]
    public var universalTimePos: Double?
    public var soundBase: String
    public var audioFile: String
    public var isSharp = false
    public var isFlat = false
    
    public init(type: String) {
        noteType = type
        
        let noteTexture = SKTexture(imageNamed: type)
        soundBase = type
        audioFile = "\(type).mp3"
        
        super.init(texture: noteTexture, color: UIColor.clear, size: CGSize(width: 40, height: 40))
        
        self.name = "note"
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategories.noteCategory
        self.physicsBody?.contactTestBitMask = PhysicsCategories.measureBarCategory
        self.physicsBody?.collisionBitMask = PhysicsCategories.none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getAudioFile() -> String {
        let noteVal = getNoteName()
        
        if soundBase == "snare" {
            return "\(soundBase)/\(soundBase).mp3"
        }
        return "\(soundBase)/\(soundBase)\(noteVal).mp3"
    }
    
    // MUST place note in staff before calling
    public func setPositions() {
        
        //print(self.parent?.parent)
        
        if let scene = self.parent?.parent as? LevelTemplate {
            self.positionInStaff = scene.getStaffPosition(notePosition: self.position)
            let conversion = Double(scene.subdivision / (scene.pageIndex + 1))
            self.universalTimePos = Double(self.positionInStaff[0]) / conversion
        }
        else {
            //print("parent is not level template")
        }
        
        if let scene = self.parent?.parent as? Freestyle {
            self.positionInStaff = scene.getStaffPosition(notePosition: self.position)
            let conversion = Double(scene.subdivision / (scene.pageIndex + 1))
            self.universalTimePos = Double(self.positionInStaff[0]) / conversion
        }
        else {
            //print("parent is not freestyle")
        }
    }
    
    public func toggleSharp() {
        if !self.isSharp {
            self.isSharp = true
        }
        else {
            self.isSharp = false
        }
    }
    
    public func toggleFlat() {
        if !self.isFlat {
            self.isFlat = true
        }
        else {
            self.isFlat = false
        }
    }
    
    public func getNoteName() -> String {
        if positionInStaff[1] == 0 && isFlat { // C4 flat is B3
            return "\(MusicValues.trebleNotes[0])"
        }
        if (positionInStaff[1] == 3 || positionInStaff[1] == 7 || positionInStaff[1] == 10) && isFlat { // for enharmonics
            return "\(MusicValues.trebleNotes[positionInStaff[1]])"
        }
        if isSharp {
            return "\(MusicValues.trebleNotes[positionInStaff[1] + 13])"
        }
        if isFlat {
            return "\(MusicValues.trebleNotes[positionInStaff[1] + 12])"
        }
        return "\(MusicValues.trebleNotes[positionInStaff[1] + 1])"
    }
    
    public func getMidiVal() -> Int {
        var midiVal = MusicValues.middleCMidi
        let distFromMiddleC = positionInStaff[1] - MusicValues.middleCPos
        if distFromMiddleC > 0 {
            let octaveNums = Int((Double(distFromMiddleC) / 7.0).rounded(.down))
            midiVal += octaveNums * MusicValues.octaveSize
            let remainderNotes = distFromMiddleC - (octaveNums * 7)
            if remainderNotes > 0 {
                for i in 0...remainderNotes-1 {
                    midiVal += MusicValues.octaveStepSizes[i]
                }
            }
        }
        else if distFromMiddleC < 0 {
            let octaveNums = Int((Double(-distFromMiddleC) / 7.0).rounded(.down))
            midiVal -= octaveNums * MusicValues.octaveSize
            let remainderNotes = -distFromMiddleC - (octaveNums * 7)
            if remainderNotes > 0 {
                for i in 0...remainderNotes-1 {
                    midiVal -= MusicValues.reversedOctaveStepSizes[i]
                }
            }
        }
        if isSharp {
            midiVal += 1
        }
        else if isFlat {
            midiVal -= 1
        }
        return midiVal
    }
    
    public func getAnsArray() -> [Int] {
        return [positionInStaff[0], getMidiVal()]
    }
    
}
