//
//  FreestyleSound.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/22/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension Freestyle {
    
    func setUpSound() {
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
            //file = try AKAudioFile(readFileName: "snare.mp3")
            //try sampler.loadAudioFile(file)
        }
        catch {
            print(error)
            return
        }
        
        mixer = AKMixer(samplers)
        AudioKit.output = mixer
        //gloablSampler = akSampleSampler
        //AudioKit.output = gloablSampler
        //AudioKit.output = sampler
        do {
            try AudioKit.start()
        }
        catch {
            print(error)
        }
    }
    
    /*
    func getAvailableAudioFiles() -> [String] {
        var audioArray: [String] = []
        for type in NoteType.allTypes {
            let tempNote = Note(type: type)
            audioArray.append(tempNote.audioFile)
        }
        return audioArray
    }
 */
}
