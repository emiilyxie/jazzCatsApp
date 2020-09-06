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
    static var defaultEmail: String? = nil
    static var defaultNickname: String? = nil
    static var defaultLevelProgress: Dictionary<String, Int> = [:]
    static var defaultGameCurrency = 100
    static var defaultHints = 10
    static var defaultUnlockedSoundNames: [String] = ["cat_basic1", "drumsnare1", "vibes1"]
    
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
    
    static func getUserDefaults() {
        uid = UserDefaults.standard.string(forKey: "uid")
        email = UserDefaults.standard.string(forKey: "email")
        nickname = UserDefaults.standard.string(forKey: "nickname")
        levelProgress = UserDefaults.standard.dictionary(forKey: "levelProgress") as? [String: Int] ?? [:]
        gameCurrency = UserDefaults.standard.integer(forKey: "gameCurrency")
        hints = UserDefaults.standard.integer(forKey: "hints")
        unlockedSoundNames = Sounds.getSoundArray() ?? defaultUnlockedSoundNames
    }
    
    static func updateUserDefaults(uid: String, email: String, nickname: String, levelProgress: Dictionary<String, Int>, gameCurrency: Int, hints: Int) {
        UserDefaults.standard.set(uid, forKey: "uid")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(nickname, forKey: "nickname")
        UserDefaults.standard.set(levelProgress, forKey: "levelProgress")
        UserDefaults.standard.set(gameCurrency, forKey: "gameCurrency")
        UserDefaults.standard.set(hints, forKey: "hints")
    }
    
    static func updateUserDefaults() {
        UserDefaults.standard.set(uid, forKey: "uid")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(nickname, forKey: "nickname")
        UserDefaults.standard.set(levelProgress, forKey: "levelProgress")
        UserDefaults.standard.set(gameCurrency, forKey: "gameCurrency")
        UserDefaults.standard.set(hints, forKey: "hints")
        Sounds.saveSoundArray(soundArray: unlockedSoundNames)
    }
    
    static func setSounds(completion: @escaping () -> ()) {
        sounds = []
        guard let docDirURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("cant get doc dir")
            return
        }
        
        for soundID in self.unlockedSoundNames {
            var isDirectory = ObjCBool(true)
            let soundURL = docDirURL.appendingPathComponent("sounds/\(soundID)")
            let audioURL = soundURL.appendingPathComponent("\(soundID).mp3")
            let imgURL = soundURL.appendingPathComponent("\(soundID).png")
            if FileManager.default.fileExists(atPath: soundURL.path, isDirectory: &isDirectory), FileManager.default.fileExists(atPath: audioURL.path), FileManager.default.fileExists(atPath: imgURL.path) {
                if let sound = Sounds.getSoundFromFiles(soundID: soundID) {
                    sounds.append(sound)
                }
                else {
                    print("couldnt get sound from files")
                }
            }
            else {
                if let topVC = UIApplication.shared.windows.filter({$0.isKeyWindow}).first?.rootViewController {
                    UIStyling.showAlert(viewController: topVC, text: "Downloading resources. Please stay connected to the internet.", duration: 5)
                }
                Sounds.getSoundFromFirebase(soundID: soundID) { (sound) in
                    sounds.append(sound)
                    Sounds.saveSound(sound: sound) {
                        if sounds.count == unlockedSoundNames.count {
                            sounds = Sounds.sortSounds(sounds: sounds)
                            unlockedSoundNames = sounds.map { $0.id }
                            if self.conductor == nil {
                                self.conductor = Conductor(sounds: self.sounds)
                            }
                            else {
                                self.conductor?.stopAudioKit()
                                self.conductor?.startAudioKit(sounds: self.sounds)
                            }
                            completion()
                        }
                    }
                }
            }
            if sounds.count == unlockedSoundNames.count {
                sounds = Sounds.sortSounds(sounds: sounds)
                unlockedSoundNames = sounds.map { $0.id }
                if self.conductor == nil {
                    self.conductor = Conductor(sounds: self.sounds)
                }
                else {
                    self.conductor?.stopAudioKit()
                    self.conductor?.startAudioKit(sounds: self.sounds)
                }
                completion()
            }
        }
        
    }
        
        /*
        let soundsRef = Firestore.firestore().collection("/sounds")
        
        soundsRef.getDocuments { (querySnapshot, err) in
            if err != nil {
                print("cant get sound ref docs")
                return
            }
            if let querySnapshot = querySnapshot {
                for document in querySnapshot.documents {
                    if self.unlockedSoundNames.contains(document.documentID) {
                        let decoder = JSONDecoder()
                        let data = document.data().map(String.init(describing:)) ?? "nil"
                        let sound = decoder.decode(Sound.self, from: document.)
                        //let sound = Sound(data: document.data(), unlocked: true)
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
 */
    
    static func updateField(field: String, text: String) -> Bool {
        guard let uid = uid else {
            return false
        }
        let userRef = getFIRUserDoc(uid: uid)
        
        switch field {
        case "nickname":
            self.nickname = text
            userRef.setData(["nickname" : text], merge: true)
            UserDefaults.standard.set(nickname, forKey: "nickname")
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
                UserDefaults.standard.set(gameCurrency, forKey: "gameCurrency")
                return true
            }
        case "hints":
            if enoughValue(field: field, count: count) {
                self.hints = hints + count
                userRef.setData(["hints" : self.hints], merge: true)
                UserDefaults.standard.set(hints, forKey: "hints")
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
        self.levelProgress[levelGroup] = currentLevel + 1
        userRef.setData(["level-progress" : [levelGroup : currentLevel + 1]], merge: true)
        UserDefaults.standard.set(levelProgress, forKey: "levelProgress")
        let rewardMessage = self.claimReward(reward: reward)
        return rewardMessage
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
            
            let unlockedSounds = self.unlockedSoundNames + [newSound]
            Sounds.saveSoundArray(soundArray: unlockedSounds)
            userRef.setData(["unlocked-sounds" : unlockedSounds], merge: true)
            
            soundsRef.getDocument { (document, err) in
                if let err = err {
                    print("get sound doc error: \(err.localizedDescription)")
                    return
                }
                if let document = document, document.exists, let data = document.data() {
                    let sound = Sound(data: data)
                    sounds.append(sound)
                    Sounds.saveSound(sound: sound) {
                        self.sounds = Sounds.sortSounds(sounds: sounds)
                        self.unlockedSoundNames = sounds.map { $0.id }
                        Sounds.saveSoundArray(soundArray: self.unlockedSoundNames)
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
