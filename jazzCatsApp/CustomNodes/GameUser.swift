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
    static var gameCurrency = 0
    static var hints = 0
    
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
            self.gameCurrency = gameCurrency + count
            userRef.setData(["game-currency" : self.gameCurrency], merge: true)
        case "hints":
            self.hints = hints + count
            userRef.setData(["hints" : self.hints], merge: true)
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
            }
        }
        else {
            print("no data for that level group yet")
            // still set the data
            self.levelProgress[levelGroup] = currentLevel + 1
            userRef.setData([
                "level-progress" : [levelGroup : currentLevel + 1]], merge: true)
        }
    }
    
    static func getFIRUserDoc(uid: String) -> DocumentReference {
        let userRef = Firestore.firestore().collection("/users").document(uid)
        return userRef
    }
}
