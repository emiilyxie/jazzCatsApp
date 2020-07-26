//
//  MusicSceneSound.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 6/20/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension MusicScene {
    
    @objc func setUpSound() {
        var akSampleFile: AKAudioFile!
        var akSampleSampler: AKAppleSampler!
        samplers = [AKAppleSampler](repeating: AKAppleSampler(), count: currentSounds.count)
        do {
            for i in 0...currentSounds.count-1 {
                akSampleSampler = AKAppleSampler()
                akSampleFile = try AKAudioFile(readFileName: "\(currentSounds[i]).mp3")
                try akSampleSampler.loadAudioFile(akSampleFile!)
                samplers[i] = akSampleSampler
            }
        }
        catch {
            print(error)
            return
        }
        
        mixer = AKMixer(samplers)
        AudioKit.output = mixer
        do {
            try AudioKit.start()
        }
        catch {
            print(error)
        }
    }
    
    func playNoteSound(note: Note) {
        let whichInstrument = note.noteType
        let whichNote = note.getMidiVal()
        let soundIndex = currentSounds.firstIndex(of: whichInstrument)
        if soundIndex == nil {
            print("couldn't get sound")
            return
        }
        do {
            try samplers[soundIndex!].play(noteNumber: UInt8(whichNote), velocity: 127, channel: 0)
        }
        catch {
            print(error)
        }
    }
    
}
