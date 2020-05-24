//
//  LevelSound.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 5/22/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import UIKit
import SpriteKit
import AudioKit

extension LevelTemplate {
    
    func setUpSound() {
        setUpSamples()
        setUpPlayer()
        
        var AKNodeArray: [AKNode] = []
        for sample in samplers {
            AKNodeArray.append(sample)
        }
        AKNodeArray.append(ansSongPlayer)
        
        mixer = AKMixer(AKNodeArray)
        //AudioKit.output = answerSong
        AudioKit.output = mixer
        do {
            try AudioKit.start()
        }
        catch {
            print(error)
        }
    }
    
    func setUpSamples() {
        let audioArray = getAvailableAudioFiles()
        var akSampleFile: AKAudioFile!
        var akSampleSampler: AKAppleSampler!
        samplers = [AKAppleSampler](repeating: AKAppleSampler(), count: audioArray.count)
        do {
            for i in 0...audioArray.count-1 {
                akSampleSampler = AKAppleSampler()
                akSampleFile = try AKAudioFile(readFileName: audioArray[i])
                try akSampleSampler.loadAudioFile(akSampleFile!)
                samplers[i] = akSampleSampler
            }
        }
        catch {
            print(error)
        }
    }
    
    func setUpPlayer() {
        var sampleSong: AKAudioFile!
        do {
            sampleSong = try AKAudioFile(readFileName: lvlAnsSong)
            ansSongPlayer = try AKAudioPlayer(file: sampleSong)
        }
        catch {
            print(error)
        }
        ansSongPlayer.looping = false
    }
    
    func getAvailableAudioFiles() -> Array<String> {
        var audioArray: [String] = []
        for type in NoteType.allTypes {
            let tempNote = Note(type: type)
            audioArray.append(tempNote.audioFile)
        }
        return audioArray
    }
}
