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
        
        do {
           try AVAudioSession.sharedInstance().setCategory(.playback)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        
        var akSampleFile: AKAudioFile!
        //var akSampleSampler = AKAppleSampler()
        var akSampleSampler: AKMIDISampler!
        //samplers = [AKAppleSampler](repeating: AKAppleSampler(), count: currentSounds.count)
        samplers = [AKMIDISampler](repeating: AKMIDISampler(), count: currentSounds.count)
        do {
            for i in 0...currentSounds.count-1 {
                //akSampleSampler = AKAppleSampler()
                akSampleSampler = AKMIDISampler()
                akSampleFile = try AKAudioFile(readFileName: "\(currentSounds[i].id).mp3")
                //akSampleFile = try AKAudioFile(readFileName: "kitten-meow.wav")
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
    
    func setUpSequencer(noteData: Set<[CGFloat]>) {
        _ = sequencer.newTrack()
        let sequenceLength = AKDuration(beats: numberOfMeasures * bpm, tempo: 100)
        sequencer.setLength(sequenceLength)
        sequencer.tracks[0].setMIDIOutput(samplers[0].midiIn)
        generateSequence(noteData: noteData)

        //sequencer.enableLooping()
        //sequencer.play()
    }
    
    func generateSequence(noteData: Set<[CGFloat]>) {
        let duration = AKDuration(beats: maxPages * numberOfMeasures * bpm)
        
        sequencer.setLength(duration)
        sequencer.setTempo(Double(tempo))
        
        for noteInfo in noteData {
            let noteMeasure = noteInfo[0]
            let noteBeat = noteInfo[1]
            let noteNumber = Int(noteInfo[2])
            let measurelessBeat = Double((noteMeasure - 1) * CGFloat(bpm) + noteBeat - 1)
            
            sequencer.tracks[0].add(noteNumber: MIDINoteNumber(noteNumber), velocity: 127, position: AKDuration(beats: measurelessBeat), duration: AKDuration(beats: 0.9))
        }
        
        /*
        sequencer.tracks[0].add(noteNumber: 60, velocity: 127, position: AKDuration(beats: 0.0), duration: AKDuration(beats: 1.0))
        sequencer.tracks[0].add(noteNumber: 61, velocity: 127, position: AKDuration(beats: 1.0), duration: AKDuration(beats: 1.0))
        sequencer.tracks[0].add(noteNumber: 62, velocity: 127, position: AKDuration(beats: 2.0), duration: AKDuration(beats: 1.0))
        sequencer.tracks[0].add(noteNumber: 63, velocity: 127, position: AKDuration(beats: 3.0), duration: AKDuration(beats: 1.0))
 */
    }
    
    func playNoteSound(note: Note) {
        let whichInstrument = note.noteType
        let whichNote = note.getMidiVal()
        let soundIndex = GameUser.unlockedSoundNames.firstIndex(of: whichInstrument)
        guard let index = soundIndex else {
            print("couldn't get sound")
            return
        }
        do {
            try samplers[index].play(noteNumber: UInt8(whichNote), velocity: 127, channel: 0)
        }
        catch {
            print(error)
        }
    }
    
}
