
import PlaygroundSupport
import SpriteKit
import UIKit

public enum NoteType: String {
    case piano, bass, snare, hihat, cat
    static var allTypes: [NoteType] = [.piano, .bass, .snare, .hihat, .cat]
}

public class Note: SKSpriteNode {
    
    public let noteType: NoteType
    public var positionInStaff = [0,0]
    public var soundBase: String
    public var isSharp = false
    public var isFlat = false
    //public let accidentalDisplacement = CGFloat(10)
    
    public init(type: NoteType) {
        noteType = type
        
        let noteTexture: SKTexture!
        switch type {
        case .piano:
            noteTexture = SKTexture(imageNamed: "piano.png")
            soundBase = "piano"
        case .bass:
            noteTexture = SKTexture(imageNamed: "bass.png")
            soundBase = "bass"
        case .snare:
            noteTexture = SKTexture(imageNamed: "snare.png")
            soundBase = "snare"
        case .hihat:
            noteTexture = SKTexture(imageNamed: "hihat.png")
            soundBase = "hihat"
        case .cat:
            noteTexture = SKTexture(imageNamed: "cat.png")
            soundBase = "cat"
        }
        
        super.init(texture: noteTexture, color: UIColor.clear, size: CGSize(width: 30, height: 30))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func getAudioFile() -> String {
        let noteVal = getNoteName()
        
        if soundBase == "snare" {
            return "\(soundBase)/\(soundBase).mp3"
        }
        /*
        if isSharp {
            return "\(soundBase)/\(soundBase)\(noteVal)s.mp3"
        }
        if isFlat {
            noteVal = trebleNotes[positionInStaff[1]]
            return "\(soundBase)/\(soundBase)\(noteVal)s.mp3"
        }
 */
        return "\(soundBase)/\(soundBase)\(noteVal).mp3"
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
            return "\(trebleNotes[0])"
        }
        if (positionInStaff[1] == 3 || positionInStaff[1] == 7 || positionInStaff[1] == 10) && isFlat { // for enharmonics
            return "\(trebleNotes[positionInStaff[1]])"
        }
        if isSharp {
            return "\(trebleNotes[positionInStaff[1] + 13])"
        }
        if isFlat {
            return "\(trebleNotes[positionInStaff[1] + 12])"
        }
        return "\(trebleNotes[positionInStaff[1] + 1])"
    }
    
}
