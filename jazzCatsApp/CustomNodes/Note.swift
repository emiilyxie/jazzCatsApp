import SpriteKit
import UIKit

public enum NoteType: String {
    case piano, bass, snare, hihat, cat
    static var allTypes: [NoteType] = [.piano, .bass, .snare, .hihat, .cat]
}

public class Note: SKSpriteNode {
    
    public let noteType: NoteType
    public var positionInStaff = [0,0]
    public var universalTimePos: Double?
    public var soundBase: String
    public var audioFile: String
    public var isSharp = false
    public var isFlat = false
    
    public init(type: NoteType) {
        noteType = type
        
        let noteTexture: SKTexture!
        switch type {
        case .piano:
            noteTexture = SKTexture(imageNamed: "piano.png")
            soundBase = "piano"
            audioFile = "piano.mp3"
        case .bass:
            noteTexture = SKTexture(imageNamed: "bass.png")
            soundBase = "bass"
            audioFile = "piano.mp3"
        case .snare:
            noteTexture = SKTexture(imageNamed: "snare.png")
            soundBase = "snare"
            audioFile = "snare.mp3"
        case .hihat:
            noteTexture = SKTexture(imageNamed: "hihat.png")
            soundBase = "hihat"
            audioFile = "snare.mp3"
        case .cat:
            noteTexture = SKTexture(imageNamed: "cat.png")
            soundBase = "cat"
            audioFile = "cat.mp3"
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
    
    public func getMidiVal() -> Int {
        var midiVal = middleCMidi
        let distFromMiddleC = positionInStaff[1] - middleCPos
        if distFromMiddleC > 0 {
            let octaveNums = Int((Double(distFromMiddleC) / 7.0).rounded(.down))
            midiVal += octaveNums * octaveSize
            let remainderNotes = distFromMiddleC - (octaveNums * 7)
            if remainderNotes > 0 {
                for i in 0...remainderNotes-1 {
                    midiVal += octaveStepSizes[i]
                }
            }
        }
        else if distFromMiddleC < 0 {
            let octaveNums = Int((Double(-distFromMiddleC) / 7.0).rounded(.down))
            midiVal -= octaveNums * octaveSize
            let remainderNotes = -distFromMiddleC - (octaveNums * 7)
            if remainderNotes > 0 {
                for i in 0...remainderNotes-1 {
                    midiVal -= reversedOctaveStepSizes[i]
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
}
