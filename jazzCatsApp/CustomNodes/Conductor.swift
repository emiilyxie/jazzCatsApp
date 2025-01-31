//
//  Conductor.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 8/11/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import AudioKit

public class Conductor {
    
    var samplers: [AKMIDISampler] = []
    var sequencer: AKAppleSequencer?
    var sequenceLength: AKDuration?
    var mixer: AKMixer?
    var sequencerPlaying = false
    
    init(sounds: [Sound]) {
        
        do {
           try AVAudioSession.sharedInstance().setCategory(.playback)
        }
        catch(let error) {
            print(error.localizedDescription)
        }
        
        startAudioKit(sounds: sounds)
    }
    
    func startAudioKit(sounds: [Sound]) {
        sequencer = AKAppleSequencer()
        mixer = AKMixer()
        samplers = [AKMIDISampler](repeating: AKMIDISampler(), count: GameUser.sounds.count)
        
        do {
            let currentSounds = sounds
            for i in 0...currentSounds.count-1 {
                var akSampleSampler: AKMIDISampler?
                akSampleSampler = AKMIDISampler()
                var akSampleFile: AKAudioFile?
                akSampleFile = try AKAudioFile(readFileName: "\(currentSounds[i].id).mp3")
                
                try akSampleSampler!.loadAudioFile(akSampleFile!)
                samplers[i] = (akSampleSampler!)
            }
        }
        catch {
            print(error)
            return
        }
        
        mixer = AKMixer(samplers)
        AudioKit.output = mixer!
        
        do {
            AKSettings.playbackWhileMuted = true
            try AudioKit.start()
        }
        catch {
            print(error)
        }
        
        setUpSequencer()
    }
    
    func setUpSequencer() {
        guard let _ = sequencer else {
            return
        }
        
        _ = sequencer!.newTrack()
        sequencer!.tracks[0].setMIDIOutput(0)
    }
    
    func generateSequence(noteData: Set<[CGFloat]>, tempo: Int, maxPages: Int, numberOfMeasures: Int, bpm: Int) {
        guard let _ = sequencer else {
            return
        }
        sequenceLength = AKDuration(beats: maxPages * numberOfMeasures * bpm)
        
        sequencer!.setLength(sequenceLength!)
        sequencer!.setTempo(Double(tempo))
        
        for noteInfo in noteData {
            let noteMeasure = noteInfo[0]
            let noteBeat = noteInfo[1]
            let noteNumber = Int(noteInfo[2])
            let measurelessBeat = Double((noteMeasure - 1) * CGFloat(bpm) + noteBeat - 1)
            
            sequencer!.tracks[0].add(noteNumber: MIDINoteNumber(noteNumber), velocity: 100, position: AKDuration(beats: measurelessBeat), duration: AKDuration(beats: 8.0))
        }
        
    }
    
    /*
    func playManualSequence(noteData: Set<[CGFloat]>, noteSample: Int, tempo: Int, maxPages: Int, numberOfMeasures: Int, bpm: Int) {
        
        sequencerPlaying = true
        
        let totalLength = AKDuration(beats: maxPages * numberOfMeasures * bpm).seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + totalLength) {
            self.sequencerPlaying = false
        }
        
        for noteInfo in noteData {
            let noteMeasure = noteInfo[0]
            let noteBeat = noteInfo[1]
            let noteNumber = Int(noteInfo[2])
            let measurelessBeat = Double((noteMeasure - 1) * CGFloat(bpm) + noteBeat - 1)
            let time = AKDuration(beats: measurelessBeat, tempo: BPM(tempo)).seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + time) {
                try? self.samplers[noteSample].play(noteNumber: UInt8(noteNumber), velocity: 100, channel: 0)
            }
        }
    }
 */
    
    func clearSequence() {
        guard let _ = sequencer else {
            return
        }
        
        sequencer?.tracks[0].clear()
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
            let sampler = samplers[index]
            try sampler.play(noteNumber: UInt8(whichNote), velocity: 100, channel: 0)
        }
        catch {
            print(error)
        }
    }
    
    func stopAudioKit() {
        do {
            try AudioKit.stop()
            try AudioKit.shutdown()
        } catch  {
            print(error)
        }
    }
}
