//
//  Conductor.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 8/11/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import AudioKit

public class Conductor {
    
    var file: AKAudioFile?
    var sampler = AKAppleSampler()
    var midiSampler = AKMIDISampler()
    var sequencer = AKAppleSequencer()
    let sequenceLength = AKDuration(beats: 4.0)
    
    init() {
        do {
            try file =  AKAudioFile(readFileName: "kitten-meow.wav")
            try midiSampler.loadAudioFile(file!)
            AudioKit.output = midiSampler
            AKSettings.playbackWhileMuted = true
            try AudioKit.start()
        }
        catch {
            AKLog("AudioKit did not start!")
        }
    }
    
    func setUpTracks() {
        _ = sequencer.newTrack()
        sequencer.setLength(sequenceLength)
        sequencer.tracks[0].setMIDIOutput(midiSampler.midiIn)
        generateNewMelodicSequence()
        
        sequencer.enableLooping()
        sequencer.setTempo(100)
        sequencer.play()
    }
    
    func generateNewMelodicSequence() {
        sequencer.setLength(sequenceLength)
        sequencer.tracks[0].add(noteNumber: 60, velocity: 127, position: AKDuration(beats: 0.0), duration: AKDuration(beats: 1.0))
        sequencer.tracks[0].add(noteNumber: 61, velocity: 127, position: AKDuration(beats: 1.0), duration: AKDuration(beats: 1.0))
        sequencer.tracks[0].add(noteNumber: 62, velocity: 127, position: AKDuration(beats: 2.0), duration: AKDuration(beats: 1.0))
        sequencer.tracks[0].add(noteNumber: 63, velocity: 127, position: AKDuration(beats: 3.0), duration: AKDuration(beats: 1.0))
        sequencer.setLength(sequenceLength)
    }

}
