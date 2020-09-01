//
//  User.swift
//  jazzCatsApp
//
//  Created by Emily Xie on 6/3/20.
//  Copyright © 2020 Emily Xie. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct GameUser {
    static var uid: String?
    static var email: String?
    static var nickname: String?
    static var levelProgress: Dictionary<String, Int> = [:]
    static var gameCurrency = 100
    static var hints = 10
    static var sounds: [Sound] = []
    static var unlockedSoundNames: [String] = ["cat_basic1", "drumsnare1", "vibes1"]
    static var conductor: Conductor?
    //static var sounds: Dictionary<String, Int> = ["cat_basic1" : 0]
    //static var soundsArr: Array<String> = ["cat_basic1"]
    
    static func setSounds() {
        sounds = []
        let soundsRef = Firestore.firestore().collection("/sounds")
        
        soundsRef.getDocuments { (querySnapshot, err) in
            if err != nil {
                print("cant get sound ref docs")
                return
            }
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    if self.unlockedSoundNames.contains(document.documentID) {
                        let sound = Sound(data: document.data(), unlocked: true)
                        self.sounds.append(sound)
                    }
                }
                self.sounds = Sounds.sortSounds(sounds: sounds)
                let ids = self.sounds.map { $0.id }
                self.unlockedSoundNames = ids
                //print("unlocked sound names 1: \(self.unlockedSoundNames)")
                self.conductor = Conductor(sounds: self.sounds)
            }
            else {
                print("cant get sound query snapshot")
                return
            }
        }
    }
    
    static func updateField(field: String, text: String) -> Bool {
        guard let uid = uid else {
            return false
        }
        let userRef = getFIRUserDoc(uid: uid)
        
        switch field {
        case "nickname":
            self.nickname = text
            userRef.setData(["nickname" : text], merge: true)
            return true
        default:
            print("that field doesn't exist or it cant be mutated")
            return false
        }
    }
    
    static func updateField(field: String, count: Int) -> Bool {
        guard let uid = uid else {
            return false
        }
        let userRef = getFIRUserDoc(uid: uid)
        
        switch field {
        case "game-currency":
            if enoughValue(field: field, count: count) {
                self.gameCurrency = gameCurrency + count
                userRef.setData(["game-currency" : self.gameCurrency], merge: true)
                return true
            }
        case "hints":
            if enoughValue(field: field, count: count) {
                self.hints = hints + count
                userRef.setData(["hints" : self.hints], merge: true)
                return true
            }
        default:
            print("that field doesn't exist or can't be mutated")
            return false
        }
        return false
    }
    
    static func levelAlreadyCompleted(levelGroup: String, currentLevel: Int) -> Bool {
        print("current level: \(currentLevel)")
        if let maxUnlockedLevel = self.levelProgress[levelGroup] {
            print("maxunlocked: \(maxUnlockedLevel)")
            if maxUnlockedLevel > currentLevel {
                return true
            }
        }
        return false
    }
    
    static func updateLevelProgress(levelGroup: String, currentLevel: Int, reward: Dictionary<String, Any>) -> String {
        guard let uid = uid else {
            return ""
        }
        let userRef = getFIRUserDoc(uid: uid)
        
        /*
        if let maxUnlockedLevel = self.levelProgress[levelGroup] {
            if maxUnlockedLevel > currentLevel {
                print("you've already completed this level, no update")
                let rewardMessage = "Nothing, because this level was already completed before."
                return rewardMessage
            }
            else {
                */
                self.levelProgress[levelGroup] = currentLevel + 1
                userRef.setData([
                    "level-progress" : [levelGroup : currentLevel + 1]], merge: true)
                let rewardMessage = self.claimReward(reward: reward)
                return rewardMessage
        /*
            }
        }
        else {
            print("no data for that level group yet")
            // still set the data
            self.levelProgress[levelGroup] = currentLevel + 1
            userRef.setData([
                "level-progress" : [levelGroup : currentLevel + 1]], merge: true)
            let rewardMessage = self.claimReward(reward: reward)
            return rewardMessage
        }
 */
    }
    
    static func enoughValue(field: String, count: Int) -> Bool {
        let withdraw = count * -1
        switch field {
        case "game-currency":
            return withdraw <= self.gameCurrency
        case "hints":
            return withdraw <= self.hints
        default:
            return false
        }
    }
    
    static func updateSounds(newSound: String, completion: @escaping () -> ()) {
        guard let uid = uid else {
            return
        }
        
        if !(self.unlockedSoundNames.contains(newSound)) {
        
            let userRef = getFIRUserDoc(uid: uid)
            let soundsRef = Firestore.firestore().collection("/sounds").document(newSound)
            
            self.unlockedSoundNames.append(newSound)
            print("new unlocked sound names: \(unlockedSoundNames)")
            userRef.setData(["unlocked-sounds" : self.unlockedSoundNames], merge: true)
            // getting index of the sound so that it can be sorted
            
            soundsRef.getDocument { (document, err) in
                if err != nil {
                    print(err!.localizedDescription)
                    return
                }
                if let document = document, document.exists {
                    if let soundData = document.data() {
                        let sound = Sound(data: soundData, unlocked: true)
                        sounds.append(sound)
                        self.sounds = Sounds.sortSounds(sounds: sounds)
                        self.unlockedSoundNames = sounds.map { $0.id }
                        self.conductor?.stopAudioKit()
                        self.conductor?.startAudioKit(sounds: self.sounds)
                        completion()
                    }
                }
            }
        }
        else {
            completion()
        }
    }
    
    static func claimReward(reward: Dictionary<String, Any>) -> String {
        var rewardMessage = ""
            for (field, value) in reward {
                switch field {
                case "hints":
                    if let amount = value as? Int {
                        _ = self.updateField(field: field, count: amount)
                        rewardMessage = "\(rewardMessage)\n+\(value) hints"
                    }
                case "game-currency":
                    if let amount = value as? Int {
                        _ = self.updateField(field: field, count: amount)
                        rewardMessage = "\(rewardMessage)\n+\(value) currency"
                    }
                case "sound":
                    if let sound = Sounds.getSound(from: self.sounds, id: value as! String) {
                        rewardMessage = "\(rewardMessage)\nnew sound: \(sound.name)"
                    }
                default:
                    print("dont recognize field")
                }
            }
            return rewardMessage
    }
    
    /*
    static func claimReward(reward: Dictionary<String, Any>, with soundName: String) -> String {
        var rewardMessage = ""
        for (field, value) in reward {
            switch field {
            case "hints":
                if let amount = value as? Int {
                    _ = self.updateField(field: field, count: amount)
                    rewardMessage = "\(rewardMessage)\n+\(value) hints"
                }
            case "game-currency":
            if let amount = value as? Int {
                _ = self.updateField(field: field, count: amount)
                rewardMessage = "\(rewardMessage)\n+\(value) currency"
            }
            case "sound":
                rewardMessage = "\(rewardMessage)\nnew sound: \(soundName)"
            default:
                print("dont recognize field")
            }
        }
        return rewardMessage
    }
 */
    
    static func getFIRUserDoc(uid: String) -> DocumentReference {
        let userRef = Firestore.firestore().collection("/users").document(uid)
        return userRef
    }
}
