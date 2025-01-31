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
        
        
        
        /*
        
        do {
           try AVAudioSession.sharedInstance().setCategory(.playback)
        }
        catch(let error) {
            print(error.localizedDescription)
        }

        do {
            for i in 0...currentSounds.count-1 {
                var akSampleSampler: AKMIDISampler?
                akSampleSampler = AKMIDISampler()
                var akSampleFile: AKAudioFile?
                akSampleFile = try AKAudioFile(readFileName: "\(currentSounds[i].id).mp3")
                try akSampleSampler!.loadAudioFile(akSampleFile!)
                samplers.setObject(akSampleSampler, forKey: currentSounds[i].id as NSString)
                akSampleSampler = nil
                akSampleFile = nil
            }
        }
        catch {
            print(error)
            return
        }
        */
        /*
        samplers = [AKMIDISampler](repeating: AKMIDISampler(), count: currentSounds.count)
        do {
            for i in 0...currentSounds.count-1 {
                var akSampleSampler: AKMIDISampler?
                akSampleSampler = AKMIDISampler()
                var akSampleFile: AKAudioFile?
                akSampleFile = try AKAudioFile(readFileName: "\(currentSounds[i].id).mp3")
                try akSampleSampler!.loadAudioFile(akSampleFile!)
                samplers[i] = akSampleSampler!
                akSampleSampler = nil
                akSampleFile = nil
            }
        }
        catch {
            print(error)
            return
        }
        */
        //var akNodes = samplers.map { $0! }
        
        
        /*
        var akNodes = samplers.objectEnumerator()?.allObjects as! [AKMIDISampler]
        mixer = AKMixer(akNodes)
        AudioKit.output = mixer
        do {
            try AudioKit.start()
        }
        catch {
            print(error)
        }
 
 */
    }
    
    /*
    func setUpSequencer(noteData: Set<[CGFloat]>) {
        
        _ = sequencer.newTrack()
        let sequenceLength = AKDuration(beats: numberOfMeasures * bpm, tempo: 100)
        sequencer.setLength(sequenceLength)
        let sampler = samplers.object(forKey: selectedNote as NSString)
        sequencer.tracks[0].setMIDIOutput(sampler?.midiIn ?? 0)
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
 */
    /*
    func playNoteSound(note: Note) {
        let whichInstrument = note.noteType
        let whichNote = note.getMidiVal()
        let soundIndex = GameUser.unlockedSoundNames.firstIndex(of: whichInstrument)
        guard let index = soundIndex else {
            print("couldn't get sound")
            return
        }
        do {
            let sampler = samplers.object(forKey: whichInstrument as NSString)
            try sampler?.play(noteNumber: UInt8(whichNote), velocity: 127, channel: 0)
        }
        catch {
            print(error)
        }
    }
    
    func playMetronomeSound() {
        
    }*/
    
}
