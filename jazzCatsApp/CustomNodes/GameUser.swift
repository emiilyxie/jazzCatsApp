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
    
    static func updateField(field: String, text: String) {
        guard let uid = uid else {
            return
        }
        let userRef = getFIRUserDoc(uid: uid)
        
        switch field {
        case "nickname":
            self.nickname = text
            userRef.setData(["nickname" : text], merge: true)
        default:
            print("that field doesn't exist or it cant be mutated")
        }
    }
    
    static func updateField(field: String, count: Int) {
        guard let uid = uid else {
            return
        }
        let userRef = getFIRUserDoc(uid: uid)
        
        switch field {
        case "game-currency":
            if enoughValue(field: field, count: count) {
                self.gameCurrency = gameCurrency + count
                userRef.setData(["game-currency" : self.gameCurrency], merge: true)
            }
        case "hints":
            if enoughValue(field: field, count: count) {
                self.hints = hints + count
                userRef.setData(["hints" : self.hints], merge: true)
            }
        default:
            print("that field doesn't exist or can't be mutated")
        }
    }
    
    static func updateLevelProgress(levelGroup: String, currentLevel: Int) {
        guard let uid = uid else {
            return
        }
        let userRef = getFIRUserDoc(uid: uid)
        
        if let maxUnlockedLevel = self.levelProgress[levelGroup] {
            if maxUnlockedLevel > currentLevel + 1 {
                print("you've already completed this level, no update")
            }
            else {
                self.levelProgress[levelGroup] = currentLevel + 1
                userRef.setData([
                    "level-progress" : [levelGroup : currentLevel + 1]], merge: true)
                self.updateField(field: "game-currency", count: 100)
                self.updateField(field: "hints", count: 1)
            }
        }
        else {
            print("no data for that level group yet")
            // still set the data
            self.levelProgress[levelGroup] = currentLevel + 1
            userRef.setData([
                "level-progress" : [levelGroup : currentLevel + 1]], merge: true)
            self.updateField(field: "game-currency", count: 100)
            self.updateField(field: "hints", count: 1)
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
                var sortedSounds: Dictionary<String, Int> = [:]
                for (sound, index) in (Array(self.sounds).sorted {$0.1 < $1.1}) {
                    sortedSounds[sound] = index
                }
                self.sounds = sortedSounds
                userRef.setData(["sounds" : self.sounds], merge: true) { (err) in
                    if err != nil {
                        print(err!.localizedDescription)
                        return
                    }
                }
            }
        }
    }
    
    static func getFIRUserDoc(uid: String) -> DocumentReference {
        let userRef = Firestore.firestore().collection("/users").document(uid)
        return userRef
    }
}
