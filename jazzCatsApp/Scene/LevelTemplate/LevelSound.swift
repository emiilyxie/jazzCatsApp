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
    
    override func setUpSound() {
        setUpSamples()
        //setUpPlayer()
        
        var AKNodeArray: [AKNode] = []
        for sample in samplers {
            AKNodeArray.append(sample)
        }
        
        /*
        guard let songPlayer = ansSongPlayer else {
            print("song player nonexistent...")
            return
        }
 */
        
        //AKNodeArray.append(songPlayer)
        
        mixer = AKMixer(AKNodeArray)
        //AudioKit.output = answerSong
        AudioKit.output = mixer
        do {
            try AudioKit.start()
        }
        catch {
            print(error)
        }
        
        setUpSequencer(noteData: lvlAns)
    }
    
    func setUpSamples() {
        
        var akSampleFile: AKAudioFile!
        //var akSampleSampler: AKAppleSampler!
        var akSampleSampler = AKMIDISampler()
        //samplers = [AKAppleSampler](repeating: AKAppleSampler(), count: currentSounds.count)
        samplers = [AKMIDISampler](repeating: AKMIDISampler(), count: currentSounds.count)
        do {
            for i in 0...currentSounds.count-1 {
                //akSampleSampler = AKAppleSampler()
                akSampleSampler = AKMIDISampler()
                akSampleFile = try AKAudioFile(readFileName: "\(currentSounds[i].id).mp3")
                try akSampleSampler.loadAudioFile(akSampleFile!)
                samplers[i] = akSampleSampler
            }
        }
        catch {
            print(error)
        }
    }
    
    func setUpPlayer() {
        print(lvlAnsSong)
        var sampleSong: AKAudioFile!
        do {
            sampleSong = try AKAudioFile(readFileName: lvlAnsSong)
            ansSongPlayer = try AKAudioPlayer(file: sampleSong)
        }
        catch {
            print(error)
        }
        ansSongPlayer?.looping = false
    }
}
