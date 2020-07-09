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
    static var sounds: Dictionary<String, Int> = ["cat_basic1" : 0]
    static var soundsArr: Array<String> = ["cat_basic1"]
    
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
    
    static func updateLevelProgress(levelGroup: String, currentLevel: Int, reward: Dictionary<String, Any>) {
        guard let uid = uid else {
            return
        }
        let userRef = getFIRUserDoc(uid: uid)
        
        if let maxUnlockedLevel = self.levelProgress[levelGroup] {
            if maxUnlockedLevel > currentLevel {
                print("you've already completed this level, no update")
            }
            else {
                self.levelProgress[levelGroup] = currentLevel + 1
                userRef.setData([
                    "level-progress" : [levelGroup : currentLevel + 1]], merge: true)
                self.claimReward(reward: reward)
                //_ = self.updateField(field: "game-currency", count: 100)
                //_ = self.updateField(field: "hints", count: 1)
            }
        }
        else {
            print("no data for that level group yet")
            // still set the data
            self.levelProgress[levelGroup] = currentLevel + 1
            userRef.setData([
                "level-progress" : [levelGroup : currentLevel + 1]], merge: true)
            self.claimReward(reward: reward)
            //_ = self.updateField(field: "game-currency", count: 100)
            //_ = self.updateField(field: "hints", count: 1)
        }
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
    
    static func updateSounds(newSound: String) {
        guard let uid = uid else {
            return
        }
        let userRef = getFIRUserDoc(uid: uid)
        let soundsRef = Firestore.firestore().collection("/sounds").document(newSound)
        
        // getting index of the sound so that it can be sorted
        soundsRef.getDocument { (document, err) in
            if err != nil {
                print(err!.localizedDescription)
                return
            }
            else {
                let soundIndex = document?.get("index") as! Int
                self.sounds[newSound] = soundIndex
                self.sortSounds()
                userRef.setData(["sounds" : self.sounds], merge: true) { (err) in
                    if err != nil {
                        print(err!.localizedDescription)
                        return
                    }
                }
            }
        }
    }
    
    static func claimReward(reward: Dictionary<String, Any>) {
        for (field, value) in reward {
            switch field {
            case "game-currency", "hints":
                if let amount = value as? Int {
                    _ = self.updateField(field: field, count: amount)
                }
            case "sound":
                if let sound = value as? String {
                    _ = self.updateSounds(newSound: sound)
                }
            default:
                print("dont recognize field")
            }
        }
    }
    
    static func getFIRUserDoc(uid: String) -> DocumentReference {
        let userRef = Firestore.firestore().collection("/users").document(uid)
        return userRef
    }
    
    static func sortSounds() {
        var sortedSounds: Array<String> = []
        for (sound, _) in (Array(self.sounds).sorted {$0.1 < $1.1}) {
            sortedSounds.append(sound)
        }
        self.soundsArr = sortedSounds
    }
}
